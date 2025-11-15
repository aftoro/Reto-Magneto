const { createClient } = require('@supabase/supabase-js');
const OpenAI = require('openai');
const { GoogleGenAI } = require('@google/genai');
const Fuse = require('fuse.js');
const { createCanvas, loadImage } = require('canvas');
const path = require('path');

// Configuración de Supabase
const supabaseUrl = process.env.SUPABASE_URL;
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || process.env.SUPABASE_ANON_KEY;

const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  },
  db: {
    schema: 'public'
  }
});

// Sistema de notificaciones SSE
const clients = new Set();

// Función para enviar notificación a todos los clientes conectados
function sendNotificationToClients(data) {
  const message = `data: ${JSON.stringify(data)}\n\n`;
  clients.forEach(client => {
    try {
      client.write(message);
    } catch (error) {
      console.error('Error enviando notificación SSE:', error);
      clients.delete(client);
    }
  });
}

// Función para notificar nuevo mensaje
function notifyNewMessage(messageData) {
  sendNotificationToClients({
    type: 'new_message',
    data: messageData,
    timestamp: new Date().toISOString()
  });
}

// Función para notificar nueva conversación
function notifyNewConversation(conversationData) {
  sendNotificationToClients({
    type: 'new_conversation',
    data: conversationData,
    timestamp: new Date().toISOString()
  });
}

// Función para notificar nuevo comentario
function notifyNewComment(commentData) {
  sendNotificationToClients({
    type: 'new_comment',
    data: commentData,
    timestamp: new Date().toISOString()
  });
}

// Configuración de OpenAI/OpenRouter

// Configuración de Gemini
function getGeminiClient() {
  if (!process.env.GEMINI_API_KEY) {
    console.error('GEMINI_API_KEY no está configurado');
    return null;
  }

  try {
    // El nuevo SDK @google/genai usa ai.models.generateContent() directamente
    const client = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });
    
    // Validar que el cliente tenga el método necesario
    if (client && client.models && typeof client.models.generateContent === 'function') {
      return client;
    } else {
      console.error('Cliente Gemini inicializado pero no tiene el método models.generateContent');
      return null;
    }
  } catch (error) {
    console.error('Error inicializando cliente Gemini:', error);
    return null;
  }
}

// Configuración de DeepSeek
function getDeepSeekClient() {
  if (!process.env.DEEPSEEK_API_KEY) {
    console.error('DEEPSEEK_API_KEY no está configurado');
    return null;
  }

  return {
    apiKey: process.env.DEEPSEEK_API_KEY,
    baseURL: 'https://api.deepseek.com/v1'
  };
}

// Función para hacer llamadas a DeepSeek
async function callDeepSeek(messages, model = 'deepseek-chat') {
  try {
    const deepSeekConfig = getDeepSeekClient();
    if (!deepSeekConfig) {
      throw new Error('DeepSeek no configurado');
    }

    const response = await fetch(`${deepSeekConfig.baseURL}/chat/completions`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${deepSeekConfig.apiKey}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        model: model,
        messages: messages,
        temperature: 0.7,
        max_tokens: 2000
      })
    });

    if (!response.ok) {
      throw new Error(`DeepSeek API error: ${response.status}`);
    }

    const data = await response.json();
    return data.choices[0].message.content;
  } catch (error) {
    console.error('Error llamando a DeepSeek:', error);
    throw error;
  }
}

// Streaming con DeepSeek (compatibilidad estilo OpenAI)
async function callDeepSeekStream(messages, onDelta, model = 'deepseek-chat') {
  try {
    const deepSeekConfig = getDeepSeekClient();
    if (!deepSeekConfig) {
      throw new Error('DeepSeek no configurado');
    }

    // Timeout y abort controller para evitar cuelgues
    const controller = new AbortController();
    const timeoutMs = 45000;
    const timeout = setTimeout(() => controller.abort(), timeoutMs);

    const response = await fetch(`${deepSeekConfig.baseURL}/chat/completions`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${deepSeekConfig.apiKey}`,
        'Content-Type': 'application/json',
        'Accept': 'text/event-stream'
      },
      body: JSON.stringify({
        model,
        messages,
        temperature: 0.7,
        stream: true
      }),
      signal: controller.signal
    });

    if (!response.ok || !response.body) {
      throw new Error(`DeepSeek stream error: ${response.status}`);
    }

    const decoder = new TextDecoder('utf-8');
    const reader = response.body.getReader();
    let aggregatedText = '';
    let receivedAnyChunk = false;

    // watchdog: si no llegan chunks en 20s, cancelar
    let lastChunkAt = Date.now();
    const watchdog = setInterval(() => {
      if (Date.now() - lastChunkAt > 20000 && !receivedAnyChunk) {
        try { controller.abort(); } catch (_) {}
      }
    }, 5000);

    while (true) {
      const { value, done } = await reader.read();
      if (done) break;
      const chunk = decoder.decode(value, { stream: true });
      const lines = chunk.split(/\r?\n/);
      for (const line of lines) {
        if (!line || !line.startsWith('data:')) continue;
        const data = line.replace(/^data:\s*/, '');
        if (data === '[DONE]') {
          if (onDelta) onDelta({ done: true });
          break;
        }
        try {
          const json = JSON.parse(data);
          const delta = json?.choices?.[0]?.delta?.content || json?.choices?.[0]?.message?.content || '';
          if (delta) {
            aggregatedText += delta;
            if (onDelta) onDelta({ text: delta });
            receivedAnyChunk = true;
            lastChunkAt = Date.now();
          }
        } catch (e) {
          // Ignorar líneas no JSON
        }
      }
    }

    clearTimeout(timeout);
    clearInterval(watchdog);
    return aggregatedText;
  } catch (error) {
    console.error('Error en callDeepSeekStream:', error);
    throw error;
  }
}

// SYSTEM_PROMPT actualizado con identidad de marca
const { BRAND_IDENTITY } = require('./constants');

const SYSTEM_PROMPT = `Eres Magneto, un asistente virtual que representa a Magneto Empleos. Tu misión es ayudar a las personas a encontrar oportunidades que transformen sus carreras.

IDENTIDAD DE MARCA - MAGNETO EMPLEOS:
${BRAND_IDENTITY.TONE.description}

TONO DE COMUNICACIÓN:
${BRAND_IDENTITY.TONE.characteristics.map(c => `- ${c}`).join('\n')}
- ${BRAND_IDENTITY.TONE.purpose}

ESLOGAN PRINCIPAL:
"${BRAND_IDENTITY.MAIN_SLOGAN}"

ESLÓGANES SECUNDARIOS:
${BRAND_IDENTITY.SECONDARY_SLOGANS.map(s => `- "${s}"`).join('\n')}

MENSAJES CLAVE QUE DEBES TRANSMITIR:
${BRAND_IDENTITY.KEY_MESSAGES.map(m => `- "${m}"`).join('\n')}

BENEFICIOS QUE OFRECEMOS:
${BRAND_IDENTITY.CANDIDATE_BENEFITS.map(b => `- ${b}`).join('\n')}

PERSONALIDAD:
- Eres cercano, humano y empático
- Comunicas de manera amigable y accesible
- Eres positivo, motivador y directo
- Mantienes equilibrio entre profesionalismo y calidez
- Usas lenguaje sencillo, conciso e inclusivo
- Evitas tecnicismos o lenguaje excesivamente formal
- Te expresas con energía y dinamismo

ESTILO DE COMUNICACIÓN:
- Habla de manera natural y cercana
- Usa emojis estratégicamente para darle vida a los mensajes
- Haz preguntas que muestren interés genuino
- Da consejos prácticos con toque personal
- Sé honesto sobre el mercado laboral pero siempre positivo y motivador
- Transmite que cada oportunidad puede transformar la vida del candidato

FORMATO DE RESPUESTA:
- Saluda cálidamente y de manera cercana
- Responde con información útil y práctica
- Incluye un consejo extra o dato motivacional
- Termina invitando a seguir conversando o a tomar acción
- Usa los mensajes clave de la marca cuando sea relevante

FORMATO DE TEXTO PARA INSTAGRAM:
- Usa *texto* para NEGRITA (títulos, palabras importantes)
- Usa _texto_ para cursiva (énfasis suave)
- Usa ~texto~ para tachado (humor, correcciones)
- Usa emojis estratégicamente para darle vida

EJEMPLO DE FORMATO:
*¡Oportunidades que transforman!* 🌟
_No es otro empleo, es avanzar hacía tus sueños_ 💼
¿Qué estás esperando? Tu próxima postulación puede cambiar tu vida 🚀

RECOLECCIÓN DE DATOS NATURAL:
Recolecta información del usuario de manera CONVERSACIONAL y NATURAL:

CUÁNDO PREGUNTAR:
- Si menciona trabajo, empleo, vacantes → Pregunta por profesión y experiencia
- Si pide ayuda con CV → Pregunta por habilidades y estudios  
- Si busca oportunidades → Pregunta por ubicación y disponibilidad
- Si es conversación casual → Haz preguntas relacionadas al contexto

CÓMO PREGUNTAR:
- Integra las preguntas en la conversación naturalmente
- Una pregunta por mensaje
- Usa el contexto para hacer preguntas relevantes
- Si no responde, continúa la conversación normalmente

DATOS A RECOLECTAR:
- Nombre completo (user_full_name)
- Profesión/área de trabajo (user_profession)
- Estudios/formación (user_studies)
- Años de experiencia (user_experience_years)
- Habilidades principales (user_skills)
- Ubicación (user_location)
- Idiomas (user_languages)
- Expectativa salarial (user_salary_expectation)
- Disponibilidad (user_availability)
- Intereses profesionales (user_interests)
- Preferencias de empresa (user_company_size_preference)
- Industria preferida (user_industry_preference)
- Modalidad de trabajo (user_work_mode_preference)
- Nivel profesional (user_career_level)
- Portfolio/LinkedIn/GitHub (user_portfolio_url, user_linkedin_url, user_github_url)

PRIVACIDAD Y CONTEXTO EN COMENTARIOS:
- En respuestas a COMENTARIOS públicos, NO reveles datos personales del usuario (nombre completo, ubicación específica, correo, teléfono, etc.).
- Responde centrado en el CONTEXTO DEL POST (tema del contenido y su caption). Si el usuario pide información sensible, invita a continuar por DM sin revelarla.
- Usa un tono amable y breve; evita preguntas personales en comentarios públicos.
- Transmite los mensajes clave de la marca de manera natural

EJEMPLOS DE INTEGRACIÓN NATURAL:
- "¡Qué bueno que estés buscando trabajo! Estamos aquí para ayudarte a encontrar la oportunidad que estabas buscando. ¿En qué área te desempeñas?"
- "Perfecto, desarrollador. Tu próxima postulación puede cambiar tu vida. ¿Cuántos años llevas en esto?"
- "Excelente experiencia. No esperes, elige el lugar donde quieres estar. ¿En qué ciudad estás ubicado?"
- "Genial, ¿tienes algún portafolio o LinkedIn que puedas compartir? Impulsamos. Conectamos. Transformamos 🚀"

CONTEXTO DE MAGNETO EMPLEOS:
- Plataforma de empleos en Latinoamérica
- Conectamos candidatos con empresas de todos los tamaños
- Acceso a miles de vacantes
- Postulaciones ilimitadas y gratuitas
- Formación gratuita en empleabilidad
- Nuestro propósito: Impulsar carreras y transformar vidas

Recuerda: Sé auténtico, útil y haz que la búsqueda de empleo se sienta menos estresante. Transmite que cada oportunidad es una posibilidad de transformación. Eres el puente entre los candidatos y sus sueños profesionales.`;

// Función para obtener posts y stories recientes para contexto del AI agent
async function getRecentContentForAI(limit = 5) {
  try {
    // Obtener posts recientes
    const { data: posts, error: postsError } = await supabase
      .from('instagram_posts')
      .select('id, caption, image_url, created_at, ai_generated')
      .eq('status', 'published')
      .order('created_at', { ascending: false })
      .limit(limit);

    if (postsError) {
      console.error('Error obteniendo posts:', postsError);
    }

    // Obtener stories recientes
    const { data: stories, error: storiesError } = await supabase
      .from('instagram_stories')
      .select('id, image_url, created_at, ai_generated')
      .eq('status', 'published')
      .order('created_at', { ascending: false })
      .limit(limit);

    if (storiesError) {
      console.error('Error obteniendo stories:', storiesError);
    }

    const recentContent = {
      posts: posts || [],
      stories: stories || [],
      total: (posts?.length || 0) + (stories?.length || 0)
    };

    return recentContent;
  } catch (error) {
    console.error('Error obteniendo contenido reciente:', error);
    return { posts: [], stories: [], total: 0 };
  }
}

// Función para obtener contenido relevante basado en el contexto del usuario
async function getRelevantContentForUser(userData, limit = 3) {
  try {
    if (!userData || !userData.user_profession) {
      return await getRecentContentForAI(limit);
    }

    const userProfession = userData.user_profession.toLowerCase();
    const userSkills = userData.user_skills?.join(' ').toLowerCase() || '';
    const userLocation = userData.user_location?.toLowerCase() || '';

    // Buscar posts que contengan palabras clave relacionadas con el usuario
    const searchTerms = [userProfession, ...(userData.user_skills || [])];
    const searchQuery = searchTerms.join(' | ');

    const { data: relevantPosts, error: postsError } = await supabase
      .from('instagram_posts')
      .select('id, caption, image_url, created_at, ai_generated')
      .eq('status', 'published')
      .textSearch('caption', searchQuery)
      .order('created_at', { ascending: false })
      .limit(limit);

    if (postsError) {
      console.error('Error en búsqueda de posts:', postsError);
    }

    // Si no hay posts relevantes, obtener los más recientes
    const finalPosts = relevantPosts?.length > 0 ? relevantPosts : 
      await supabase
        .from('instagram_posts')
        .select('id, caption, image_url, created_at, ai_generated')
        .eq('status', 'published')
        .order('created_at', { ascending: false })
        .limit(limit)
        .then(({ data }) => data || []);

    // Obtener stories recientes
    const { data: stories, error: storiesError } = await supabase
      .from('instagram_stories')
      .select('id, image_url, created_at, ai_generated')
      .eq('status', 'published')
      .order('created_at', { ascending: false })
      .limit(limit);

    if (storiesError) {
      console.error('Error obteniendo stories:', storiesError);
    }

    const relevantContent = {
      posts: finalPosts || [],
      stories: stories || [],
      total: (finalPosts?.length || 0) + (stories?.length || 0),
      personalized: relevantPosts?.length > 0
    };

    return relevantContent;
  } catch (error) {
    console.error('Error obteniendo contenido relevante:', error);
    return { posts: [], stories: [], total: 0, personalized: false };
  }
}

// Función para obtener estadísticas de posts con análisis de IA
async function getPostsAnalytics() {
  try {
    // Obtener posts con comentarios
    const { data: posts, error: postsError } = await supabase
      .from('instagram_posts')
      .select(`
        id,
        caption,
        created_at,
        instagram_post_id,
        ai_generated,
        instagram_comments (
          id,
          comment_text,
          username,
          created_at,
          is_ai_response
        )
      `)
      .eq('status', 'published')
      .order('created_at', { ascending: false })
      .limit(50);

    if (postsError) {
      console.error('Error obteniendo posts:', postsError);
      return null;
    }

    // Analizar engagement básico
    const totalPosts = posts.length;
    const aiGeneratedPosts = posts.filter(post => post.ai_generated).length;
    const manualPosts = totalPosts - aiGeneratedPosts;

    // Analizar comentarios por tipo
    const allComments = posts.flatMap(post => post.instagram_comments || []);
    const totalComments = allComments.length;
    const aiResponses = allComments.filter(comment => comment.is_ai_response).length;
    const userComments = allComments.filter(comment => !comment.is_ai_response).length;

    // Calcular engagement promedio (comentarios por post)
    const avgEngagement = totalPosts > 0 ? totalComments / totalPosts : 0;

    // Extraer sectores y cargos de captions
    const sectors = [];
    const positions = [];
    
    posts.forEach(post => {
      if (post.caption) {
        const caption = post.caption.toLowerCase();
        
        // Detectar sectores
        if (caption.includes('desarrollador') || caption.includes('programador')) sectors.push('Tecnología');
        if (caption.includes('marketing') || caption.includes('ventas')) sectors.push('Marketing/Ventas');
        if (caption.includes('diseño') || caption.includes('ux')) sectors.push('Diseño');
        if (caption.includes('finanzas') || caption.includes('contabilidad')) sectors.push('Finanzas');
        if (caption.includes('recursos humanos') || caption.includes('rrhh')) sectors.push('RRHH');
        if (caption.includes('salud') || caption.includes('médico')) sectors.push('Salud');
        if (caption.includes('educación') || caption.includes('profesor')) sectors.push('Educación');
        
        // Detectar posiciones específicas
        if (caption.includes('frontend')) positions.push('Frontend Developer');
        if (caption.includes('backend')) positions.push('Backend Developer');
        if (caption.includes('full stack')) positions.push('Full Stack Developer');
        if (caption.includes('react')) positions.push('React Developer');
        if (caption.includes('node')) positions.push('Node.js Developer');
        if (caption.includes('python')) positions.push('Python Developer');
        if (caption.includes('java')) positions.push('Java Developer');
        if (caption.includes('analista')) positions.push('Analista');
        if (caption.includes('gerente')) positions.push('Gerente');
        if (caption.includes('coordinador')) positions.push('Coordinador');
      }
    });

    // Contar frecuencia
    const sectorCounts = sectors.reduce((acc, sector) => {
      acc[sector] = (acc[sector] || 0) + 1;
      return acc;
    }, {});

    const positionCounts = positions.reduce((acc, position) => {
      acc[position] = (acc[position] || 0) + 1;
      return acc;
    }, {});

    return {
      totalPosts,
      aiGeneratedPosts,
      manualPosts,
      totalComments,
      avgEngagement: Math.round(avgEngagement * 100) / 100,
      aiResponses,
      userComments,
      topSectors: Object.entries(sectorCounts)
        .sort(([,a], [,b]) => b - a)
        .slice(0, 5)
        .map(([sector, count]) => ({ sector, count })),
      topPositions: Object.entries(positionCounts)
        .sort(([,a], [,b]) => b - a)
        .slice(0, 5)
        .map(([position, count]) => ({ position, count })),
      posts: posts.map(post => ({
        id: post.id,
        caption: post.caption?.substring(0, 100) + '...',
        comments: post.instagram_comments?.length || 0,
        aiGenerated: post.ai_generated,
        created_at: post.created_at
      }))
    };
  } catch (error) {
    console.error('Error analizando posts:', error);
    return null;
  }
}

// Función para obtener estadísticas de DMs y conversaciones
async function getDMAnalytics() {
  try {
    // Obtener conversaciones de DM con datos de usuario directamente de la tabla conversaciones
    const { data: conversations, error: convError } = await supabase
      .from('conversaciones')
      .select(`
        id,
        user_id,
        created_at,
        updated_at,
        user_profession,
        user_experience_years,
        user_location,
        user_skills,
        user_data_completion_percentage,
        mensajes (
          id,
          content,
          message_type,
          is_ai_generated,
          created_at
        )
      `)
      .eq('platform', 'instagram')
      .eq('conversation_type', 'dm')
      .order('created_at', { ascending: false })
      .limit(100);

    if (convError) {
      console.error('Error obteniendo conversaciones:', convError);
      return null;
    }

    // Analizar datos de usuarios
    const totalConversations = conversations.length;
    const activeConversations = conversations.filter(conv => 
      conv.updated_at && 
      new Date(conv.updated_at) > new Date(Date.now() - 7 * 24 * 60 * 60 * 1000)
    ).length;

    // Analizar profesiones
    const professions = conversations
      .map(conv => conv.user_profession)
      .filter(Boolean);
    
    const professionCounts = professions.reduce((acc, profession) => {
      acc[profession] = (acc[profession] || 0) + 1;
      return acc;
    }, {});

    // Analizar ubicaciones
    const locations = conversations
      .map(conv => conv.user_location)
      .filter(Boolean);
    
    const locationCounts = locations.reduce((acc, location) => {
      acc[location] = (acc[location] || 0) + 1;
      return acc;
    }, {});

    // Analizar experiencia
    const experienceLevels = conversations
      .map(conv => conv.user_experience_years)
      .filter(Boolean)
      .map(years => {
        if (years <= 1) return 'Junior (0-1 años)';
        if (years <= 3) return 'Semi-Senior (1-3 años)';
        if (years <= 5) return 'Mid-Level (3-5 años)';
        if (years <= 10) return 'Senior (5-10 años)';
        return 'Lead/Expert (10+ años)';
      });

    const experienceCounts = experienceLevels.reduce((acc, level) => {
      acc[level] = (acc[level] || 0) + 1;
      return acc;
    }, {});

    // Analizar completitud de datos
    const completionRates = conversations
      .map(conv => conv.user_data_completion_percentage || 0)
      .filter(rate => rate > 0);

    const avgCompletion = completionRates.length > 0 
      ? completionRates.reduce((sum, rate) => sum + rate, 0) / completionRates.length 
      : 0;

    // Analizar mensajes
    const allMessages = conversations.flatMap(conv => conv.mensajes || []);
    const aiMessages = allMessages.filter(msg => msg.is_ai_generated).length;
    const userMessages = allMessages.filter(msg => !msg.is_ai_generated).length;

    return {
      totalConversations,
      activeConversations,
      avgCompletion: Math.round(avgCompletion * 100) / 100,
      topProfessions: Object.entries(professionCounts)
        .sort(([,a], [,b]) => b - a)
        .slice(0, 5)
        .map(([profession, count]) => ({ profession, count })),
      topLocations: Object.entries(locationCounts)
        .sort(([,a], [,b]) => b - a)
        .slice(0, 5)
        .map(([location, count]) => ({ location, count })),
      experienceDistribution: Object.entries(experienceCounts)
        .sort(([,a], [,b]) => b - a)
        .map(([level, count]) => ({ level, count })),
      messageStats: {
        total: allMessages.length,
        aiGenerated: aiMessages,
        userGenerated: userMessages,
        aiRatio: allMessages.length > 0 ? Math.round((aiMessages / allMessages.length) * 100) : 0
      }
    };
  } catch (error) {
    console.error('Error analizando DMs:', error);
    return null;
  }
}

// Función para generar sugerencias de mejora para un preview
async function generateImproveSuggestions(topic, style, targetAudience, imageUrl) {
  try {
    const isReel = style === 'reel';
    const contentType = isReel ? 'Instagram Reel' : 'Instagram Post/Story';
    const mediaType = isReel ? 'VIDEO' : 'IMAGEN';
    const reelSpecific = isReel ? '\n\nESPECÍFICO PARA REEL:\n- Considera elementos de engagement y viralidad\n- Sugiere mejoras para retención de audiencia\n- Incluye aspectos de timing y ritmo\n- Enfócate en hashtags trending y calls-to-action dinámicos' : '';

    const { BRAND_IDENTITY } = require('./constants');
    
    const suggestionsPrompt = `Analiza este contenido de ${contentType} y genera 5 sugerencias específicas de mejora:

TEMA: ${topic}
ESTILO: ${style}
AUDIENCIA: ${targetAudience}
${mediaType}: ${imageUrl}${reelSpecific}

CONTEXTO DE MARCA - MAGNETO EMPLEOS:
- Eslogan: "${BRAND_IDENTITY.MAIN_SLOGAN}"
- Tono: Cercano, humano, positivo, motivador, directo
- Mensajes clave: ${BRAND_IDENTITY.KEY_MESSAGES.join(' | ')}
- Propósito: Impulsar carreras y transformar vidas

Las sugerencias deben alinearse con la identidad de marca: contenido que sea cercano, motivador, positivo y que transmita que las oportunidades pueden transformar vidas.

Genera sugerencias en este formato JSON:
{
  "suggestions": [
    {
      "category": "Visual",
      "title": "Título de la sugerencia",
      "description": "Descripción detallada de la mejora",
      "priority": "high|medium|low",
      "impact": "Descripción del impacto esperado"
    },
    {
      "category": "Contenido",
      "title": "Título de la sugerencia", 
      "description": "Descripción detallada de la mejora",
      "priority": "high|medium|low",
      "impact": "Descripción del impacto esperado"
    },
    {
      "category": "Engagement",
      "title": "Título de la sugerencia",
      "description": "Descripción detallada de la mejora", 
      "priority": "high|medium|low",
      "impact": "Descripción del impacto esperado"
    },
    {
      "category": "Técnico",
      "title": "Título de la sugerencia",
      "description": "Descripción detallada de la mejora",
      "priority": "high|medium|low", 
      "impact": "Descripción del impacto esperado"
    },
    {
      "category": "Estrategia",
      "title": "Título de la sugerencia",
      "description": "Descripción detallada de la mejora",
      "priority": "high|medium|low",
      "impact": "Descripción del impacto esperado"
    }
  ]
}

Las categorías pueden ser: Visual, Contenido, Engagement, Técnico, Estrategia, Hashtags, Timing, etc.
Sé específico y práctico en las sugerencias.`;

    const messages = [
      {
        role: "system",
        content: `Eres un experto en social media y growth especializado en contenido de empleos y oportunidades laborales.

MARCA: Magneto Empleos - "${BRAND_IDENTITY.MAIN_SLOGAN}"

TONO DE MARCA:
- Cercano, humano, amigable, accesible, empático
- Positivo, motivador, directo
- Lenguaje sencillo, conciso e inclusivo
- Sin tecnicismos excesivos
- Energía y dinamismo

Las sugerencias deben ayudar a crear contenido que impulse carreras y transmita que las oportunidades transforman vidas.

Devuelve SIEMPRE JSON válido siguiendo el esquema solicitado.`
      },
      {
        role: "user",
        content: suggestionsPrompt
      }
    ];

    const suggestionsText = await callDeepSeek(messages);

    try {
      // Limpiar el texto de markdown si está presente
      let cleanText = suggestionsText;
      if (cleanText.includes('```json')) {
        cleanText = cleanText.replace(/```json\s*/, '').replace(/\s*```$/, '');
      }
      if (cleanText.includes('```')) {
        cleanText = cleanText.replace(/```\s*/, '').replace(/\s*```$/, '');
      }
      
      const suggestionsData = JSON.parse(cleanText);
      return suggestionsData.suggestions || [];
    } catch (parseError) {
      console.error('Error parseando sugerencias:', parseError);
      // Fallback: generar sugerencias básicas
      return [
        {
          category: "Visual",
          title: "Mejorar composición visual",
          description: "Ajustar la distribución de elementos para mayor impacto visual",
          priority: "medium",
          impact: "Mayor atractivo visual y engagement"
        },
        {
          category: "Contenido", 
          title: "Optimizar mensaje principal",
          description: "Refinar el mensaje para mayor claridad y relevancia",
          priority: "high",
          impact: "Mejor comprensión y conexión con la audiencia"
        },
        {
          category: "Engagement",
          title: "Agregar call-to-action",
          description: "Incluir una llamada a la acción más clara y atractiva",
          priority: "high", 
          impact: "Mayor interacción y conversión"
        },
        {
          category: "Técnico",
          title: "Optimizar para móvil",
          description: "Asegurar que el contenido se vea perfecto en dispositivos móviles",
          priority: "medium",
          impact: "Mejor experiencia de usuario móvil"
        },
        {
          category: "Estrategia",
          title: "Mejorar timing de publicación",
          description: "Considerar el mejor momento para publicar según la audiencia",
          priority: "low",
          impact: "Mayor alcance y visibilidad"
        }
      ];
    }
  } catch (error) {
    console.error('Error generando sugerencias de mejora con DeepSeek:', error);
    return [];
  }
}

// Función para generar múltiples opciones de caption
async function generateCaptionOptions(topic, style, targetAudience) {
  try {
    
    const isReel = style === 'reel';
    const contentType = isReel ? 'Instagram Reel' : 'Instagram Post/Story';
    const reelSpecific = isReel ? '\n\nESPECÍFICO PARA REEL:\n- Caption más corto y directo (máximo 100 caracteres)\n- Enfoque en engagement y viralidad\n- Incluir elementos de trending/hashtags populares\n- Call-to-action más dinámico y urgente' : '';

    const { BRAND_IDENTITY } = require('./constants');
    
    const captionPrompt = `Crea 3 opciones diferentes de caption para ${contentType} sobre: "${topic}"

ESTILO: ${style}
AUDIENCIA: ${targetAudience}${reelSpecific}

IDENTIDAD DE MARCA - MAGNETO EMPLEOS:
- Eslogan principal: "${BRAND_IDENTITY.MAIN_SLOGAN}"
- Eslóganes secundarios: ${BRAND_IDENTITY.SECONDARY_SLOGANS.join(', ')}
- Mensajes clave: ${BRAND_IDENTITY.KEY_MESSAGES.join(' | ')}
- Tono: Cercano, humano, amigable, accesible, empático, positivo, motivador, directo
- Lenguaje: Sencillo, conciso, inclusivo, sin tecnicismos excesivos
- Propósito: Impulsar carreras y transformar vidas

INSTRUCCIONES:
- Usa el eslogan principal o secundarios cuando sea natural
- Incorpora los mensajes clave de manera orgánica
- Mantén el tono cercano, positivo y motivador
- Evita lenguaje excesivamente formal o técnico
- Transmite energía y dinamismo
- Enfócate en que cada oportunidad puede transformar la vida del candidato

Responde SOLO con JSON válido en este formato exacto:
{
  "captions": [
    {
      "id": "option_1",
      "title": "Opción Profesional",
      "content": "Contenido del caption aquí",
      "style": "Profesional y directo",
      "length": "medium",
      "hashtags": ["#hashtag1", "#hashtag2"],
      "call_to_action": "Llamada a la acción"
    },
    {
      "id": "option_2",
      "title": "Opción Personal", 
      "content": "Contenido del caption aquí",
      "style": "Personal y storytelling",
      "length": "medium",
      "hashtags": ["#hashtag1", "#hashtag2"],
      "call_to_action": "Llamada a la acción"
    },
    {
      "id": "option_3",
      "title": "Opción Creativa",
      "content": "Contenido del caption aquí",
      "style": "Creativo y llamativo",
      "length": "short",
      "hashtags": ["#hashtag1", "#hashtag2"],
      "call_to_action": "Llamada a la acción"
    }
  ]
}

Sé conciso y directo. Incluye hashtags relevantes y calls-to-action efectivos.`;

    const messages = [
      {
        role: "system",
        content: `Eres copywriter experto para Instagram especializado en contenido de empleos y oportunidades laborales. 

Tu marca es Magneto Empleos con el eslogan "${BRAND_IDENTITY.MAIN_SLOGAN}".

TONO DE MARCA:
- Cercano, humano, amigable, accesible, empático
- Positivo, motivador, directo
- Equilibrio entre profesionalismo y calidez
- Lenguaje sencillo, conciso e inclusivo
- Sin tecnicismos excesivos
- Energía y dinamismo

MENSAJES CLAVE:
${BRAND_IDENTITY.KEY_MESSAGES.map(m => `- "${m}"`).join('\n')}

Devuelve SIEMPRE JSON válido con las opciones solicitadas, incorporando la identidad de marca de manera natural.`
      },
      {
        role: "user",
        content: captionPrompt
      }
    ];

    const captionText = await callDeepSeek(messages);


    try {
      // Limpiar el texto de markdown si está presente
      let cleanText = captionText;
      if (cleanText.includes('```json')) {
        cleanText = cleanText.replace(/```json\s*/, '').replace(/\s*```$/, '');
      }
      if (cleanText.includes('```')) {
        cleanText = cleanText.replace(/```\s*/, '').replace(/\s*```$/, '');
      }
      
      // Limpiar y corregir errores comunes en el JSON
      cleanText = cleanText.trim();
      
      // Intentar corregir errores comunes de sintaxis JSON
      // 1. Corregir hashtags sin comilla de apertura después de comilla de cierre: ", #hashtag" -> ", "#hashtag"
      //    Caso específico: ["#hashtag1", "#hashtag2", #hashtag3", ...]
      cleanText = cleanText.replace(/",\s*#([^",\]]+")/g, (match, hashtag) => {
        // hashtag ya incluye la comilla de cierre, solo agregamos la de apertura
        return '", "#' + hashtag;
      });
      // 2. Corregir hashtags sin comillas completas: ", #hashtag" -> ", "#hashtag""
      cleanText = cleanText.replace(/,\s*#([^",\]]+)(?=")/g, ', "#$1"');
      // 3. Corregir hashtags sin comillas al final del array: ", #hashtag] -> ", "#hashtag"]
      cleanText = cleanText.replace(/,\s*#([^",\]]+)\]/g, ', "#$1"]');
      // 4. Corregir hashtags al inicio del array sin comillas: [#hashtag -> ["#hashtag
      cleanText = cleanText.replace(/\[\s*#([^",\]]+)/g, '["#$1"');
      // 5. Corregir hashtags con comilla de cierre pero sin apertura dentro de arrays: ", #hashtag", -> ", "#hashtag",
      cleanText = cleanText.replace(/",\s*#([^",\]]+"),/g, '", "#$1",');
      
      const captionData = JSON.parse(cleanText);
      return captionData;
    } catch (parseError) {
      console.error('Error parseando opciones de caption:', parseError);
      
      // Intentar extraer JSON del texto usando regex como último recurso
      try {
        // Primero limpiar markdown si está presente
        let recoveryText = captionText;
        if (recoveryText.includes('```json')) {
          recoveryText = recoveryText.replace(/```json\s*/, '').replace(/\s*```$/, '');
        }
        if (recoveryText.includes('```')) {
          recoveryText = recoveryText.replace(/```\s*/, '').replace(/\s*```$/, '');
        }
        
        const jsonMatch = recoveryText.match(/\{[\s\S]*\}/);
        if (jsonMatch) {
          let jsonText = jsonMatch[0].trim();
          
          // Aplicar todas las correcciones
          // 1. Corregir hashtags sin comilla de apertura después de comilla de cierre: ", #hashtag" -> ", "#hashtag"
          jsonText = jsonText.replace(/",\s*#([^",\]]+")/g, (match, hashtag) => {
            return '", "#' + hashtag;
          });
          // 2. Corregir hashtags sin comillas completas: ", #hashtag" -> ", "#hashtag""
          jsonText = jsonText.replace(/,\s*#([^",\]]+)(?=")/g, ', "#$1"');
          // 3. Corregir hashtags sin comillas al final del array: ", #hashtag] -> ", "#hashtag"]
          jsonText = jsonText.replace(/,\s*#([^",\]]+)\]/g, ', "#$1"]');
          // 4. Corregir hashtags al inicio del array sin comillas: [#hashtag -> ["#hashtag
          jsonText = jsonText.replace(/\[\s*#([^",\]]+)/g, '["#$1"');
          // 5. Corregir hashtags con comilla de cierre pero sin apertura dentro de arrays: ", #hashtag", -> ", "#hashtag",
          jsonText = jsonText.replace(/",\s*#([^",\]]+"),/g, '", "#$1",');
          
          const captionData = JSON.parse(jsonText);
          return captionData;
        }
      } catch (recoveryError) {
        console.error('Error en recuperación automática:', recoveryError);
      }
      
      // Fallback si hay error parseando
      return {
        captions: [
          {
            id: "option_1",
            title: "Opción Profesional",
            content: `¡Nueva oportunidad! ${topic}\n\n${style} para ${targetAudience}\n\n#OportunidadLaboral #TechJobs #Desarrollo`,
            style: "Profesional y directo",
            length: "medium",
            hashtags: ["#OportunidadLaboral", "#TechJobs", "#Desarrollo"],
            call_to_action: "¡Aplica ahora!"
          },
          {
            id: "option_2", 
            title: "Opción Personal",
            content: `¿Buscas crecer profesionalmente? ${topic}\n\nUna oportunidad ${style} perfecta para ${targetAudience}\n\n#CrecimientoProfesional #CarreraTech #Oportunidad`,
            style: "Personal y motivacional",
            length: "medium",
            hashtags: ["#CrecimientoProfesional", "#CarreraTech", "#Oportunidad"],
            call_to_action: "¡Comparte tu experiencia!"
          },
          {
            id: "option_3",
            title: "Opción Creativa",
            content: `🚀 ${topic}\n\n${style} para ${targetAudience}\n\n¡No te lo pierdas! 💼\n\n#TechLife #Oportunidad #Innovacion`,
            style: "Creativo y llamativo",
            length: "short",
            hashtags: ["#TechLife", "#Oportunidad", "#Innovacion"],
            call_to_action: "¡Comenta si te interesa!"
          }
        ]
      };
    }
  } catch (error) {
    console.error('Error generando opciones de caption con DeepSeek:', error);
    return {
      captions: [
        {
          id: "option_1",
          title: "Opción Profesional",
          content: `¡Nueva oportunidad! ${topic}\n\n${style} para ${targetAudience}\n\n#OportunidadLaboral #TechJobs #Desarrollo`,
          style: "Profesional y directo",
          length: "medium",
          hashtags: ["#OportunidadLaboral", "#TechJobs", "#Desarrollo"],
          call_to_action: "¡Aplica ahora!"
        },
        {
          id: "option_2", 
          title: "Opción Personal",
          content: `¿Buscas crecer profesionalmente? ${topic}\n\nUna oportunidad ${style} perfecta para ${targetAudience}\n\n#CrecimientoProfesional #CarreraTech #Oportunidad`,
          style: "Personal y motivacional",
          length: "medium",
          hashtags: ["#CrecimientoProfesional", "#CarreraTech", "#Oportunidad"],
          call_to_action: "¡Comparte tu experiencia!"
        },
        {
          id: "option_3",
          title: "Opción Creativa",
          content: `🚀 ${topic}\n\n${style} para ${targetAudience}\n\n¡No te lo pierdas! 💼\n\n#TechLife #Oportunidad #Innovacion`,
          style: "Creativo y llamativo",
          length: "short",
          hashtags: ["#TechLife", "#Oportunidad", "#Innovacion"],
          call_to_action: "¡Comenta si te interesa!"
        }
      ]
    };
  }
}

// Función para generar análisis de IA sobre las estadísticas usando DeepSeek
async function generateAIAnalytics(postsData, dmData) {
  try {

    const schema = {
      marketTrends: {
        hotSectors: ["string"],
        demandPatterns: "string",
        growthOpportunities: "string"
      },
      userBehavior: {
        engagementLevel: "string",
        profileCompletion: "string",
        interactionPatterns: "string"
      },
      recommendations: ["string"],
      insights: ["string"]
    };

    const userContent = `Analiza estas estadísticas de Magneto Empleos y genera insights inteligentes.

FORMATO DE SALIDA OBLIGATORIO (JSON PURO, SIN markdown):
${JSON.stringify(schema, null, 2)}

REGLAS:
- Devuelve solo JSON válido UTF-8, sin texto extra, sin encabezados, sin cercas de código.
- Usa exactamente las claves del esquema: marketTrends, userBehavior, recommendations, insights.
- marketTrends.hotSectors debe ser array de strings.
- recommendations e insights deben ser listas de frases claras.

ESTADÍSTICAS DE POSTS:
- Total de posts: ${postsData?.totalPosts || 0}
- Posts generados por IA: ${postsData?.aiGeneratedPosts || 0}
- Posts manuales: ${postsData?.manualPosts || 0}
- Total de comentarios: ${postsData?.totalComments || 0}
- Engagement promedio: ${postsData?.avgEngagement || 0}
- Respuestas de IA: ${postsData?.aiResponses || 0}
- Comentarios de usuarios: ${postsData?.userComments || 0}

SECTORES MÁS POPULARES:
${postsData?.topSectors?.map(s => `- ${s.sector}: ${s.count} posts`).join('\n') || 'Ninguno'}

POSICIONES MÁS DEMANDADAS:
${postsData?.topPositions?.map(p => `- ${p.position}: ${p.count} menciones`).join('\n') || 'Ninguna'}

ESTADÍSTICAS DE DMs:
- Total de conversaciones: ${dmData?.totalConversations || 0}
- Conversaciones activas (última semana): ${dmData?.activeConversations || 0}
- Completitud promedio de datos: ${dmData?.avgCompletion || 0}%

PROFESIONES MÁS INTERESADAS:
${dmData?.topProfessions?.map(p => `- ${p.profession}: ${p.count} usuarios`).join('\n') || 'Ninguna'}

UBICACIONES MÁS ACTIVAS:
${dmData?.topLocations?.map(l => `- ${l.location}: ${l.count} usuarios`).join('\n') || 'Ninguna'}

DISTRIBUCIÓN DE EXPERIENCIA:
${dmData?.experienceDistribution?.map(e => `- ${e.level}: ${e.count} usuarios`).join('\n') || 'Ninguna'}

ESTADÍSTICAS DE MENSAJES:
- Total de mensajes: ${dmData?.messageStats?.total || 0}
- Generados por IA: ${dmData?.messageStats?.aiGenerated || 0}
- Generados por usuarios: ${dmData?.messageStats?.userGenerated || 0}
- Ratio de IA: ${dmData?.messageStats?.aiRatio || 0}%

Genera un análisis inteligente que incluya:

1. TENDENCIAS DEL MERCADO LABORAL:
   - Sectores con mayor demanda
   - Posiciones más buscadas
   - Patrones de interés

2. COMPORTAMIENTO DE USUARIOS:
   - Nivel de engagement
   - Patrones de interacción
   - Completitud de perfiles

3. OPORTUNIDADES DE MEJORA:
   - Áreas de crecimiento
   - Contenido que funciona mejor
   - Estrategias recomendadas

4. INSIGHTS ESPECÍFICOS:
   - Datos curiosos o sorprendentes
   - Correlaciones interesantes
   - Predicciones basadas en datos

5. RECOMENDACIONES ACCIONABLES:
   - Qué contenido crear
   - Cómo mejorar engagement
   - Estrategias de crecimiento

Sé específico con números y datos concretos.`;

    const messages = [
      {
        role: "system",
        content: "Eres un analista de datos experto especializado en análisis de redes sociales y empleo. Genera insights inteligentes basados en estadísticas de una plataforma de empleos llamada Magneto Empleos."
      },
      {
        role: "user",
        content: userContent
      }
    ];

    const analysisText = await callDeepSeek(messages);

    // Limpieza de cercas ``` y parseo seguro
    let clean = analysisText.trim();
    if (clean.startsWith('```')) {
      clean = clean.replace(/^```[a-zA-Z]*\n?/, '').replace(/```\s*$/, '');
    }
    try {
      const parsed = JSON.parse(clean);
      return parsed;
    } catch (e) {
      return { analysis: analysisText, format: 'text' };
    }
  } catch (error) {
    console.error('Error generando análisis de IA con DeepSeek:', error);
    return null;
  }
}

// Función para obtener información completa del usuario de Instagram
async function getInstagramUserInfo(userId) {
  if (!userId) return null;
  
  try {
    
    // Solo obtener datos básicos de Instagram Graph API
    const basicUrl = `https://graph.instagram.com/v21.0/${userId}?fields=id,username,name`;
    
    const basicResponse = await fetch(basicUrl, {
      headers: {
        'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
      }
    });
    
    let userData = {};
    
    if (basicResponse.ok) {
      const basicData = await basicResponse.json();
      userData = { ...basicData };
    }
    
    return userData;
  } catch (error) {
    console.error('Error obteniendo información de Instagram:', error);
    return {
      id: userId,
      username: null,
      name: null
    };
  }
}

// Función para obtener username de Instagram
async function getInstagramUsername(userId) {
  if (!userId) return null;
  
  try {
    const userResponse = await fetch(`https://graph.instagram.com/v21.0/${userId}?fields=username`, {
      headers: {
        'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
      }
    });
    
    if (userResponse.ok) {
      const userData = await userResponse.json();
      console.log('Username obtenido:', userData.username);
      return userData.username;
    } else {
      console.log('No se pudo obtener username del usuario:', userId);
      return null;
    }
  } catch (error) {
    console.error('Error obteniendo username:', error);
    return null;
  }
}

// Función para detectar emoción del usuario basada en sus mensajes
async function detectUserEmotion(userId, recentMessages = []) {
  try {
    if (!recentMessages.length) {
      // Obtener mensajes recientes del usuario usando JOIN explícito
      const { data: messages, error } = await supabase
        .from('mensajes')
        .select(`
          content, 
          created_at,
          conversaciones!inner(user_id)
        `)
        .eq('conversaciones.user_id', userId)
        .eq('message_type', 'incoming')
        .order('created_at', { ascending: false })
        .limit(10);
      
      if (error) {
        console.error('Error obteniendo mensajes para detección de emoción:', error);
        return null;
      }
      
      if (!messages || messages.length === 0) {
        console.log('No se encontraron mensajes para el usuario:', userId);
        return null;
      }
      
      recentMessages = messages;
    }
    
    // Combinar mensajes recientes para análisis
    const combinedText = recentMessages.map(msg => msg.content).join(' ');
    
    if (!combinedText.trim()) {
      return null;
    }
    
    // Usar DeepSeek para detectar emoción con el set Magneto IA
    const emotionPrompt = `Clasifica la emoción predominante del usuario a una de estas etiquetas EXACTAS del set Magneto IA:
POSITIVAS: happy, excited, hopeful, grateful, calm
NEGATIVAS: sad, angry, stressed, disappointed  
NEUTRAS: confused, curious, neutral

Texto del usuario: "${combinedText}"

Responde SOLO con la etiqueta (en minúsculas), sin texto adicional.`;

    const messages = [
      {
        role: "system",
        content: "Eres un clasificador de emociones del set Magneto IA. Respondes únicamente con la etiqueta solicitada en minúsculas."
      },
      {
        role: "user",
        content: emotionPrompt
      }
    ];

    const detectedEmotion = (await callDeepSeek(messages))?.trim().toLowerCase().replace(/[^a-z]/g, '');
    
    // Validar que la emoción esté en la lista permitida del set Magneto IA
    const validEmotions = ['happy', 'excited', 'hopeful', 'grateful', 'calm', 'sad', 'angry', 'stressed', 'disappointed', 'confused', 'curious', 'neutral'];
    
    if (validEmotions.includes(detectedEmotion)) {
      return detectedEmotion;
    }
    
    return 'neutral';
  } catch (error) {
    console.error('Error detectando emoción con DeepSeek:', error);
    return null;
  }
}

// Función para actualizar información del perfil del usuario
async function updateUserProfileInfo(conversationId, userId) {
  try {
    // Obtener información básica del usuario
    const userInfo = await getInstagramUserInfo(userId);
    if (!userInfo) return null;
    
    // Detectar emoción actual
    const currentEmotion = await detectUserEmotion(userId);
    
    // Actualizar conversación con nueva información básica
    const updateData = {
      username: userInfo.username,
      user_full_name: userInfo.name,
      user_current_emotion: currentEmotion || 'neutral',
      last_profile_update: new Date().toISOString(),
      updated_at: new Date().toISOString()
    };
    
    const { data, error } = await supabase
      .from('conversaciones')
      .update(updateData)
      .eq('id', conversationId)
      .select()
      .single();
    
    if (error) {
      console.error('Error actualizando perfil del usuario:', error);
      return null;
    }
    
    return data;
  } catch (error) {
    console.error('Error en updateUserProfileInfo:', error);
    return null;
  }
}

// Función para obtener historial de mensajes del usuario
async function getUserMessageHistory(userId, limit = 10) {
  try {
    const { data: messages, error } = await supabase
      .from('mensajes')
      .select(`
        content,
        message_type,
        is_ai_generated,
        created_at,
        conversaciones!inner(
          user_id,
          conversation_type
        )
      `)
      .eq('conversaciones.user_id', userId)
      .order('created_at', { ascending: false })
      .limit(limit);

    if (error) {
      console.error('Error obteniendo historial:', error);
      return [];
    }

    return messages || [];
  } catch (error) {
    console.error('Error en getUserMessageHistory:', error);
    return [];
  }
}

// Función para construir mensajes para la IA
// Función para convertir mensajes al formato de Gemini
function convertMessagesForGemini(messages) {
  let prompt = '';
  
  messages.forEach(msg => {
    if (msg.role === 'system') {
      prompt += `Sistema: ${msg.content}\n\n`;
    } else if (msg.role === 'user') {
      prompt += `Usuario: ${msg.content}\n\n`;
    } else if (msg.role === 'assistant') {
      prompt += `Asistente: ${msg.content}\n\n`;
    }
  });
  
  return prompt.trim();
}

// Definir las funciones disponibles para el AI Agent (declaraciones)
const AI_FUNCTION_DECLARATIONS = [
  {
    name: "update_user_data",
    description: "Actualiza los datos del perfil del usuario basado en la conversación",
    parameters: {
      type: "object",
      properties: {
        user_full_name: {
          type: "string",
          description: "Nombre completo del usuario"
        },
        user_profession: {
          type: "string", 
          description: "Profesión o área de trabajo del usuario"
        },
        user_studies: {
          type: "string",
          description: "Estudios o formación académica del usuario"
        },
        user_experience_years: {
          type: "integer",
          description: "Años de experiencia laboral del usuario"
        },
        user_skills: {
          type: "array",
          items: { type: "string" },
          description: "Habilidades técnicas o profesionales del usuario"
        },
        user_location: {
          type: "string",
          description: "Ciudad o país donde vive el usuario"
        },
        user_languages: {
          type: "array",
          items: { type: "string" },
          description: "Idiomas que maneja el usuario"
        },
        user_salary_expectation: {
          type: "string",
          description: "Expectativa salarial del usuario"
        },
        user_availability: {
          type: "string",
          description: "Disponibilidad laboral del usuario"
        },
        user_interests: {
          type: "array",
          items: { type: "string" },
          description: "Intereses profesionales del usuario"
        },
        user_company_size_preference: {
          type: "string",
          description: "Preferencia de tamaño de empresa del usuario"
        },
        user_industry_preference: {
          type: "array",
          items: { type: "string" },
          description: "Industria preferida del usuario"
        },
        user_work_mode_preference: {
          type: "string",
          description: "Modalidad de trabajo preferida (remoto, presencial, híbrido)"
        },
        user_career_level: {
          type: "string",
          description: "Nivel profesional del usuario (junior, mid, senior, etc.)"
        },
        user_portfolio_url: {
          type: "string",
          description: "URL del portfolio del usuario"
        },
        user_linkedin_url: {
          type: "string",
          description: "URL de LinkedIn del usuario"
        },
        user_github_url: {
          type: "string",
          description: "URL de GitHub del usuario"
        }
      }
    }
  }
];

// Estructura de tools esperada por Gemini: [{ functionDeclarations: [...] }]
const GEMINI_TOOLS = [
  {
    functionDeclarations: AI_FUNCTION_DECLARATIONS
  }
];

// Función para procesar function calls del AI
async function processFunctionCall(functionName, args, userId) {
  try {
    
    if (functionName === "update_user_data") {
      // Actualizar datos del usuario
      const updateData = {};
      
      // Procesar cada campo que venga en args
      for (const [field, value] of Object.entries(args)) {
        if (value !== null && value !== undefined && value !== '') {
          updateData[field] = value;
        }
      }
      
      if (Object.keys(updateData).length > 0) {
        // Actualizar en la base de datos
        const { data, error } = await supabase
          .from('conversaciones')
          .update({
            ...updateData,
            last_data_collection: new Date().toISOString(),
            updated_at: new Date().toISOString()
          })
          .eq('user_id', userId)
          .eq('platform', 'instagram')
          .eq('conversation_type', 'dm')
          .select()
          .single();

        if (error) {
          console.error('Error actualizando datos del usuario:', error);
          return { success: false, error: error.message };
        }

        // Recalcular porcentaje de completitud
        const userData = await getUserMissingData(userId);
        if (userData) {
          await supabase
            .from('conversaciones')
            .update({
              user_data_completion_percentage: userData.completionPercentage,
              updated_at: new Date().toISOString()
            })
            .eq('user_id', userId)
            .eq('platform', 'instagram')
            .eq('conversation_type', 'dm');
        }

        return { success: true, updatedFields: Object.keys(updateData) };
      }
    }
    
    return { success: false, error: 'Función no reconocida' };
  } catch (error) {
    console.error('Error procesando function call:', error);
    return { success: false, error: error.message };
  }
}

function buildMessages(userText, context, mediaInfo = null, messageHistory = [], userData = null) {
  const messages = [
    { role: 'system', content: SYSTEM_PROMPT }
  ];

  // Agregar contexto del usuario si está disponible
  if (userData) {
    let userContext = `INFORMACIÓN DEL USUARIO:
- Nombre: ${userData.user_full_name || 'No disponible'}
- Profesión: ${userData.user_profession || 'No disponible'}
- Estudios: ${userData.user_studies || 'No disponible'}
- Experiencia: ${userData.user_experience_years || 'No disponible'} años
- Ubicación: ${userData.user_location || 'No disponible'}
- Habilidades: ${userData.user_skills?.join(', ') || 'No disponible'}
- Idiomas: ${userData.user_languages?.join(', ') || 'No disponible'}
- Disponibilidad: ${userData.user_availability || 'No disponible'}
- Completitud de datos: ${userData.user_data_completion_percentage || 0}%

Usa esta información para personalizar tus respuestas y preguntar por datos faltantes de manera natural.`;

    // Agregar preferencias del usuario basadas en likes si están disponibles
    if (userData.user_preferences_context) {
      userContext += `\n\n${userData.user_preferences_context}`;
    }

    messages.push({ role: 'system', content: userContext });
  }

  // Agregar historial de mensajes
  if (messageHistory && messageHistory.length > 0) {
    messageHistory.reverse().forEach(msg => {
      if (msg.message_type === 'incoming') {
        messages.push({ role: 'user', content: msg.content });
      } else if (msg.message_type === 'outgoing' && msg.is_ai_generated) {
        messages.push({ role: 'assistant', content: msg.content });
      }
    });
  }

  // Agregar contexto de media si está disponible
  let contextText = '';
  if (mediaInfo) {
    contextText += `\n\nCONTEXTO DE MEDIA:\n- Tipo: ${mediaInfo.media_type}\n- URL: ${mediaInfo.media_url}\n- Caption: ${mediaInfo.caption || 'Sin caption'}`;
  }

  // Agregar contexto de la conversación
  if (context) {
    contextText += `\n\nCONTEXTO DE CONVERSACIÓN:\n- Tipo: ${context.type}\n- Username: ${context.username || 'No disponible'}`;
  }

  // Agregar mensaje actual del usuario
  messages.push({ 
    role: 'user', 
    content: userText + contextText 
  });

  return messages;
}

// Función mejorada para construir mensajes con contexto de contenido
async function buildMessagesWithContent(userText, context, mediaInfo = null, messageHistory = [], userData = null) {
  const messages = [
    { role: 'system', content: SYSTEM_PROMPT }
  ];

  // Agregar contexto del usuario si está disponible
  if (userData) {
    let userContext = `INFORMACIÓN DEL USUARIO:
- Nombre: ${userData.user_full_name || 'No disponible'}
- Profesión: ${userData.user_profession || 'No disponible'}
- Estudios: ${userData.user_studies || 'No disponible'}
- Experiencia: ${userData.user_experience_years || 'No disponible'} años
- Ubicación: ${userData.user_location || 'No disponible'}
- Habilidades: ${userData.user_skills?.join(', ') || 'No disponible'}
- Idiomas: ${userData.user_languages?.join(', ') || 'No disponible'}
- Disponibilidad: ${userData.user_availability || 'No disponible'}
- Completitud de datos: ${userData.user_data_completion_percentage || 0}%

Usa esta información para personalizar tus respuestas y preguntar por datos faltantes de manera natural.`;

    // Agregar preferencias del usuario basadas en likes si están disponibles
    if (userData.user_preferences_context) {
      userContext += `\n\n${userData.user_preferences_context}`;
    }

    messages.push({ role: 'system', content: userContext });
  }

  // Obtener contenido relevante para el contexto
  try {
    const relevantContent = await getRelevantContentForUser(userData, 3);
    
    if (relevantContent.total > 0) {
      let contentContext = '\n\nCONTENIDO RECIENTE DE MAGNETO EMPLEOS:\n';
      
      if (relevantContent.posts.length > 0) {
        contentContext += '\n📱 POSTS RECIENTES:\n';
        relevantContent.posts.forEach((post, index) => {
          const caption = post.caption ? post.caption.substring(0, 200) + '...' : 'Sin caption';
          contentContext += `${index + 1}. ${caption}\n`;
        });
      }
      
      if (relevantContent.stories.length > 0) {
        contentContext += '\n📸 STORIES RECIENTES:\n';
        contentContext += `- ${relevantContent.stories.length} stories publicadas recientemente\n`;
      }
      
      contentContext += '\nUsa esta información para mencionar vacantes específicas, oportunidades recientes o contenido relevante cuando sea apropiado.';
      
      messages.push({ role: 'system', content: contentContext });
    }
  } catch (error) {
      console.error('Error obteniendo contenido para contexto:', error);
  }

  // Agregar historial de mensajes
  if (messageHistory && messageHistory.length > 0) {
    messageHistory.reverse().forEach(msg => {
      if (msg.message_type === 'incoming') {
        messages.push({ role: 'user', content: msg.content });
      } else if (msg.message_type === 'outgoing' && msg.is_ai_generated) {
        messages.push({ role: 'assistant', content: msg.content });
      }
    });
  }

  // Agregar contexto de media si está disponible
  let contextText = '';
  if (mediaInfo) {
    contextText += `\n\nCONTEXTO DE MEDIA:\n- Tipo: ${mediaInfo.media_type}\n- URL: ${mediaInfo.media_url}\n- Caption: ${mediaInfo.caption || 'Sin caption'}`;
  }

  // Agregar contexto de la conversación
  if (context) {
    contextText += `\n\nCONTEXTO DE CONVERSACIÓN:\n- Tipo: ${context.type}\n- Username: ${context.username || 'No disponible'}`;
  }

  // Agregar mensaje actual del usuario
  messages.push({ 
    role: 'user', 
    content: userText + contextText 
  });

  return messages;
}

// Función para guardar conversación en Supabase
async function saveConversationToSupabase(conversationData) {
  try {
    
    const { data, error } = await supabase
      .from('conversaciones')
      .insert([conversationData])
      .select()
      .single();

    if (error) {
      console.error('Error guardando conversación:', error);
      console.error('Error details:', JSON.stringify(error, null, 2));
      return null;
    }
    
    
    // Notificar nueva conversación
    notifyNewConversation(data);
    
    return data;
  } catch (error) {
    console.error('Error en saveConversationToSupabase:', error);
    return null;
  }
}

// Función para guardar mensaje en Supabase
async function saveMessageToSupabase(messageData) {
  try {
    // Agregar información del autor si no está presente
    if (!messageData.author_name) {
      if (messageData.is_ai_generated) {
        messageData.author_name = 'Magneto AI';
        messageData.author_type = 'ai';
      } else {
        messageData.author_name = 'Usuario';
        messageData.author_type = 'user';
      }
    }

    const { data, error } = await supabase
      .from('mensajes')
      .insert([messageData])
      .select()
      .single();

    if (error) {
      console.error('Error guardando mensaje:', error);
      return null;
    }
    
    // Notificar nuevo mensaje
    notifyNewMessage(data);
    
    return data;
  } catch (error) {
    console.error('Error en saveMessageToSupabase:', error);
    return null;
  }
}

// Función para obtener información de media de Instagram
// Incluye like_count usando summary=true para obtener total_count
async function getInstagramMediaInfo(mediaId) {
  try {
    // Usar summary=true para obtener like_count (total_count aproximado)
    const response = await fetch(`https://graph.instagram.com/v21.0/${mediaId}?fields=id,media_type,media_url,caption,timestamp,permalink,like_count&access_token=${process.env.INSTAGRAM_ACCESS_TOKEN}`);
    
    if (!response.ok) {
      console.error('Error obteniendo info de media');
      return null;
    }
    
    const mediaInfo = await response.json();
    return mediaInfo;
  } catch (error) {
    console.error('Error obteniendo info de media:', error);
    return null;
  }
}

// DEPRECADO: Función para obtener los likes de un post de Instagram
// NOTA: El endpoint /likes quedó obsoleto desde la versión 8.0
// Usar getInstagramMediaInfo() con like_count en su lugar
async function getInstagramPostLikes(mediaId) {
  
  try {
    // Intentar obtener like_count desde la información del media
    const mediaInfo = await getInstagramMediaInfo(mediaId);
    if (mediaInfo && mediaInfo.like_count !== undefined) {
      return mediaInfo.like_count;
    }
    return 0;
  } catch (error) {
    console.error(`Error obteniendo likes del post ${mediaId}:`, error);
    return 0;
  }
}

// Función para obtener el conteo de likes de un post usando like_count
async function getInstagramPostLikeCount(mediaId) {
  try {
    const mediaInfo = await getInstagramMediaInfo(mediaId);
    if (mediaInfo && mediaInfo.like_count !== undefined) {
      return mediaInfo.like_count;
    }
    return 0;
  } catch (error) {
    console.error(`Error obteniendo conteo de likes del post ${mediaId}:`, error);
    return 0;
  }
}

// Función para obtener todos los posts de la cuenta de Instagram
// Incluye like_count usando summary para obtener total_count aproximado
async function getAllInstagramAccountMedia(limit = 25) {
  try {
    if (!process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID) {
      console.error('INSTAGRAM_BUSINESS_ACCOUNT_ID no está configurado');
      return [];
    }

    // Incluir like_count en los campos solicitados
    const response = await fetch(
      `https://graph.instagram.com/v21.0/${process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID}/media?fields=id,media_type,media_url,caption,timestamp,permalink,like_count&limit=${limit}&access_token=${process.env.INSTAGRAM_ACCESS_TOKEN}`
    );
    
    if (!response.ok) {
      const errorText = await response.text();
      console.error('Error obteniendo posts de Instagram:', errorText);
      return [];
    }
    
    const data = await response.json();
    return data.data || [];
  } catch (error) {
    console.error('Error obteniendo posts de Instagram:', error);
    return [];
  }
}

// Función para sincronizar likes de posts de Instagram (polling)
async function syncInstagramPostLikes() {
  try {
    
    const PostLikeRepository = require('../repositories/PostLikeRepository');
    const postLikeRepository = new PostLikeRepository();
    
    // Obtener todos los posts de la cuenta
    const posts = await getAllInstagramAccountMedia(50);
    
    let totalNewLikes = 0;
    let totalProcessed = 0;
    
    // NOTA: El endpoint /likes está deprecado desde la versión 8.0
    // Solo podemos obtener el conteo total usando like_count
    // No podemos obtener la lista de usuarios que dieron like individualmente
    for (const post of posts) {
      try {
        // Obtener información del post con like_count
        const mediaInfo = await getInstagramMediaInfo(post.id);
        const likeCount = mediaInfo?.like_count || 0;
        
        
        // Nota: Ya no podemos sincronizar likes individuales porque el endpoint está deprecado
        // Solo podemos obtener el conteo total aproximado
        // El like_count ya viene incluido en getAllInstagramAccountMedia()
        if (post.like_count !== undefined) {
          totalProcessed += post.like_count || 0;
        } else if (likeCount > 0) {
          totalProcessed += likeCount;
        }
        
        // Pequeña pausa para evitar rate limiting
        await new Promise(resolve => setTimeout(resolve, 200));
      } catch (error) {
        console.error(`Error procesando post ${post.id}:`, error.message);
        continue;
      }
    }
    
    
    return {
      success: true,
      postsProcessed: posts.length,
      totalLikes: totalProcessed, // Total de likes aproximado
      note: 'El endpoint /likes está deprecado. Solo se puede obtener el conteo total aproximado usando like_count.'
    };
  } catch (error) {
    console.error('Error en sincronización de likes:', error);
    throw error;
  }
}

// Función para obtener información de story
async function getStoryInfo(storyId) {
  try {
    const response = await fetch(`https://graph.instagram.com/v21.0/${storyId}?fields=id,media_type,media_url,caption,timestamp&access_token=${process.env.INSTAGRAM_ACCESS_TOKEN}`);
    
    if (!response.ok) {
      console.error('Error obteniendo info de story');
      return null;
    }
    
    const storyInfo = await response.json();
    return storyInfo;
  } catch (error) {
    console.error('Error obteniendo info de story:', error);
    return null;
  }
}

// Función para verificar si un mensaje ya fue procesado
async function isMessageAlreadyProcessed(platformMessageId) {
  try {
    const { data, error } = await supabase
      .from('mensajes')
      .select('id')
      .eq('platform_message_id', platformMessageId)
      .single();

    if (error && error.code !== 'PGRST116') { // PGRST116 = no rows returned
      console.error('Error verificando mensaje procesado:', error);
      return false;
    }

    return !!data;
  } catch (error) {
    console.error('Error en isMessageAlreadyProcessed:', error);
    return false;
  }
}

// Función para generar ID de conversación consistente para DMs
function generateDMConversationId(senderId, recipientId) {
  // Ordenar los IDs para que siempre sea el mismo independientemente de quién envía
  const ids = [senderId, recipientId].sort();
  return `dm_${ids[0]}_${ids[1]}`;
}

// Función para obtener o crear conversación de DM
async function getOrCreateDMConversation(senderId, recipientId, username) {
  if (!senderId || !recipientId) {
    throw new Error('senderId y recipientId son requeridos para crear una conversación');
  }
  
  const conversationId = generateDMConversationId(senderId, recipientId);
  
  const botId = '17841477544945260';
  const externalUserId = senderId === botId ? recipientId : senderId;
  const externalUsername = senderId === botId ? null : username;
  
  // Buscar conversación existente
  const { data: existingConversation, error: searchError } = await supabase
    .from('conversaciones')
    .select('*')
    .eq('external_conversation_id', conversationId)
    .eq('platform', 'instagram')
    .eq('conversation_type', 'dm')
    .single();

  if (existingConversation && !searchError) {
    // Actualizar username si no existe
    if (!existingConversation.username && externalUsername) {
      await supabase
        .from('conversaciones')
        .update({ 
          username: externalUsername,
          updated_at: new Date().toISOString()
        })
        .eq('id', existingConversation.id);
    }
    
    return existingConversation;
  }

  if (!externalUserId) {
    throw new Error('No se pudo determinar el ID del usuario externo');
  }

  const conversationData = {
    platform: 'instagram',
    conversation_type: 'dm',
    external_conversation_id: conversationId,
    user_id: externalUserId,
    username: externalUsername,
    status: 'active'
  };

  return await saveConversationToSupabase(conversationData);
}

// Función para subir imagen a Supabase Storage
async function uploadImageToStorage(imageBuffer, fileName, contentType) {
  try {
    if (!supabase) {
      return null;
    }

    const bucketName = 'magneto-bucket';

    const { data, error } = await supabase.storage
      .from(bucketName)
      .upload(fileName, imageBuffer, {
        contentType: contentType,
        upsert: true
      });

    if (error) {
      console.error('Error subiendo imagen:', error);
      return null;
    }

    const { data: { publicUrl } } = supabase.storage
      .from(bucketName)
      .getPublicUrl(fileName);

    if (!publicUrl) {
      return null;
    }

    return publicUrl;
  } catch (error) {
    console.error('Error en uploadImageToStorage:', error.message);
    return null;
  }
}

// Función eliminada completamente - la IA genera las imágenes con texto incluido


// Cola para controlar peticiones concurrentes de video (límite: 2)
let videoGenerationQueue = [];
let activeVideoGenerations = 0;
const MAX_CONCURRENT_VIDEOS = 2;

// Cola de videos en procesamiento (background)
const videoProcessingQueue = new Map(); // jobId -> { status, progress, callback, resolve, reject }

// Función para procesar la cola de generación de videos
async function processVideoQueue() {
  if (activeVideoGenerations >= MAX_CONCURRENT_VIDEOS || videoGenerationQueue.length === 0) {
    return;
  }

  const { resolve, reject, prompt, accent, style, duration } = videoGenerationQueue.shift();
  activeVideoGenerations++;

  try {
    const result = await generateVideoInternal(prompt, accent, style, duration);
    resolve(result);
  } catch (error) {
    reject(error);
  } finally {
    activeVideoGenerations--;
    // Procesar siguiente en la cola
    processVideoQueue();
  }
}

// Función para procesar videos en background
async function processVideoInBackground(jobId) {
  try {
    const maxAttempts = 60;
    let attempts = 0;
    
    while (attempts < maxAttempts) {
      attempts++;
      
      // Verificar estado del video
      const statusResponse = await fetch(`https://api.openai.com/v1/videos/${jobId}`, {
        headers: {
          'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
        }
      });
      
      if (!statusResponse.ok) {
        throw new Error(`Error verificando estado: ${statusResponse.statusText}`);
      }
      
      const videoData = await statusResponse.json();
      
      // Actualizar estado en la cola
      const queueItem = videoProcessingQueue.get(jobId);
      if (queueItem) {
        queueItem.status = videoData.status;
        queueItem.progress = videoData.progress;
      }
      
      if (videoData.status === 'completed' || videoData.status === 'succeeded') {
        // Descargar video
        const contentResponse = await fetch(`https://api.openai.com/v1/videos/${jobId}/content`, {
          headers: {
            'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
          }
        });
        
        if (!contentResponse.ok) {
          throw new Error(`Error descargando video: ${contentResponse.statusText}`);
        }
        
        const videoBuffer = Buffer.from(await contentResponse.arrayBuffer());
        
        // Subir a Supabase
        const fileName = `ai-generated-reel-${Date.now()}.mp4`;
        const { data: uploadData, error: uploadError } = await supabase.storage
          .from('magneto-bucket')
          .upload(fileName, videoBuffer, {
            contentType: 'video/mp4',
            cacheControl: '3600'
          });
        
        if (uploadError) {
          throw new Error(`Error subiendo video: ${uploadError.message}`);
        }
        
        const { data: publicUrlData } = supabase.storage
          .from('magneto-bucket')
          .getPublicUrl(fileName);
        
        const videoUrl = publicUrlData.publicUrl;
        
        // Resolver la promesa
        if (queueItem) {
          queueItem.resolve(videoUrl);
          videoProcessingQueue.delete(jobId);
        }
        
        return videoUrl;
        
      } else if (videoData.status === 'failed' || videoData.status === 'error') {
        const error = `Video falló: ${videoData.error?.message || 'Error desconocido'}`;
        console.error(`Error procesando video ${jobId}:`, error);
        
        if (queueItem) {
          queueItem.reject(new Error(error));
          videoProcessingQueue.delete(jobId);
        }
        
        throw new Error(error);
      }
      
      // Esperar 10 segundos antes del siguiente check
      await new Promise(resolve => setTimeout(resolve, 10000));
    }
    
    const timeoutError = `Timeout procesando video ${jobId} después de ${maxAttempts} intentos`;
    console.error(timeoutError);
    
    const queueItem = videoProcessingQueue.get(jobId);
    if (queueItem) {
      queueItem.reject(new Error(timeoutError));
      videoProcessingQueue.delete(jobId);
    }
    
    throw new Error(timeoutError);
    
  } catch (error) {
    console.error(`Error procesando video ${jobId} en background:`, error);
    
    const queueItem = videoProcessingQueue.get(jobId);
    if (queueItem) {
      queueItem.reject(error);
      videoProcessingQueue.delete(jobId);
    }
    
    throw error;
  }
}

// Función interna para generar video (OpenAI Sora via REST, sin control de cola)
async function generateVideoInternal(prompt, accent = 'neutral', style = 'realista', duration = 8) {
  try {
    if (!process.env.OPENAI_API_KEY) {
      console.error('OPENAI_API_KEY no está configurado');
      return null;
    }

    const axios = require('axios');
    const apiKey = process.env.OPENAI_API_KEY;

    const maxDur = Math.min(Math.max(Number(duration) || 6, 1), 8);
    const videoPrompt = `Un video corto para Instagram Reels en español.\n\nTema: "${prompt}"\nEstilo visual: ${style}\nTono: profesional y dinámico.\nAudio: narración clara en español (acento ${accent}) y música de fondo sutil.\nFormato: vertical 9:16. Duración máxima: ${maxDur} segundos.`;
    
    // Crear video usando la API REST de OpenAI
    // Nota: Sora solo acepta 'prompt' como parámetro principal
    const createResponse = await axios.post(
      'https://api.openai.com/v1/videos',
      {
        prompt: videoPrompt
      },
      {
        headers: {
          'Authorization': `Bearer ${apiKey}`,
          'Content-Type': 'application/json'
        }
      }
    );

    const jobId = createResponse.data?.id;
    if (!jobId) {
      console.error('No se obtuvo jobId');
      return null;
    }

    let status = createResponse.data?.status || 'processing';
    let details = createResponse.data;
    let attempts = 0;
    const maxAttempts = 60;
    
    while (status !== 'completed' && status !== 'succeeded' && status !== 'failed' && status !== 'canceled' && attempts < maxAttempts) {
      await new Promise(r => setTimeout(r, 8000));
      attempts++;
      
      const statusResponse = await axios.get(
        `https://api.openai.com/v1/videos/${jobId}`,
        {
          headers: {
            'Authorization': `Bearer ${apiKey}`,
            'Content-Type': 'application/json'
          }
        }
      );
      
      details = statusResponse.data;
      status = details?.status;
      
      if (status === 'failed' || status === 'canceled') {
        console.error('Job falló/cancelado');
        return null;
      }
    }

    if (attempts >= maxAttempts) {
      console.error('Timeout esperando video');
      return null;
    }

    const contentUrl = `https://api.openai.com/v1/videos/${jobId}/content`;
    const resp = await axios.get(contentUrl, { 
      responseType: 'arraybuffer',
      headers: {
        Authorization: `Bearer ${apiKey}`
      }
    });
    let videoBuffer = Buffer.from(resp.data);
    
    if (!videoBuffer || videoBuffer.length === 0) {
      console.error('Error: videoBuffer está vacío');
      return null;
    }
    
    const timestamp = Date.now();
    const fileName = `ai-generated-reel-${timestamp}.mp4`;
      
    const supabaseVideoUrl = await uploadImageToStorage(videoBuffer, fileName, 'video/mp4');
    
    if (!supabaseVideoUrl) {
      console.error('Error subiendo video a Supabase Storage');
      return null;
    }
    
    return supabaseVideoUrl;
  } catch (error) {
    console.error('Error general en generateVideoInternal:', error.message);
    return null;
  }
}

// Función principal que usa la cola para controlar concurrencia
async function generateVideo(prompt, accent = 'neutral', style = 'realista', duration = 8) {
  return new Promise((resolve, reject) => {
    const createVideoJob = async () => {
      try {
        const response = await fetch('https://api.openai.com/v1/videos', {
          method: 'POST',
          headers: {
            'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
            'Content-Type': 'application/json'
          },
          body: JSON.stringify({
            model: 'sora-2',
            prompt: `Crea un video vertical (9:16) de máximo ${duration} segundos sobre: ${prompt}. Estilo: ${style}. Acento: ${accent}. Formato profesional y moderno.`
          })
        });
        
        if (!response.ok) {
          const errorData = await response.json();
          throw new Error(`Error creando video: ${errorData.error?.message || response.statusText}`);
        }
        
        const jobData = await response.json();
        const jobId = jobData.id;
        
        // Agregar a la cola de procesamiento en background
        videoProcessingQueue.set(jobId, {
          status: 'queued',
          progress: 0,
          resolve,
          reject
        });
        
        processVideoInBackground(jobId).catch(error => {
          console.error(`Error en background processing para ${jobId}:`, error);
        });
        
      } catch (error) {
        console.error('Error creando job de video:', error);
        reject(error);
      }
    };
    
    // Ejecutar creación del job
    createVideoJob();
  });
}

// Función para generar imagen con Gemini usando el nuevo SDK @google/genai
async function generateImageWithGemini(prompt, referenceImage = null, type = 'post') {
  try {
    const ai = getGeminiClient();
    if (!ai) {
      return null;
    }
    
    // Determinar dimensiones según el tipo
    const isStory = type === 'story';
    const dimensions = isStory ? '1080x1920px (vertical 9:16)' : '1080x1080px (square)';
    const formatDescription = isStory ? 'Instagram Story (vertical 9:16 format)' : 'Instagram post (square)';
    
    let imagePrompt = `Create an illustrative, cartoon-style ${formatDescription} image (${dimensions}) about: "${prompt}"

DESIGN REQUIREMENTS:
- High quality, professional illustration
- ${formatDescription} dimensions (${dimensions})
- Cartoon/caricature style with friendly characters
- Clean, modern layout with balanced composition
- Brand: primary color #41068e (Magneto). Build the palette from this primary.
- Secondary neutrals: white #FFFFFF, very dark background #0F0A2A when needed.
- Accents may derive from analogous/complementary hues of #41068e but keep harmony.
- Illustrative and engaging visual style
- Full-bleed canvas (NO white frames, NO borders, NO outer padding). Background must cover 100%.
- Prefer solid/gradient background using #41068e → darker tone or #0F0A2A.

TEXT TO INCLUDE IN IMAGE:
- Main title: Based on the topic "${prompt}" - create an appropriate title (in white, large and visible)
- Subtitle: "${prompt}" (in blue, medium size)
- Call to action: Create an appropriate call to action based on the content (in orange, highlighted)
- Minimal but effective text
- Professional, readable fonts

BRANDING REQUIREMENTS (MANDATORY):
- Do NOT add any watermark, logos, handles or brand text overlays in the image.
- All branding must be implicit through color usage and style only.

VISUAL ELEMENTS:
- Cartoon characters and caricatures
- Illustrative tech/programming elements
- Friendly, approachable character designs
- Modern professional graphics with personality
- Clean and engaging design
- Attractive to developers and tech professionals
- Illustrations that complement the text
- Well-distributed spaces with character interactions

STYLE REQUIRED:
- Illustrative cartoon style
- Friendly, approachable characters
- Professional but fun composition
- Well-distributed brand colors with #41068e as the hero color
- Visual elements that support the message
- Style that attracts tech professionals
- Complete image ready to publish
- Character-driven storytelling

${referenceImage ? 'Use the reference image as inspiration for style and composition. Analyze the reference image and apply the requested changes while maintaining the overall structure and visual elements.' : ''}

Generate a complete illustrative image ready for social media with proper branding.`;
    
    let contents;
    if (referenceImage) {
      // Descargar la imagen de referencia
      const imageResponse = await fetch(referenceImage);
      const imageBuffer = await imageResponse.arrayBuffer();
      const imageBase64 = Buffer.from(imageBuffer).toString('base64');
      
      contents = [
        {
          text: imagePrompt
        },
        {
          inlineData: {
            mimeType: "image/png",
            data: imageBase64
          }
        }
      ];
    } else {
      contents = imagePrompt;
    }
    
    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash-image",
      contents: contents,
    });
    
    if (!response.candidates || response.candidates.length === 0) {
      return null;
    }
    
    const candidate = response.candidates[0];
    
    if (!candidate.content || !candidate.content.parts || candidate.content.parts.length === 0) {
      return null;
    }
    
    const parts = candidate.content.parts;
    
    let imagePart = null;
    for (let i = 0; i < parts.length; i++) {
      const part = parts[i];
      if (part.inlineData) {
        imagePart = part;
        break;
      }
    }
    
    if (!imagePart) {
      return null;
    }
    
    const imageBuffer = Buffer.from(imagePart.inlineData.data, 'base64');
    
    const timestamp = Date.now();
    const fileName = `ai-generated-${timestamp}.png`;
      
    const supabaseImageUrl = await uploadImageToStorage(imageBuffer, fileName, 'image/png');
    
    if (!supabaseImageUrl) {
      console.error('Error subiendo imagen a Supabase Storage');
      return null;
    }
      
    const finalUrl = await maybeApplyWatermarkAndReupload(supabaseImageUrl);
    return finalUrl;
  } catch (error) {
    console.error('Error general en generateImageWithGemini:', error.message);
    return null;
  }
}

// Función para generar contenido con IA
async function generateAIContent(prompt) {
  try {
    const geminiClient = getGeminiClient();
    if (!geminiClient) {
      console.error('Cliente Gemini no disponible');
      return null;
    }

    const { BRAND_IDENTITY } = require('./constants');
    
    // Enriquecer el prompt con la identidad de marca
    const enrichedPrompt = `Eres copywriter de Magneto Empleos, una plataforma que conecta candidatos con oportunidades laborales.

IDENTIDAD DE MARCA:
- Eslogan principal: "${BRAND_IDENTITY.MAIN_SLOGAN}"
- Eslóganes secundarios: ${BRAND_IDENTITY.SECONDARY_SLOGANS.join(', ')}
- Mensajes clave: ${BRAND_IDENTITY.KEY_MESSAGES.join(' | ')}

TONO DE COMUNICACIÓN:
- Cercano, humano, amigable, accesible, empático
- Positivo, motivador, directo
- Equilibrio entre profesionalismo y calidez
- Lenguaje sencillo, conciso e inclusivo
- Sin tecnicismos excesivos
- Energía y dinamismo

PROPÓSITO: Impulsar carreras y transmitir que las oportunidades transforman vidas.

TAREA:
${prompt}

Genera contenido que refleje esta identidad de marca y tono de comunicación.`;
    
    // Usar la nueva API de @google/genai
    const response = await geminiClient.models.generateContent({
      model: "gemini-2.5-flash-lite",
      contents: enrichedPrompt
    });
    
    const generatedContent = response.text;
    
    if (!generatedContent) {
      return null;
    }

    return generatedContent.trim();
  } catch (error) {
    console.error('Error generando contenido con Gemini:', error);
    return null;
  }
}

// Función para publicar story en Instagram usando Graph API
async function publishInstagramStory(imageUrl) {
  try {
    if (!process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID) {
      return { success: false, error: 'Instagram Business Account ID no configurado' };
    }

    if (!process.env.INSTAGRAM_ACCESS_TOKEN) {
      return { success: false, error: 'Instagram Access Token no configurado' };
    }

    // Paso 1: Crear media container para story
    const createMediaResponse = await fetch(`https://graph.instagram.com/v21.0/${process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID}/media`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        image_url: imageUrl,
        media_type: 'STORIES'
      })
    });

    if (!createMediaResponse.ok) {
      const errorText = await createMediaResponse.text();
      console.error('Error creando media container para story:', errorText);
      return { success: false, error: `Error creando media: ${errorText}` };
    }

    const mediaData = await createMediaResponse.json();

    await new Promise(resolve => setTimeout(resolve, 3000));
    const publishResponse = await fetch(`https://graph.instagram.com/v21.0/${process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID}/media_publish`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        creation_id: mediaData.id
      })
    });

    if (!publishResponse.ok) {
      const errorText = await publishResponse.text();
      console.error('Error publicando story:', errorText);
      return { success: false, error: `Error publicando story: ${errorText}` };
    }

    const publishData = await publishResponse.json();

    return {
      success: true,
      media_id: mediaData.id,
      story_id: publishData.id,
      data: publishData
    };

  } catch (error) {
    console.error('Error general publicando story:', error);
    return { success: false, error: error.message };
  }
}

// Función para publicar post en Instagram usando Graph API
async function publishInstagramPost(imageUrl, caption) {
  try {
    if (!process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID) {
      return { success: false, error: 'Instagram Business Account ID no configurado' };
    }

    if (!process.env.INSTAGRAM_ACCESS_TOKEN) {
      return { success: false, error: 'Instagram Access Token no configurado' };
    }
    let captionStr = '';
    if (typeof caption === 'string') {
      captionStr = caption;
    } else if (caption && typeof caption === 'object') {
      // intentar campos comunes
      captionStr = caption.content || caption.text || caption.final || caption.final_caption || '';
    } else if (Array.isArray(caption)) {
      captionStr = caption.join(', ');
    } else if (caption != null) {
      captionStr = String(caption);
    }

    // Si vino como JSON string con estructura { captions: [ { content: ... } ] }
    try {
      const trimmed = (captionStr || '').trim();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        const parsed = JSON.parse(trimmed);
        if (parsed && Array.isArray(parsed.captions) && parsed.captions.length > 0) {
          // Elegir la primera opción por defecto
          const first = parsed.captions[0];
          const fromFirst = (first && (first.content || first.text || first.title)) || '';
          if (fromFirst) captionStr = fromFirst;
        }
      }
    } catch (_) {}

    // Paso 1: Crear media container
    const createMediaResponse = await fetch(`https://graph.instagram.com/v21.0/${process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID}/media`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        image_url: imageUrl,
        caption: captionStr || undefined
      })
    });

    if (!createMediaResponse.ok) {
      const errorText = await createMediaResponse.text();
      console.error('Error creando media container:', errorText);
      return { success: false, error: `Error creando media: ${errorText}` };
    }

    const mediaData = await createMediaResponse.json();

    await new Promise(resolve => setTimeout(resolve, 3000));
    const publishResponse = await fetch(`https://graph.instagram.com/v21.0/${process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID}/media_publish`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        creation_id: mediaData.id
      })
    });

    if (!publishResponse.ok) {
      const errorText = await publishResponse.text();
      console.error('Error publicando media:', errorText);
      return { success: false, error: `Error publicando: ${errorText}` };
    }

    const publishData = await publishResponse.json();

    return {
      success: true,
      media_id: mediaData.id,
      post_id: publishData.id,
      message: 'Post publicado exitosamente en Instagram'
    };

  } catch (error) {
    console.error('Error en publishInstagramPost:', error);
    return { success: false, error: error.message };
  }
}

// Función para publicar Reel (video) en Instagram usando Graph API
async function publishInstagramReel(videoUrl, caption) {
  try {
    if (!process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID) {
      return { success: false, error: 'Instagram Business Account ID no configurado' };
    }
    if (!process.env.INSTAGRAM_ACCESS_TOKEN) {
      return { success: false, error: 'Instagram Access Token no configurado' };
    }
    let captionStr = '';
    if (typeof caption === 'string') {
      captionStr = caption;
    } else if (caption && typeof caption === 'object') {
      captionStr = caption.content || caption.text || caption.final || caption.final_caption || '';
    } else if (Array.isArray(caption)) {
      captionStr = caption.join(', ');
    } else if (caption != null) {
      captionStr = String(caption);
    }

    // Si vino como JSON string con estructura { captions: [ { content: ... } ] }
    try {
      const trimmed = (captionStr || '').trim();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        const parsed = JSON.parse(trimmed);
        if (parsed && Array.isArray(parsed.captions) && parsed.captions.length > 0) {
          const first = parsed.captions[0];
          const fromFirst = (first && (first.content || first.text || first.title)) || '';
          if (fromFirst) captionStr = fromFirst;
        }
      }
    } catch (_) {}

    // 1) Crear media container directo con video_url y media_type REELS
    const createContainerResp = await fetch(`https://graph.instagram.com/v24.0/${process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID}/media`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        media_type: 'REELS',
        video_url: videoUrl,
        caption: captionStr || undefined
      })
    });

    if (!createContainerResp.ok) {
      const errorText = await createContainerResp.text();
      console.error('Error creando contenedor:', errorText);
      return { success: false, error: `Error creando contenedor: ${errorText}` };
    }

    const container = await createContainerResp.json();
    const containerId = container.id;

    // 2) Poll del estado del contenedor hasta FINISHED
    let status = 'IN_PROGRESS';
    let attempts = 0;
    const maxAttempts = 20;
    while (attempts < maxAttempts) {
      attempts++;
      const statusResp = await fetch(`https://graph.instagram.com/v24.0/${containerId}?fields=status_code`, {
        headers: { 'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}` }
      });
      if (!statusResp.ok) {
        const err = await statusResp.text();
        console.warn('Error consultando status del contenedor:', err);
        await new Promise(r => setTimeout(r, 3000));
        continue;
      }
      const statusJson = await statusResp.json();
      status = statusJson.status_code || 'IN_PROGRESS';
      if (status === 'FINISHED' || status === 'PUBLISHED') break;
      if (status === 'ERROR' || status === 'EXPIRED') {
        return { success: false, error: `Estado del contenedor: ${status}` };
      }
      await new Promise(r => setTimeout(r, 3000));
    }

    if (status !== 'FINISHED' && status !== 'PUBLISHED') {
      return { success: false, error: `Timeout esperando contenedor (status=${status})` };
    }

    // 3) Publicar
    const publishResp = await fetch(`https://graph.instagram.com/v24.0/${process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID}/media_publish`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ creation_id: containerId })
    });

    if (!publishResp.ok) {
      const errorText = await publishResp.text();
      console.error('Error publicando Reel:', errorText);
      return { success: false, error: `Error publicando Reel: ${errorText}` };
    }

    const publishData = await publishResp.json();

    // 4) Obtener permalink
    let permalink = null;
    try {
      const fieldsResp = await fetch(`https://graph.instagram.com/v24.0/${publishData.id}?fields=permalink,media_type,media_url,media_product_type`, {
        headers: { 'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}` }
      });
      if (fieldsResp.ok) {
        const fields = await fieldsResp.json();
        permalink = fields.permalink || null;
      }
    } catch (e) {
    }

    return {
      success: true,
      media_id: containerId,
      post_id: publishData.id,
      permalink
    };
  } catch (error) {
    console.error('Error general publicando Reel:', error);
    return { success: false, error: error.message };
  }
}

// Función para crear template de imagen de vacante
async function createVacancyImageTemplate(prompt, referenceImage = null) {
  try {
    const { createCanvas } = require('canvas');
    
    // Crear canvas
    const canvas = createCanvas(800, 600);
    const ctx = canvas.getContext('2d');

    // Fondo degradado
    const gradient = ctx.createLinearGradient(0, 0, 800, 600);
    gradient.addColorStop(0, '#667eea');
    gradient.addColorStop(1, '#764ba2');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, 800, 600);

    // Título
    ctx.fillStyle = '#ffffff';
    ctx.font = 'bold 48px Arial';
    ctx.textAlign = 'center';
    ctx.fillText('MAGNETO EMPLEOS', 400, 150);

    // Subtítulo
    ctx.font = '24px Arial';
    ctx.fillText('Tu próximo empleo te espera', 400, 200);

    // Prompt como contenido principal
    ctx.font = '20px Arial';
    ctx.fillStyle = '#f0f0f0';
    const words = prompt.split(' ');
    let line = '';
    let y = 300;
    
    for (let i = 0; i < words.length; i++) {
      const testLine = line + words[i] + ' ';
      const metrics = ctx.measureText(testLine);
      const testWidth = metrics.width;
      
      if (testWidth > 700 && i > 0) {
        ctx.fillText(line, 400, y);
        line = words[i] + ' ';
        y += 30;
      } else {
        line = testLine;
      }
    }
    ctx.fillText(line, 400, y);

    // Footer
    ctx.font = '16px Arial';
    ctx.fillStyle = '#cccccc';
    ctx.fillText('www.magnetoempleos.com', 400, 550);

    // Convertir a buffer
    const buffer = canvas.toBuffer('image/png');
    
    // Subir a storage
    const fileName = `vacancy_${Date.now()}.png`;
    const imageUrl = await uploadImageToStorage(buffer, fileName, 'image/png');
    
    return imageUrl;
  } catch (error) {
    console.error('Error creando template de imagen:', error);
    return null;
  }
}

// Función para dividir mensajes largos
function splitLongMessage(message, maxLength = 900) {
  if (message.length <= maxLength) {
    return [message];
  }

  const parts = [];
  const sentences = message.split(/[.!?]+/);
  let currentPart = '';

  for (const sentence of sentences) {
    const trimmedSentence = sentence.trim();
    if (!trimmedSentence) continue;

    const sentenceWithPunctuation = trimmedSentence + (sentence.match(/[.!?]$/) ? '' : '.');
    
    if (currentPart.length + sentenceWithPunctuation.length + 1 <= maxLength) {
      currentPart += (currentPart ? ' ' : '') + sentenceWithPunctuation;
    } else {
      if (currentPart) {
        parts.push(currentPart.trim());
        currentPart = sentenceWithPunctuation;
      } else {
        // Si una sola oración es muy larga, dividir por palabras
        const words = sentenceWithPunctuation.split(' ');
        let wordPart = '';
        
        for (const word of words) {
          if (wordPart.length + word.length + 1 <= maxLength) {
            wordPart += (wordPart ? ' ' : '') + word;
          } else {
            if (wordPart) parts.push(wordPart);
            wordPart = word;
          }
        }
        currentPart = wordPart;
      }
    }
  }

  if (currentPart) {
    parts.push(currentPart.trim());
  }

  return parts;
}

// Función para enviar respuesta DM a Instagram
async function sendInstagramDMReply(recipientId, reply) {
  try {
    // No enviar DM al bot mismo
    const botId = '17841477544945260';
    if (recipientId === botId) {
      console.log('Intentando enviar DM al bot mismo, saltando...');
      return { success: false, error: 'Cannot send DM to bot itself' };
    }

    console.log('Enviando respuesta DM a:', recipientId);
    
    // Dividir mensaje si es muy largo
    const messageParts = splitLongMessage(reply);
    console.log(`Mensaje dividido en ${messageParts.length} partes`);

    const results = [];
    
    // Enviar cada parte
    for (let i = 0; i < messageParts.length; i++) {
      const part = messageParts[i];
      console.log(`Enviando parte ${i + 1}/${messageParts.length}`);
      
      const response = await fetch(`https://graph.instagram.com/v21.0/me/messages`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          recipient: { id: recipientId },
          message: { text: part }
        })
      });

      if (response.ok) {
        const result = await response.json();
        results.push({ 
          part: i + 1, 
          success: true, 
          message_id: result.id 
        });
        console.log(`Parte ${i + 1} enviada exitosamente`);
      } else {
        const errorText = await response.text();
        console.error(`Error enviando parte ${i + 1}:`, errorText);
        results.push({ 
          part: i + 1, 
          success: false, 
          error: errorText 
        });
        break; // Salir del loop si hay error
      }
      
      // Delay entre mensajes
      if (i < messageParts.length - 1) {
        await new Promise(resolve => setTimeout(resolve, 1000));
      }
    }

    const allSuccessful = results.every(r => r.success);
    
    if (allSuccessful) {
      console.log('Todas las partes enviadas exitosamente');
      return { success: true, results };
    } else {
      console.log('Algunas partes fallaron al enviar');
      return { success: false, results };
    }
    
  } catch (error) {
    console.error('Error enviando respuesta DM:', error);
    return { success: false, error: error.message };
  }
}

// Función para enviar respuesta a comentario de Instagram
async function sendInstagramCommentReply(commentId, reply) {
  try {
    const response = await fetch(`https://graph.instagram.com/v21.0/${commentId}/replies`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: reply
      })
    });

    if (response.ok) {
      console.log('Respuesta enviada exitosamente al comentario:', commentId);
    } else {
      console.error('Error enviando respuesta al comentario:', await response.text());
    }
  } catch (error) {
    console.error('Error en sendInstagramCommentReply:', error);
  }
}

// Like a un comentario en Instagram
async function likeInstagramComment(commentId) {
  try {
    const url = `https://graph.facebook.com/v20.0/${commentId}/likes`;
    const resp = await fetch(url, {
      method: 'POST',
      headers: { 'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}` }
    });
    if (!resp.ok) {
      const t = await resp.text();
      console.error('Error dando like al comentario:', t);
      return false;
    }
    return true;
  } catch (e) {
    console.error('Error en likeInstagramComment:', e);
    return false;
  }
}

// Clasificación de sentimiento con Gemini (positivo/neutral/negativo)
async function classifyCommentSentiment(text) {
  try {
    const client = getGeminiClient();
    if (!client) return 'neutral';
    const prompt = `Clasifica el sentimiento del siguiente comentario como una sola palabra exacta: positivo, neutral o negativo. Devuelve solo esa palabra en minúsculas.\n\nComentario: "${text}"`;
    const res = await client.models.generateContent({
      model: 'gemini-2.5-flash-lite',
      contents: prompt
    });
    const out = (res.text || '').trim().toLowerCase();
    if (out.startsWith('neg')) return 'negativo';
    if (out.startsWith('pos')) return 'positivo';
    return 'neutral';
  } catch (_) {
    return 'neutral';
  }
}

// Responder al comentario del usuario
async function replyAndMaybeLike(commentId, originalCommentText, replyText) {
  // Responder al comentario
  await sendInstagramCommentReply(commentId, replyText);
  
}

// Función para obtener información de story desde reply
async function getStoryInfoFromReply(messageData) {
  try {
    // Verificar si el mensaje tiene información de story
    if (messageData.story && messageData.story.id) {
      return await getStoryInfo(messageData.story.id);
    }
    return null;
  } catch (error) {
    console.error('Error obteniendo info de story desde reply:', error);
    return null;
  }
}

// Función para convertir formato Markdown a formato Instagram
function convertToInstagramFormat(text) {
  if (!text) return text;
  
  // Instagram usa:
  // *texto* para negrita
  // _texto_ para cursiva  
  // ~texto~ para tachado
  
  // La IA genera _texto_ pensando que es cursiva, pero necesitamos *texto* para negrita
  // Así que simplemente retornamos el texto sin cambios porque la IA ya lo genera correcto
  
  return text;
}

// Configuración de Fuse.js para fuzzy search
const fuseOptions = {
  // Configuración para mensajes
  messages: {
    keys: [
      { name: 'content', weight: 0.7 },
      { name: 'author_name', weight: 0.3 }
    ],
    threshold: 0.4, // 0.0 = coincidencia exacta, 1.0 = coincide con todo
    distance: 100, // Distancia máxima de búsqueda
    includeScore: true,
    includeMatches: true,
    minMatchCharLength: 2,
    shouldSort: true,
    findAllMatches: true,
    ignoreLocation: true,
    useExtendedSearch: true
  },
  
  // Configuración para conversaciones
  conversations: {
    keys: [
      { name: 'username', weight: 0.6 },
      { name: 'external_conversation_id', weight: 0.4 }
    ],
    threshold: 0.3,
    distance: 50,
    includeScore: true,
    includeMatches: true,
    minMatchCharLength: 2,
    shouldSort: true,
    findAllMatches: true,
    ignoreLocation: true,
    useExtendedSearch: true
  }
};

// Función para fuzzy search en mensajes
function fuzzySearchMessages(messages, query) {
  if (!query || query.trim().length < 2) return [];
  
  const fuse = new Fuse(messages, fuseOptions.messages);
  const results = fuse.search(query);
  
  return results.map(result => ({
    ...result.item,
    score: result.score,
    matches: result.matches
  }));
}

// Función para fuzzy search en conversaciones
function fuzzySearchConversations(conversations, query) {
  if (!query || query.trim().length < 2) return [];
  
  const fuse = new Fuse(conversations, fuseOptions.conversations);
  const results = fuse.search(query);
  
  return results.map(result => ({
    ...result.item,
    score: result.score,
    matches: result.matches
  }));
}

// Función para búsqueda híbrida (exacta + fuzzy)
async function hybridSearch(query, type = 'all', filters = {}) {
  const searchQuery = query.trim();
  let results = {
    conversations: [],
    messages: [],
    total_conversations: 0,
    total_messages: 0,
    query: searchQuery,
    search_type: 'hybrid',
    filters
  };
  
  // Primero hacer búsqueda exacta en Supabase
  let exactConversations = [];
  let exactMessages = [];
  
  if (type === 'conversations' || type === 'all') {
    const { data: convData } = await supabase
      .from('conversaciones')
      .select(`
        id,
        platform,
        conversation_type,
        external_conversation_id,
        user_id,
        username,
        status,
        created_at,
        updated_at
      `)
      .eq('platform', filters.platform || 'instagram')
      .eq('conversation_type', filters.conversation_type || 'dm')
      .or(`username.ilike.%${searchQuery}%,external_conversation_id.ilike.%${searchQuery}%`);
    
    exactConversations = convData || [];
  }
  
  if (type === 'messages' || type === 'all') {
    let msgQuery = supabase
      .from('mensajes')
      .select(`
        id,
        content,
        message_type,
        is_ai_generated,
        author_name,
        author_type,
        ai_model,
        created_at,
        sent_at,
        delivery_status,
        conversacion_id,
        conversaciones!inner(
          id,
          platform,
          conversation_type,
          user_id,
          username,
          status
        )
      `)
      .eq('conversaciones.platform', filters.platform || 'instagram')
      .eq('conversaciones.conversation_type', filters.conversation_type || 'dm')
      .ilike('content', `%${searchQuery}%`);
    
    if (filters.author_type) {
      msgQuery = msgQuery.eq('author_type', filters.author_type);
    }
    
    const { data: msgData } = await msgQuery;
    exactMessages = msgData || [];
  }
  
  // Si hay pocos resultados exactos, hacer fuzzy search en más datos
  if (exactMessages.length < 10 && (type === 'messages' || type === 'all')) {
    const { data: allMessages } = await supabase
      .from('mensajes')
      .select(`
        id,
        content,
        message_type,
        is_ai_generated,
        author_name,
        author_type,
        ai_model,
        created_at,
        sent_at,
        delivery_status,
        conversacion_id,
        conversaciones!inner(
          id,
          platform,
          conversation_type,
          user_id,
          username,
          status
        )
      `)
      .eq('conversaciones.platform', filters.platform || 'instagram')
      .eq('conversaciones.conversation_type', filters.conversation_type || 'dm')
      .limit(1000); // Limitar para rendimiento
    
    if (allMessages) {
      const fuzzyResults = fuzzySearchMessages(allMessages, searchQuery);
      
      // Combinar resultados exactos y fuzzy, eliminando duplicados
      const combinedMessages = [...exactMessages];
      const exactIds = new Set(exactMessages.map(m => m.id));
      
      fuzzyResults.forEach(msg => {
        if (!exactIds.has(msg.id)) {
          combinedMessages.push(msg);
        }
      });
      
      results.messages = combinedMessages.slice(0, filters.limit || 50);
    } else {
      results.messages = exactMessages;
    }
  } else {
    results.messages = exactMessages;
  }
  
  // Mismo proceso para conversaciones
  if (exactConversations.length < 5 && (type === 'conversations' || type === 'all')) {
    const { data: allConversations } = await supabase
      .from('conversaciones')
      .select(`
        id,
        platform,
        conversation_type,
        external_conversation_id,
        user_id,
        username,
        status,
        created_at,
        updated_at
      `)
      .eq('platform', filters.platform || 'instagram')
      .eq('conversation_type', filters.conversation_type || 'dm')
      .limit(500);
    
    if (allConversations) {
      const fuzzyResults = fuzzySearchConversations(allConversations, searchQuery);
      
      const combinedConversations = [...exactConversations];
      const exactIds = new Set(exactConversations.map(c => c.id));
      
      fuzzyResults.forEach(conv => {
        if (!exactIds.has(conv.id)) {
          combinedConversations.push(conv);
        }
      });
      
      results.conversations = combinedConversations.slice(0, filters.limit || 50);
    } else {
      results.conversations = exactConversations;
    }
  } else {
    results.conversations = exactConversations;
  }
  
  results.total_conversations = results.conversations.length;
  results.total_messages = results.messages.length;
  results.total_results = results.total_conversations + results.total_messages;
  
  return results;
}

// Función para búsqueda exacta tradicional (fallback)
async function exactSearch(query, type = 'all', filters = {}) {
  const searchQuery = query.trim();
  let results = {
    conversations: [],
    messages: [],
    total_conversations: 0,
    total_messages: 0,
    query: searchQuery,
    search_type: 'exact',
    filters
  };
  
  // Búsqueda en conversaciones
  if (type === 'conversations' || type === 'all') {
    let convQuery = supabase
      .from('conversaciones')
      .select(`
        id,
        platform,
        conversation_type,
        external_conversation_id,
        user_id,
        username,
        status,
        created_at,
        updated_at
      `)
      .eq('platform', filters.platform || 'instagram')
      .eq('conversation_type', filters.conversation_type || 'dm')
      .or(`username.ilike.%${searchQuery}%,external_conversation_id.ilike.%${searchQuery}%`);
    
    // Filtros de fecha
    if (filters.date_from) {
      convQuery = convQuery.gte('created_at', filters.date_from);
    }
    if (filters.date_to) {
      convQuery = convQuery.lte('created_at', filters.date_to);
    }
    
    const { data: conversations, error: convError } = await convQuery
      .order('updated_at', { ascending: false })
      .range(filters.offset || 0, (filters.offset || 0) + (filters.limit || 50) - 1);
    
    if (convError) {
      console.error('Error buscando conversaciones:', convError);
    } else {
      results.conversations = conversations || [];
    }
    
    // Contar total de conversaciones
    const { count: convCount } = await supabase
      .from('conversaciones')
      .select('*', { count: 'exact', head: true })
      .eq('platform', filters.platform || 'instagram')
      .eq('conversation_type', filters.conversation_type || 'dm')
      .or(`username.ilike.%${searchQuery}%,external_conversation_id.ilike.%${searchQuery}%`);
    
    results.total_conversations = convCount || 0;
  }
  
  // Búsqueda en mensajes
  if (type === 'messages' || type === 'all') {
    let msgQuery = supabase
      .from('mensajes')
      .select(`
        id,
        content,
        message_type,
        is_ai_generated,
        author_name,
        author_type,
        ai_model,
        created_at,
        sent_at,
        delivery_status,
        conversacion_id,
        conversaciones!inner(
          id,
          platform,
          conversation_type,
          user_id,
          username,
          status
        )
      `)
      .eq('conversaciones.platform', filters.platform || 'instagram')
      .eq('conversaciones.conversation_type', filters.conversation_type || 'dm')
      .ilike('content', `%${searchQuery}%`);
    
    // Filtros adicionales
    if (filters.author_type) {
      msgQuery = msgQuery.eq('author_type', filters.author_type);
    }
    
    // Filtros de fecha
    if (filters.date_from) {
      msgQuery = msgQuery.gte('created_at', filters.date_from);
    }
    if (filters.date_to) {
      msgQuery = msgQuery.lte('created_at', filters.date_to);
    }
    
    const { data: messages, error: msgError } = await msgQuery
      .order('created_at', { ascending: false })
      .range(filters.offset || 0, (filters.offset || 0) + (filters.limit || 50) - 1);
    
    if (msgError) {
      console.error('Error buscando mensajes:', msgError);
    } else {
      results.messages = messages || [];
    }
    
    // Contar total de mensajes
    const { count: msgCount } = await supabase
      .from('mensajes')
      .select('*', { count: 'exact', head: true })
      .eq('conversaciones.platform', filters.platform || 'instagram')
      .eq('conversaciones.conversation_type', filters.conversation_type || 'dm')
      .ilike('content', `%${searchQuery}%`);
    
    results.total_messages = msgCount || 0;
  }
  
  // Calcular total general
  results.total_results = results.total_conversations + results.total_messages;
  
  return results;
}

// Función para obtener datos faltantes del usuario
async function getUserMissingData(userId) {
  try {
    const { data: conversation, error } = await supabase
      .from('conversaciones')
      .select('*')
      .eq('user_id', userId)
      .eq('platform', 'instagram')
      .eq('conversation_type', 'dm')
      .single();

    if (error || !conversation) {
      return null;
    }

    const missingData = [];
    
    if (!conversation.user_full_name) missingData.push('name');
    if (!conversation.user_profession) missingData.push('profession');
    if (!conversation.user_studies) missingData.push('studies');
    if (!conversation.user_experience_years) missingData.push('experience');
    if (!conversation.user_skills || conversation.user_skills.length === 0) missingData.push('skills');
    if (!conversation.user_location) missingData.push('location');
    if (!conversation.user_languages || conversation.user_languages.length === 0) missingData.push('languages');
    if (!conversation.user_salary_expectation) missingData.push('salary');
    if (!conversation.user_availability) missingData.push('availability');
    if (!conversation.user_interests || conversation.user_interests.length === 0) missingData.push('interests');

    // Obtener preferencias del usuario basadas en likes (asíncrono, no bloquea)
    let preferencesContext = null;
    try {
      const UserPreferencesService = require('../services/UserPreferencesService');
      const preferencesService = new UserPreferencesService();
      
      // Verificar si tiene suficientes datos para análisis
      const hasEnoughData = await preferencesService.hasEnoughData(userId, 5);
      if (hasEnoughData) {
        preferencesContext = await preferencesService.getUserPreferencesContext(userId);
      }
    } catch (prefError) {
      console.warn('No se pudieron obtener preferencias del usuario:', prefError.message);
      // No fallar si no se pueden obtener preferencias
    }

    // Agregar preferencias al objeto de conversación si están disponibles
    const conversationWithPreferences = {
      ...conversation,
      user_data_completion_percentage: Math.round(((10 - missingData.length) / 10) * 100),
      user_preferences_context: preferencesContext
    };

    return {
      conversation: conversationWithPreferences,
      missingData,
      completionPercentage: Math.round(((10 - missingData.length) / 10) * 100)
    };
  } catch (error) {
    console.error('Error obteniendo datos faltantes:', error);
    return null;
  }
}

// Función para obtener siguiente pregunta de recolección de datos
async function getNextDataCollectionQuestion(userId, context = 'general') {
  try {
    const userData = await getUserMissingData(userId);
    
    if (!userData || userData.missingData.length === 0) {
      return null; // Usuario tiene todos los datos
    }

    // Solo hacer preguntas si el usuario está interesado en algo específico
    const shouldAskQuestions = context === 'vacancy_interest' || 
                              context === 'cv_help' || 
                              context === 'job_search' ||
                              userData.completionPercentage < 30; // Solo si tiene muy pocos datos

    if (!shouldAskQuestions) {
      return null;
    }

    // Obtener preguntas ordenadas
    const { data: questions, error } = await supabase
      .from('data_collection_questions')
      .select('*')
      .in('question_type', userData.missingData)
      .eq('is_active', true)
      .order('question_order', { ascending: true });

    if (error || !questions || questions.length === 0) {
      return null;
    }

    // Retornar la primera pregunta disponible
    const question = questions[0];
    
    // Reemplazar placeholder {name} si existe
    let questionText = question.question_text;
    if (questionText.includes('{name}') && userData.conversation.user_full_name) {
      questionText = questionText.replace('{name}', userData.conversation.user_full_name);
    }

    return {
      question_type: question.question_type,
      question_text: questionText,
      is_required: question.is_required,
      missing_data: userData.missingData,
      completion_percentage: userData.completionPercentage
    };
  } catch (error) {
    console.error('Error obteniendo siguiente pregunta:', error);
    return null;
  }
}

// Función para detectar y extraer automáticamente datos del mensaje
async function detectAndExtractUserData(messageText) {
  try {
    const geminiClient = getGeminiClient();
    if (!geminiClient) return {};

    const prompt = `Analiza el siguiente mensaje del usuario y extrae TODA la información relevante que puedas identificar.

Mensaje: "${messageText}"

Extrae información para estos campos si está presente:
- user_full_name: Nombre completo
- user_profession: Profesión o área de trabajo
- user_studies: Estudios o formación académica
- user_experience_years: Años de experiencia (solo número)
- user_skills: Habilidades técnicas o profesionales (como array JSON)
- user_location: Ciudad o país
- user_languages: Idiomas que maneja (como array JSON)
- user_salary_expectation: Expectativa salarial
- user_availability: Disponibilidad laboral
- user_interests: Intereses profesionales (como array JSON)
- user_company_size_preference: Preferencia de tamaño de empresa
- user_industry_preference: Industria preferida (como array JSON)
- user_work_mode_preference: Modalidad de trabajo (remoto, presencial, híbrido)
- user_career_level: Nivel profesional (junior, mid, senior, etc.)
- user_portfolio_url: URL del portfolio
- user_linkedin_url: URL de LinkedIn
- user_github_url: URL de GitHub

Responde SOLO con un objeto JSON que contenga los campos encontrados. Si no encuentras información para un campo, no lo incluyas.

Ejemplo de respuesta:
{
  "user_full_name": "Juan Pérez",
  "user_profession": "Desarrollador",
  "user_experience_years": "3",
  "user_skills": ["JavaScript", "React", "Node.js"],
  "user_location": "Bogotá"
}`;

    const response = await geminiClient.models.generateContent({
      model: "gemini-2.5-flash-lite",
      contents: prompt
    });
    const extractedData = (response.text || '').trim();
    
    if (extractedData) {
      try {
        const parsed = JSON.parse(extractedData);
        return parsed;
      } catch (error) {
        console.warn('Error parseando datos extraídos:', extractedData);
        return {};
      }
    }

    return {};
  } catch (error) {
    console.error('Error detectando datos del mensaje:', error);
    return {};
  }
}

// Función para extraer datos del mensaje del usuario
async function extractUserDataFromMessage(messageText, dataType) {
  try {
    const geminiClient = getGeminiClient();
    if (!geminiClient) return null;

    const extractionPrompt = `Extrae la información relevante del siguiente mensaje del usuario para el campo "${dataType}".

Mensaje: "${messageText}"

Tipo de dato: ${dataType}

Instrucciones específicas:
- Si es "user_full_name": Extrae el nombre completo (ej: "Juan Pérez", "María García")
- Si es "user_profession": Extrae profesión o área (ej: "Desarrollador", "Diseñador", "Marketing")
- Si es "user_studies": Extrae estudios o formación (ej: "Ingeniería de Sistemas", "Diseño Gráfico")
- Si es "user_experience_years": Extrae solo el número de años (ej: "3", "5", "10")
- Si es "user_skills": Extrae habilidades como array (ej: ["JavaScript", "React", "Node.js"])
- Si es "user_location": Extrae ciudad o país (ej: "Bogotá", "Medellín", "Colombia")
- Si es "user_languages": Extrae idiomas como array (ej: ["Español", "Inglés"])
- Si es "user_salary_expectation": Extrae expectativa salarial (ej: "3.000.000", "USD 2000")
- Si es "user_availability": Extrae disponibilidad (ej: "Inmediata", "1 mes", "Part-time")
- Si es "user_interests": Extrae intereses como array (ej: ["Tecnología", "Startups"])
- Si es "user_company_size_preference": Extrae tamaño de empresa (ej: "Startup", "Mediana", "Grande")
- Si es "user_industry_preference": Extrae industria como array (ej: ["Tech", "Fintech", "E-commerce"])
- Si es "user_work_mode_preference": Extrae modalidad (ej: "Remoto", "Presencial", "Híbrido")
- Si es "user_career_level": Extrae nivel (ej: "Junior", "Mid-level", "Senior")
- Si es "user_portfolio_url": Extrae URL del portfolio
- Si es "user_linkedin_url": Extrae URL de LinkedIn
- Si es "user_github_url": Extrae URL de GitHub

Responde SOLO con el valor extraído en el formato correcto. Si no encuentras información relevante, responde "null".`;

    const response = await geminiClient.models.generateContent({
      model: "gemini-2.5-flash-lite",
      contents: extractionPrompt
    });
    const extractedData = (response.text || '').trim();
    
    if (extractedData && extractedData !== 'null' && extractedData !== 'null.') {
      console.log(`Datos extraídos para ${dataType}:`, extractedData);
      return extractedData;
    }

    return null;
  } catch (error) {
    console.error('Error extrayendo datos del mensaje:', error);
    return null;
  }
}

// Función para actualizar datos del usuario
async function updateUserData(userId, dataType, dataValue) {
  try {
    const updateData = {};
    
    switch (dataType) {
      case 'user_full_name':
        updateData.user_full_name = dataValue;
        break;
      case 'user_profession':
        updateData.user_profession = dataValue;
        break;
      case 'user_studies':
        updateData.user_studies = dataValue;
        break;
      case 'user_experience_years':
        // Extraer número de años
        const years = dataValue.match(/\d+/);
        if (years) {
          updateData.user_experience_years = parseInt(years[0]);
        }
        break;
      case 'user_skills':
        // Convertir a array si es texto
        if (typeof dataValue === 'string') {
          try {
            // Intentar parsear como JSON array
            const parsed = JSON.parse(dataValue);
            if (Array.isArray(parsed)) {
              updateData.user_skills = parsed;
            } else {
              updateData.user_skills = dataValue.split(',').map(s => s.trim());
            }
          } catch {
            updateData.user_skills = dataValue.split(',').map(s => s.trim());
          }
        } else {
          updateData.user_skills = dataValue;
        }
        break;
      case 'user_location':
        updateData.user_location = dataValue;
        break;
      case 'user_languages':
        // Convertir a array si es texto
        if (typeof dataValue === 'string') {
          try {
            const parsed = JSON.parse(dataValue);
            if (Array.isArray(parsed)) {
              updateData.user_languages = parsed;
            } else {
              updateData.user_languages = dataValue.split(',').map(s => s.trim());
            }
          } catch {
            updateData.user_languages = dataValue.split(',').map(s => s.trim());
          }
        } else {
          updateData.user_languages = dataValue;
        }
        break;
      case 'user_salary_expectation':
        updateData.user_salary_expectation = dataValue;
        break;
      case 'user_availability':
        updateData.user_availability = dataValue;
        break;
      case 'user_interests':
        // Convertir a array si es texto
        if (typeof dataValue === 'string') {
          try {
            const parsed = JSON.parse(dataValue);
            if (Array.isArray(parsed)) {
              updateData.user_interests = parsed;
            } else {
              updateData.user_interests = dataValue.split(',').map(s => s.trim());
            }
          } catch {
            updateData.user_interests = dataValue.split(',').map(s => s.trim());
          }
        } else {
          updateData.user_interests = dataValue;
        }
        break;
      case 'user_company_size_preference':
        updateData.user_company_size_preference = dataValue;
        break;
      case 'user_industry_preference':
        // Convertir a array si es texto
        if (typeof dataValue === 'string') {
          try {
            const parsed = JSON.parse(dataValue);
            if (Array.isArray(parsed)) {
              updateData.user_industry_preference = parsed;
            } else {
              updateData.user_industry_preference = dataValue.split(',').map(s => s.trim());
            }
          } catch {
            updateData.user_industry_preference = dataValue.split(',').map(s => s.trim());
          }
        } else {
          updateData.user_industry_preference = dataValue;
        }
        break;
      case 'user_work_mode_preference':
        updateData.user_work_mode_preference = dataValue;
        break;
      case 'user_career_level':
        updateData.user_career_level = dataValue;
        break;
      case 'user_portfolio_url':
        updateData.user_portfolio_url = dataValue;
        break;
      case 'user_linkedin_url':
        updateData.user_linkedin_url = dataValue;
        break;
      case 'user_github_url':
        updateData.user_github_url = dataValue;
        break;
    }

    // Actualizar conversación
    const { data, error } = await supabase
      .from('conversaciones')
      .update({
        ...updateData,
        last_data_collection: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })
      .eq('user_id', userId)
      .eq('platform', 'instagram')
      .eq('conversation_type', 'dm')
      .select()
      .single();

    if (error) {
      console.error('Error actualizando datos del usuario:', error);
      return null;
    }

    // Recalcular porcentaje de completitud
    const userData = await getUserMissingData(userId);
    if (userData) {
      await supabase
        .from('conversaciones')
        .update({
          user_data_completion_percentage: userData.completionPercentage,
          updated_at: new Date().toISOString()
        })
        .eq('user_id', userId)
        .eq('platform', 'instagram')
        .eq('conversation_type', 'dm');
    }

    return data;
  } catch (error) {
    console.error('Error en updateUserData:', error);
    return null;
  }
}

// Función para verificar si un comentario ya fue procesado
async function isCommentAlreadyProcessed(commentId) {
  try {
    const { data, error } = await supabase
      .from('instagram_comments')
      .select('id')
      .eq('instagram_comment_id', commentId)
      .single();
    
    return !error && data;
  } catch (error) {
    console.error('Error verificando comentario procesado:', error);
    return false;
  }
}

// Función para obtener o crear un post de Instagram
async function getOrCreateInstagramPost(mediaInfo) {
  try {
    if (!mediaInfo || !mediaInfo.id) {
      throw new Error('Información de media no válida');
    }

    // Buscar post existente por instagram_post_id primero, luego por media_id
    let existingPost = null;
    let searchError = null;
    
    // Primero buscar por instagram_post_id
    const { data: postById, error: errorById } = await supabase
      .from('instagram_posts')
      .select('*')
      .eq('instagram_post_id', mediaInfo.id)
      .single();
    
    if (postById && !errorById) {
      existingPost = postById;
    } else {
      // Si no se encuentra por instagram_post_id, buscar por media_id
      const { data: postByMediaId, error: errorByMediaId } = await supabase
        .from('instagram_posts')
        .select('*')
        .eq('media_id', mediaInfo.id)
        .single();
      
      existingPost = postByMediaId;
      searchError = errorByMediaId;
    }

    if (existingPost && !searchError) {
      return existingPost;
    }

    // Crear nuevo post solo si no existe
    const { data: newPost, error: insertError } = await supabase
      .from('instagram_posts')
      .insert({
        media_id: mediaInfo.id,
        instagram_post_id: mediaInfo.id,
        media_type: mediaInfo.media_type || 'IMAGE',
        image_url: mediaInfo.media_url || '',
        media_url: mediaInfo.media_url,
        caption: mediaInfo.caption,
        permalink: mediaInfo.permalink,
        timestamp: mediaInfo.timestamp ? new Date(mediaInfo.timestamp) : new Date()
      })
      .select()
      .single();

    if (insertError) {
      console.error('Error creando post:', insertError);
      throw insertError;
    }

    return newPost;
  } catch (error) {
    console.error('Error en getOrCreateInstagramPost:', error);
    throw error;
  }
}

// Función para guardar un comentario de Instagram
async function saveInstagramComment(commentData) {
  try {
    const { data, error } = await supabase
      .from('instagram_comments')
      .insert({
        post_id: commentData.post_id,
        instagram_comment_id: commentData.instagram_comment_id,
        parent_comment_id: commentData.parent_comment_id || null,
        user_id: commentData.user_id,
        username: commentData.username,
        comment_text: commentData.comment_text,
        is_ai_response: commentData.is_ai_response || false,
        ai_model: commentData.ai_model || null
      })
      .select()
      .single();

    if (error) {
      console.error('Error guardando comentario:', error);
      throw error;
    }

    // Notificar nuevo comentario vía SSE
    try {
      notifyNewComment({
        id: data.id,
        post_id: data.post_id,
        username: data.username,
        comment_text: data.comment_text,
        is_ai_response: data.is_ai_response,
        created_at: data.created_at
      });
      console.log('📢 Notificación SSE enviada para nuevo comentario:', data.id);
    } catch (notifyError) {
      console.error('Error enviando notificación SSE de comentario:', notifyError);
      // No fallar si la notificación falla
    }

    return data;
  } catch (error) {
    console.error('Error en saveInstagramComment:', error);
    throw error;
  }
}

// Función para obtener comentarios de un post
async function getPostComments(postId, includeReplies = true) {
  try {
    let query = supabase
      .from('instagram_comments')
      .select(`
        *,
        replies:instagram_comments!parent_comment_id(
          id,
          instagram_comment_id,
          user_id,
          username,
          comment_text,
          is_ai_response,
          ai_model,
          created_at
        )
      `)
      .eq('post_id', postId)
      .is('parent_comment_id', null) // Solo comentarios principales
      .order('created_at', { ascending: true });

    const { data, error } = await query;

    if (error) {
      console.error('Error obteniendo comentarios:', error);
      throw error;
    }

    return data || [];
  } catch (error) {
    console.error('Error en getPostComments:', error);
    throw error;
  }
}

// Función para obtener todos los posts con estadísticas
async function getAllInstagramPosts(limit = 20, offset = 0) {
  try {
    // Primero obtener los posts
    const { data: posts, error: postsError } = await supabase
      .from('instagram_posts')
      .select('*')
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (postsError) {
      console.error('Error obteniendo posts:', postsError);
      throw postsError;
    }

    if (!posts || posts.length === 0) {
      return [];
    }

    // Para cada post, obtener el conteo de comentarios
    const postsWithStats = await Promise.all(
      posts.map(async (post) => {
        // Obtener conteo de comentarios totales
        const { count: totalComments } = await supabase
          .from('instagram_comments')
          .select('*', { count: 'exact', head: true })
          .eq('post_id', post.id);

        // Obtener conteo de respuestas de IA
        const { count: aiComments } = await supabase
          .from('instagram_comments')
          .select('*', { count: 'exact', head: true })
          .eq('post_id', post.id)
          .eq('is_ai_response', true);

        // Obtener conteo de comentarios de usuarios
        const { count: userComments } = await supabase
          .from('instagram_comments')
          .select('*', { count: 'exact', head: true })
          .eq('post_id', post.id)
          .eq('is_ai_response', false);

        // Obtener conteo de likes desde Instagram API usando like_count
        let likesCount = 0;
        if (post.instagram_post_id || post.media_id) {
          try {
            const mediaId = post.instagram_post_id || post.media_id;
            const mediaInfo = await getInstagramMediaInfo(mediaId);
            if (mediaInfo && mediaInfo.like_count !== undefined) {
              likesCount = mediaInfo.like_count;
            }
          } catch (error) {
            console.warn(`No se pudo obtener like_count para post ${post.id}:`, error.message);
          }
        }

        return {
          ...post,
          stats: {
            total_comments: totalComments || 0,
            user_comments: userComments || 0,
            ai_comments: aiComments || 0,
            likes: likesCount // Conteo de likes desde Instagram API usando like_count
          }
        };
      })
    );

    return postsWithStats;
  } catch (error) {
    console.error('Error en getAllInstagramPosts:', error);
    throw error;
  }
}

module.exports = {
  // Clientes
  supabase,
  getGeminiClient,
  convertMessagesForGemini,
  
  // Sistema de notificaciones
  clients,
  sendNotificationToClients,
  notifyNewMessage,
  notifyNewConversation,
  
  // Instagram API
  getInstagramUserInfo,
  getInstagramUsername,
  getInstagramMediaInfo,
  getInstagramPostLikes,
  getInstagramPostLikeCount,
  getAllInstagramAccountMedia,
  syncInstagramPostLikes,
  getStoryInfo,
  getStoryInfoFromReply,
  sendInstagramDMReply,
  sendInstagramCommentReply,
  replyAndMaybeLike,
  
  // Emociones
  detectUserEmotion,
  updateUserProfileInfo,
  
  // Mensajes y conversaciones
  getUserMessageHistory,
  buildMessages,
  buildMessagesWithContent,
  getRecentContentForAI,
  getRelevantContentForUser,
  getPostsAnalytics,
  getDMAnalytics,
  generateAIAnalytics,
  generateImproveSuggestions,
  generateCaptionOptions,
  saveConversationToSupabase,
  saveMessageToSupabase,
  isMessageAlreadyProcessed,
  generateDMConversationId,
  getOrCreateDMConversation,
  
  // Imágenes y Videos
  uploadImageToStorage,
  generateImageWithGemini,
  generateVideo,
  generateAIContent,
  publishInstagramPost,
  publishInstagramStory,
  publishInstagramReel,
  createVacancyImageTemplate,
  
  // Utilidades
  splitLongMessage,
  convertToInstagramFormat,
  
  // Búsqueda
  fuzzySearchMessages,
  fuzzySearchConversations,
  hybridSearch,
  exactSearch,
  
  // Recolección de datos
  getUserMissingData,
  getNextDataCollectionQuestion,
  extractUserDataFromMessage,
  detectAndExtractUserData,
  updateUserData,
  
  // Comentarios y posts de Instagram
  isCommentAlreadyProcessed,
  getOrCreateInstagramPost,
  saveInstagramComment,
  getPostComments,
  getAllInstagramPosts,
  
  // Constantes
  SYSTEM_PROMPT,
  fuseOptions,
  
  // Notificaciones
  notifyNewComment
};

// Función unificada para generar preview completo (imagen + captions + sugerencias)
async function generateCompletePreview(topic, style, targetAudience, type = 'post', referenceImage = null) {
  try {
    if (type === 'reel') {
      throw new Error('Para reels usar generateCompleteReelPreview');
    }
    
    if (type === 'story') {
      const mediaUrl = await generateImageWithGemini(topic, referenceImage, 'story');
      
      if (!mediaUrl) {
        throw new Error('Error generando media');
      }
      return {
        mediaUrl,
        captionOptions: null, // Stories no tienen captions
        improveSuggestions: null // Stories no tienen sugerencias de mejora
      };
    }
    
    const [mediaUrl, captionOptions] = await Promise.all([
      generateImageWithGemini(topic, referenceImage, 'post'),
      generateCaptionOptions(topic, style, targetAudience)
    ]);
    
    if (!mediaUrl) {
      throw new Error('Error generando media');
    }
    
    const improveSuggestions = await generateImproveSuggestions(topic, style, targetAudience, mediaUrl);
    return {
      mediaUrl,
      captionOptions,
      improveSuggestions
    };
  } catch (error) {
    console.error('Error generando preview completo:', error);
    return null;
  }
}

// Función de streaming para generar preview completo (imagen + captions + sugerencias)
async function generateCompletePreviewStream(topic, style, targetAudience, type = 'post', referenceImage = null, sendEvent) {
  try {
    if (type === 'reel') {
      throw new Error('Para reels usar generateCompleteReelPreviewStream');
    }
    
    if (type === 'story') {
      sendEvent('status', { message: 'Generando story...' });
      
      const mediaUrl = await generateImageWithGemini(topic, referenceImage, 'story');
      
      if (!mediaUrl) {
        sendEvent('error', { message: 'Error generando media' });
        return;
      }
      
      sendEvent('media', { mediaUrl, type: 'image' });
      
      try {
        const previewData = {
          type: 'story',
          topic: topic,
          style: style,
          target_audience: targetAudience,
          image_url: mediaUrl,
          status: 'draft',
          suggested_caption: null,
          improve_suggestions: null,
          created_by: 'user',
        };

        const { data: savedPreview, error: saveError } = await supabase
          .from('instagram_previews')
          .insert(previewData)
          .select()
          .single();

        if (saveError) {
          console.error('Error guardando preview de story:', saveError);
          sendEvent('error', { message: `Error guardando preview: ${saveError.message}` });
        } else if (savedPreview) {
          sendEvent('preview_saved', { previewId: savedPreview.id });
        }
      } catch (saveErr) {
        console.error('Excepción al guardar preview de story:', saveErr);
        sendEvent('error', { message: `Error guardando preview: ${saveErr.message}` });
      }
      return;
    }
    
    sendEvent('status', { message: 'Generando opciones de caption...' });
    const captionOptions = await generateCaptionOptions(topic, style, targetAudience);
    
    if (captionOptions) {
      sendEvent('captions', { captionOptions });
    }
    
    sendEvent('status', { message: 'Generando imagen...' });
    const mediaUrl = await generateImageWithGemini(topic, referenceImage, 'post');
    
    if (!mediaUrl) {
      sendEvent('error', { message: 'Error generando media' });
      return;
    }
    
    sendEvent('media', { mediaUrl, type: 'image' });
    
    sendEvent('status', { message: 'Generando sugerencias de mejora...' });
    const improveSuggestions = await generateImproveSuggestions(topic, style, targetAudience, mediaUrl);
    
    if (improveSuggestions) {
      sendEvent('suggestions', { improveSuggestions });
    }
  } catch (error) {
    console.error('Error generando preview completo en streaming:', error);
    sendEvent('error', { message: error.message });
  }
}

// Función de streaming para generar preview completo de reel
async function generateCompleteReelPreviewStream(prompt, accent, style, duration, targetAudience, sendEvent) {
  try {
    sendEvent('status', { message: 'Generando opciones de caption...' });
    const captionOptions = await generateCaptionOptions(prompt, 'reel', targetAudience);
    
    if (captionOptions) {
      sendEvent('captions', { captionOptions });
    }
    
    sendEvent('status', { message: 'Generando video...' });
    
    let videoUrl = null;
    let attempts = 0;
    const maxVideoAttempts = 2;
    
    while (!videoUrl && attempts < maxVideoAttempts) {
      attempts++;
      sendEvent('status', { message: `Generando video... (Intento ${attempts}/${maxVideoAttempts})` });
      
      videoUrl = await generateVideo(prompt, accent, style, duration);
      
      if (!videoUrl && attempts < maxVideoAttempts) {
        sendEvent('status', { message: 'Reintentando generación de video...' });
        await new Promise(resolve => setTimeout(resolve, 30000));
      }
    }
    
    if (!videoUrl) {
      console.error('No se pudo generar video después de', maxVideoAttempts, 'intentos');
      sendEvent('error', { 
        message: 'No se pudo generar el video. El servicio de generación de videos está experimentando problemas técnicos.' 
      });
      return;
    }
    
    sendEvent('media', { videoUrl, type: 'video' });
    
    sendEvent('status', { message: 'Generando sugerencias de mejora...' });
    const improveSuggestions = await generateImproveSuggestions(prompt, 'reel', targetAudience, videoUrl);
    
    if (improveSuggestions) {
      sendEvent('suggestions', { improveSuggestions });
    }
  } catch (error) {
    console.error('Error generando preview completo de reel en streaming:', error);
    sendEvent('error', { message: error.message });
  }
}

// Función unificada para generar preview completo de reel
async function generateCompleteReelPreview(prompt, accent, style, duration, targetAudience) {
  try {
    let videoUrl = null;
    let attempts = 0;
    const maxVideoAttempts = 2;
    
    while (!videoUrl && attempts < maxVideoAttempts) {
      attempts++;
      videoUrl = await generateVideo(prompt, accent, style, duration);
      
      if (!videoUrl && attempts < maxVideoAttempts) {
        await new Promise(resolve => setTimeout(resolve, 30000));
      }
    }
    
    if (!videoUrl) {
      console.error('No se pudo generar video después de', maxVideoAttempts, 'intentos');
      return {
        error: 'No se pudo generar el video. El servicio de generación de videos está experimentando problemas técnicos.',
        videoUrl: null,
        captionOptions: null,
        improveSuggestions: null
      };
    }
    
    // Generar captions y sugerencias en paralelo
    const [captionOptions, improveSuggestions] = await Promise.all([
      generateCaptionOptions(prompt, 'reel', targetAudience),
      generateImproveSuggestions(prompt, 'reel', targetAudience, videoUrl)
    ]);
    
    return {
      videoUrl,
      captionOptions,
      improveSuggestions
    };
  } catch (error) {
    console.error('Error generando preview completo de reel:', error);
    return {
      error: 'Error interno generando preview de reel',
      videoUrl: null,
      captionOptions: null,
      improveSuggestions: null
    };
  }
}

// Función para generar respuesta con function calling
async function generateResponseWithFunctionCalling(userText, context, mediaInfo = null, messageHistory = [], userData = null, userId = null) {
  try {
    
    const geminiClient = getGeminiClient();
    if (!geminiClient) {
      console.error('Cliente Gemini no disponible');
      return { reply: 'Lo siento, no puedo procesar tu mensaje en este momento.', functionCalls: [] };
    }

    // Construir mensajes
    const messages = await buildMessagesWithContent(userText, context, mediaInfo, messageHistory, userData);
    const prompt = convertMessagesForGemini(messages);
    
    // Usar la nueva API de @google/genai
    // Nota: function calling puede requerir configuración adicional en la nueva API
    const response = await geminiClient.models.generateContent({
      model: "gemini-2.5-flash-lite",
      contents: prompt
      // tools: GEMINI_TOOLS // TODO: Verificar cómo se configuran tools en la nueva API
    });
    
    // Verificar si hay function calls (puede requerir ajuste según la nueva API)
    const functionCalls = response.functionCalls || [];
    let reply = response.text || '';
    
    // Procesar function calls si existen
    if (functionCalls && functionCalls.length > 0) {
      
      for (const functionCall of functionCalls) {
        const functionName = functionCall.name;
        const args = functionCall.args;
        
        
        if (userId) {
          const result = await processFunctionCall(functionName, args, userId);
        } else {
          console.warn('No se proporcionó userId para function call');
        }
      }
    }

    return { reply, functionCalls: functionCalls || [] };
  } catch (error) {
    console.error('Error generando respuesta con function calling:', error);
    return { reply: 'Lo siento, hubo un error procesando tu mensaje.', functionCalls: [] };
  }
}

// Agregar las nuevas funciones al module.exports
module.exports.generateCompletePreview = generateCompletePreview;
module.exports.generateCompleteReelPreview = generateCompleteReelPreview;
module.exports.generateCompletePreviewStream = generateCompletePreviewStream;
module.exports.generateCompleteReelPreviewStream = generateCompleteReelPreviewStream;
module.exports.generateResponseWithFunctionCalling = generateResponseWithFunctionCalling;
module.exports.AI_FUNCTIONS = AI_FUNCTION_DECLARATIONS;
module.exports.GEMINI_TOOLS = GEMINI_TOOLS;
module.exports.processFunctionCall = processFunctionCall;
module.exports.videoProcessingQueue = videoProcessingQueue;

async function applyWatermark(baseImageUrl, watermarkUrl, options = {}) {
  try {
    const position = options.position || 'bottom-right';
    const margin = options.margin ?? 24; // px
    const scale = options.scale ?? 0.18; // relative to min(width,height)

    const [baseImg, wmImg] = await Promise.all([loadImage(baseImageUrl), loadImage(watermarkUrl)]);

    const canvas = createCanvas(baseImg.width, baseImg.height);
    const ctx = canvas.getContext('2d');
    ctx.drawImage(baseImg, 0, 0);

    // Compute watermark size
    const target = Math.min(baseImg.width, baseImg.height) * scale;
    const ratio = wmImg.width / wmImg.height;
    const wmW = target;
    const wmH = target / ratio;

    // Positions
    let x = margin;
    let y = baseImg.height - wmH - margin;
    if (position === 'bottom-right') {
      x = baseImg.width - wmW - margin;
      y = baseImg.height - wmH - margin;
    } else if (position === 'top-left') {
      x = margin;
      y = margin;
    } else if (position === 'top-right') {
      x = baseImg.width - wmW - margin;
      y = margin;
    } else if (position === 'bottom-left') {
      x = margin;
      y = baseImg.height - wmH - margin;
    }

    ctx.globalAlpha = options.opacity ?? 0.95; // casi opaco
    ctx.drawImage(wmImg, x, y, wmW, wmH);

    return canvas.toBuffer('image/png');
  } catch (e) {
    console.error('Error aplicando marca de agua:', e);
    return null;
  }
}

// Aplica marca de agua si existe WATERMARK_URL en env; sube a supabase y devuelve nueva URL
async function maybeApplyWatermarkAndReupload(publicUrl) {
  try {
    // Usar variable de entorno si existe; de lo contrario, usar archivo local en la raíz del backend
    const watermarkPath = process.env.WATERMARK_URL || path.join(__dirname, '../../logo_full.png');

    // Verificar si el archivo existe antes de intentar usarlo
    const fs = require('fs');
    if (!process.env.WATERMARK_URL && !fs.existsSync(watermarkPath)) {
      return publicUrl;
    }

    const watermarkUrl = process.env.WATERMARK_URL || watermarkPath;
    
    const buffered = await applyWatermark(publicUrl, watermarkUrl, {
      position: 'bottom-right',
      margin: 32,
      scale: 0.18,
      opacity: 0.95,
    });
    if (!buffered) {
      return publicUrl;
    }

    const fileName = `ai-generated-wm-${Date.now()}.png`;
    const { data, error } = await supabase.storage
      .from('magneto-bucket')
      .upload(`watermarked/${fileName}`, buffered, { contentType: 'image/png', upsert: false });
    if (error) {
      console.error('Error subiendo imagen con watermark:', error);
      return publicUrl;
    }
    const watermarkedUrl = `${process.env.SUPABASE_URL}/storage/v1/object/public/${data.fullPath}`;
    return watermarkedUrl;
  } catch (e) {
    console.error('Error en maybeApplyWatermarkAndReupload:', e);
    return publicUrl;
  }
}
