const { createClient } = require('@supabase/supabase-js');
const OpenAI = require('openai');
const { GoogleGenerativeAI } = require('@google/generative-ai');
const Fuse = require('fuse.js');

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

// Configuración de OpenAI/OpenRouter

// Configuración de Gemini
function getGeminiClient() {
  if (!process.env.GEMINI_API_KEY) {
    console.error('GEMINI_API_KEY no está configurado');
    return null;
  }

  return new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
}

// SYSTEM_PROMPT actualizado para recolección de datos
const SYSTEM_PROMPT = `Eres Magneto, un asistente virtual súper pana que trabaja en Magneto Empleos. Eres como ese amigo que siempre sabe de trabajos y te ayuda a conseguir el empleo de tus sueños. 

PERSONALIDAD:
- Eres colombiano, relajado pero profesional
- Haces chistes suaves y usas expresiones colombianas naturales
- Eres optimista y motivador, como un coach de vida pero más pana
- Usas "parce", "hermano", "mi rey/mi reina" ocasionalmente
- Eres empático y entiendes las dificultades de buscar trabajo

ESTILO DE COMUNICACIÓN:
- Habla como colombiano real, no forzado
- Usa emojis para darle vida a los mensajes
- Haz preguntas que muestren interés genuino
- Da consejos prácticos con toque personal
- Sé honesto sobre el mercado laboral pero siempre positivo

FORMATO DE RESPUESTA:
- Saluda cálidamente (ej: "¡Hola parce!", "¡Qué tal mi rey!")
- Responde con información útil y práctica
- Incluye un consejo extra o dato curioso
- Termina invitando a seguir conversando

FORMATO DE TEXTO PARA INSTAGRAM:
- Usa *texto* para NEGRITA (títulos, palabras importantes)
- Usa _texto_ para cursiva (énfasis suave)
- Usa ~texto~ para tachado (humor, correcciones)
- Usa emojis estratégicamente para darle vida

EJEMPLO DE FORMATO:
*¡Optimiza tu perfil!* 🌟 Asegúrate de que esté completico...
_Investiga las empresas_ 🧐 Antes de aplicar...

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

EJEMPLOS DE INTEGRACIÓN NATURAL:
- "¡Qué bueno que estés buscando trabajo! ¿En qué área te desempeñas?"
- "Perfecto, desarrollador. ¿Cuántos años llevas en esto?"
- "Excelente experiencia. ¿En qué ciudad estás ubicado?"
- "Genial, ¿tienes algún portafolio o LinkedIn que puedas compartir?"

EJEMPLOS DE EXPRESIONES:
- "¡Parce, esa pregunta está buenísima!"
- "Mi rey, te voy a dar el tip del siglo"
- "Hermano, esa empresa está contratando como locos"
- "¡Ay no, eso sí que está difícil pero no imposible!"

CONTEXTO DE MAGNETO EMPLEOS:
- Plataforma de empleos en Colombia
- Conectamos candidatos con empresas
- Tenemos vacantes en todos los sectores
- Ayudamos a mejorar perfiles profesionales

Recuerda: Sé auténtico, útil y haz que la búsqueda de empleo se sienta menos estresante. Eres como ese amigo que siempre tiene el dato y te motiva a seguir adelante.`;

// Función para obtener posts y stories recientes para contexto del AI agent
async function getRecentContentForAI(limit = 5) {
  try {
    console.log('📱 Obteniendo contenido reciente para contexto del AI agent...');
    
    // Obtener posts recientes
    const { data: posts, error: postsError } = await supabase
      .from('instagram_posts')
      .select('id, caption, image_url, created_at, ai_generated')
      .eq('status', 'published')
      .order('created_at', { ascending: false })
      .limit(limit);

    if (postsError) {
      console.error('❌ Error obteniendo posts:', postsError);
    }

    // Obtener stories recientes
    const { data: stories, error: storiesError } = await supabase
      .from('instagram_stories')
      .select('id, image_url, created_at, ai_generated')
      .eq('status', 'published')
      .order('created_at', { ascending: false })
      .limit(limit);

    if (storiesError) {
      console.error('❌ Error obteniendo stories:', storiesError);
    }

    const recentContent = {
      posts: posts || [],
      stories: stories || [],
      total: (posts?.length || 0) + (stories?.length || 0)
    };

    console.log('✅ Contenido reciente obtenido:', {
      posts: recentContent.posts.length,
      stories: recentContent.stories.length,
      total: recentContent.total
    });

    return recentContent;
  } catch (error) {
    console.error('❌ Error obteniendo contenido reciente:', error);
    return { posts: [], stories: [], total: 0 };
  }
}

// Función para obtener contenido relevante basado en el contexto del usuario
async function getRelevantContentForUser(userData, limit = 3) {
  try {
    console.log('🎯 Obteniendo contenido relevante para el usuario...');
    
    if (!userData || !userData.user_profession) {
      console.log('⚠️ Sin datos de usuario suficientes, obteniendo contenido general');
      return await getRecentContentForAI(limit);
    }

    const userProfession = userData.user_profession.toLowerCase();
    const userSkills = userData.user_skills?.join(' ').toLowerCase() || '';
    const userLocation = userData.user_location?.toLowerCase() || '';
    
    console.log('🔍 Buscando contenido relevante para:', {
      profession: userProfession,
      skills: userSkills,
      location: userLocation
    });

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
      console.error('❌ Error en búsqueda de posts:', postsError);
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
      console.error('❌ Error obteniendo stories:', storiesError);
    }

    const relevantContent = {
      posts: finalPosts || [],
      stories: stories || [],
      total: (finalPosts?.length || 0) + (stories?.length || 0),
      personalized: relevantPosts?.length > 0
    };

    console.log('✅ Contenido relevante obtenido:', {
      posts: relevantContent.posts.length,
      stories: relevantContent.stories.length,
      personalized: relevantContent.personalized
    });

    return relevantContent;
  } catch (error) {
    console.error('❌ Error obteniendo contenido relevante:', error);
    return { posts: [], stories: [], total: 0, personalized: false };
  }
}

// Función para obtener estadísticas de posts con análisis de IA
async function getPostsAnalytics() {
  try {
    console.log('📊 Analizando estadísticas de posts...');
    
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
      console.error('❌ Error obteniendo posts:', postsError);
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
    console.error('❌ Error analizando posts:', error);
    return null;
  }
}

// Función para obtener estadísticas de DMs y conversaciones
async function getDMAnalytics() {
  try {
    console.log('💬 Analizando estadísticas de DMs...');
    
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
      console.error('❌ Error obteniendo conversaciones:', convError);
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
    console.error('❌ Error analizando DMs:', error);
    return null;
  }
}

// Función para generar sugerencias de mejora para un preview
async function generateImproveSuggestions(topic, style, targetAudience, imageUrl) {
  try {
    console.log('💡 Generando sugerencias de mejora...');
    
    const geminiClient = getGeminiClient();
    if (!geminiClient) {
      console.error('❌ Cliente Gemini no disponible');
      return [];
    }

    const model = geminiClient.getGenerativeModel({ model: "gemini-2.5-flash-lite" });
    
    const isReel = style === 'reel';
    const contentType = isReel ? 'Instagram Reel' : 'Instagram Post/Story';
    const mediaType = isReel ? 'VIDEO' : 'IMAGEN';
    const reelSpecific = isReel ? '\n\nESPECÍFICO PARA REEL:\n- Considera elementos de engagement y viralidad\n- Sugiere mejoras para retención de audiencia\n- Incluye aspectos de timing y ritmo\n- Enfócate en hashtags trending y calls-to-action dinámicos' : '';

    const suggestionsPrompt = `Analiza este contenido de ${contentType} y genera 5 sugerencias específicas de mejora:

TEMA: ${topic}
ESTILO: ${style}
AUDIENCIA: ${targetAudience}
${mediaType}: ${imageUrl}${reelSpecific}

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

    const result = await model.generateContent(suggestionsPrompt);
    const response = await result.response;
    const suggestionsText = response.text();

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
      console.log('✅ Sugerencias generadas:', suggestionsData.suggestions?.length || 0);
      return suggestionsData.suggestions || [];
    } catch (parseError) {
      console.error('❌ Error parseando sugerencias:', parseError);
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
    console.error('❌ Error generando sugerencias de mejora:', error);
    return [];
  }
}

// Función para generar múltiples opciones de caption
async function generateCaptionOptions(topic, style, targetAudience) {
  try {
    console.log('📝 Generando opciones de caption...');
    
    const geminiClient = getGeminiClient();
    if (!geminiClient) {
      console.error('❌ Cliente Gemini no disponible');
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

    const model = geminiClient.getGenerativeModel({ model: "gemini-2.5-flash-lite" });
    
    const isReel = style === 'reel';
    const contentType = isReel ? 'Instagram Reel' : 'Instagram Post/Story';
    const reelSpecific = isReel ? '\n\nESPECÍFICO PARA REEL:\n- Caption más corto y directo (máximo 100 caracteres)\n- Enfoque en engagement y viralidad\n- Incluir elementos de trending/hashtags populares\n- Call-to-action más dinámico y urgente' : '';

    const captionPrompt = `Crea 3 opciones diferentes de caption para ${contentType} sobre: "${topic}"

ESTILO: ${style}
AUDIENCIA: ${targetAudience}${reelSpecific}

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

    const result = await model.generateContent(captionPrompt);
    const response = await result.response;
    const captionText = response.text();

    console.log('📝 Respuesta de Gemini:', captionText);

    try {
      // Limpiar el texto de markdown si está presente
      let cleanText = captionText;
      if (cleanText.includes('```json')) {
        cleanText = cleanText.replace(/```json\s*/, '').replace(/\s*```$/, '');
      }
      if (cleanText.includes('```')) {
        cleanText = cleanText.replace(/```\s*/, '').replace(/\s*```$/, '');
      }
      
      const captionData = JSON.parse(cleanText);
      console.log('✅ Opciones de caption generadas:', captionData.captions?.length || 0);
      return captionData;
    } catch (parseError) {
      console.error('❌ Error parseando opciones de caption:', parseError);
      console.error('📝 Texto recibido:', captionText);
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
    console.error('❌ Error generando opciones de caption:', error);
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

// Función para generar análisis de IA sobre las estadísticas
async function generateAIAnalytics(postsData, dmData) {
  try {
    console.log('🤖 Generando análisis de IA...');
    
    const geminiClient = getGeminiClient();
    if (!geminiClient) {
      console.error('❌ Cliente Gemini no disponible');
      return null;
    }

    const model = geminiClient.getGenerativeModel({ model: "gemini-2.5-flash-lite" });
    
    const analysisPrompt = `Analiza estas estadísticas de Magneto Empleos y genera insights inteligentes:

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

1. **TENDENCIAS DEL MERCADO LABORAL:**
   - Sectores con mayor demanda
   - Posiciones más buscadas
   - Patrones de interés

2. **COMPORTAMIENTO DE USUARIOS:**
   - Nivel de engagement
   - Patrones de interacción
   - Completitud de perfiles

3. **OPORTUNIDADES DE MEJORA:**
   - Áreas de crecimiento
   - Contenido que funciona mejor
   - Estrategias recomendadas

4. **INSIGHTS ESPECÍFICOS:**
   - Datos curiosos o sorprendentes
   - Correlaciones interesantes
   - Predicciones basadas en datos

5. **RECOMENDACIONES ACCIONABLES:**
   - Qué contenido crear
   - Cómo mejorar engagement
   - Estrategias de crecimiento

Responde en formato JSON estructurado y sé específico con números y datos concretos.`;

    const result = await model.generateContent(analysisPrompt);
    const response = await result.response;
    const analysisText = response.text();

    // Intentar parsear como JSON, si falla devolver como texto
    try {
      return JSON.parse(analysisText);
    } catch (parseError) {
      return {
        analysis: analysisText,
        format: 'text'
      };
    }
  } catch (error) {
    console.error('❌ Error generando análisis de IA:', error);
    return null;
  }
}

// Función para obtener información completa del usuario de Instagram
async function getInstagramUserInfo(userId) {
  if (!userId) return null;
  
  try {
    console.log(`🔍 Obteniendo información básica de Instagram para usuario: ${userId}`);
    
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
      console.log('✅ Información básica del usuario obtenida:', basicData);
      userData = { ...basicData };
    } else {
      console.log('⚠️ No se pudo obtener información básica de Instagram');
    }
    
    return userData;
  } catch (error) {
    console.error('❌ Error obteniendo información de Instagram:', error);
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
      // Obtener mensajes recientes del usuario
      const { data: messages, error } = await supabase
        .from('mensajes')
        .select('content, created_at')
        .eq('conversaciones.user_id', userId)
        .eq('message_type', 'incoming')
        .order('created_at', { ascending: false })
        .limit(10);
      
      if (error || !messages) return null;
      recentMessages = messages;
    }
    
    // Combinar mensajes recientes para análisis
    const combinedText = recentMessages.map(msg => msg.content).join(' ');
    
    if (!combinedText.trim()) return null;
    
    // Usar Gemini para detectar emoción
    const geminiClient = getGeminiClient();
    if (!geminiClient) return null;
    
    const emotionPrompt = `Analiza el siguiente texto y determina la emoción predominante del usuario. Responde SOLO con una de estas emociones: happy, sad, excited, frustrated, anxious, calm, angry, confused, hopeful, disappointed, grateful, worried, curious, bored, enthusiastic, stressed, relaxed, surprised, disappointed, optimistic, pessimistic, neutral.

Texto del usuario: "${combinedText}"

Emoción detectada:`;

    const model = geminiClient.getGenerativeModel({ model: "gemini-2.5-flash-lite" });
    const result = await model.generateContent(emotionPrompt);
    const response = await result.response;
    const detectedEmotion = response.text().trim().toLowerCase();
    
    // Validar que la emoción esté en la lista permitida
    const validEmotions = ['happy', 'sad', 'excited', 'frustrated', 'anxious', 'calm', 'angry', 'confused', 'hopeful', 'disappointed', 'grateful', 'worried', 'curious', 'bored', 'enthusiastic', 'stressed', 'relaxed', 'surprised', 'optimistic', 'pessimistic', 'neutral'];
    
    if (validEmotions.includes(detectedEmotion)) {
      // Guardar emoción en historial
      await supabase
        .from('user_emotions')
        .insert([{
          user_id: userId,
          emotion: detectedEmotion,
          confidence: 0.8, // Confianza estimada
          detected_from: 'message_content',
          context: `Analizado de ${recentMessages.length} mensajes recientes`
        }]);
      
      return detectedEmotion;
    }
    
    return 'neutral';
  } catch (error) {
    console.error('Error detectando emoción:', error);
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
    
    console.log('Perfil del usuario actualizado:', data);
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

// Definir las funciones disponibles para el AI Agent
const AI_FUNCTIONS = [
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

// Función para procesar function calls del AI
async function processFunctionCall(functionName, args, userId) {
  try {
    console.log(`🔧 Procesando function call: ${functionName}`, args);
    
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
          console.error('❌ Error actualizando datos del usuario:', error);
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

        console.log(`✅ Datos actualizados para usuario ${userId}:`, Object.keys(updateData));
        return { success: true, updatedFields: Object.keys(updateData) };
      }
    }
    
    return { success: false, error: 'Función no reconocida' };
  } catch (error) {
    console.error('❌ Error procesando function call:', error);
    return { success: false, error: error.message };
  }
}

function buildMessages(userText, context, mediaInfo = null, messageHistory = [], userData = null) {
  const messages = [
    { role: 'system', content: SYSTEM_PROMPT }
  ];

  // Agregar contexto del usuario si está disponible
  if (userData) {
    const userContext = `INFORMACIÓN DEL USUARIO:
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
    const userContext = `INFORMACIÓN DEL USUARIO:
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
    console.error('❌ Error obteniendo contenido para contexto:', error);
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
    console.log('Intentando guardar conversación:', conversationData);
    console.log('Supabase URL:', process.env.SUPABASE_URL);
    console.log('Usando service_role key:', !!process.env.SUPABASE_SERVICE_ROLE_KEY);
    
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
    
    console.log('Conversación guardada exitosamente:', data);
    
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
async function getInstagramMediaInfo(mediaId) {
  try {
    const response = await fetch(`https://graph.instagram.com/v21.0/${mediaId}?fields=id,media_type,media_url,caption,timestamp,permalink&access_token=${process.env.INSTAGRAM_ACCESS_TOKEN}`);
    
    if (!response.ok) {
      console.error('Error obteniendo info de media:', await response.text());
      return null;
    }
    
    const mediaInfo = await response.json();
    console.log('Información de media obtenida:', mediaInfo);
    return mediaInfo;
  } catch (error) {
    console.error('Error obteniendo info de media:', error);
    return null;
  }
}

// Función para obtener información de story
async function getStoryInfo(storyId) {
  try {
    const response = await fetch(`https://graph.instagram.com/v21.0/${storyId}?fields=id,media_type,media_url,caption,timestamp&access_token=${process.env.INSTAGRAM_ACCESS_TOKEN}`);
    
    if (!response.ok) {
      console.error('Error obteniendo info de story:', await response.text());
      return null;
    }
    
    const storyInfo = await response.json();
    console.log('Información de story obtenida:', storyInfo);
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
  const conversationId = generateDMConversationId(senderId, recipientId);
  
  // Determinar cuál es el usuario externo (no el bot)
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
    console.log('Conversación DM existente encontrada:', existingConversation.id);
    
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

  // Crear nueva conversación
  const conversationData = {
    platform: 'instagram',
    conversation_type: 'dm',
    external_conversation_id: conversationId,
    user_id: externalUserId, // Siempre guardamos el ID del usuario externo
    username: externalUsername,
    status: 'active'
  };

  return await saveConversationToSupabase(conversationData);
}

// Función para subir imagen a Supabase Storage
async function uploadImageToStorage(imageBuffer, fileName, contentType) {
  try {
    console.log('🚀 INICIO: uploadImageToStorage');
    console.log('📝 Nombre del archivo:', fileName);
    console.log('📦 Tamaño del buffer:', imageBuffer.length, 'bytes');
    console.log('📄 Tipo de contenido:', contentType);
    
    if (!supabase) {
      console.error('❌ Cliente Supabase no disponible');
      return null;
    }
    console.log('✅ Cliente Supabase disponible');

    const bucketName = 'magneto-bucket';
    console.log('🪣 Nombre del bucket:', bucketName);

    console.log('📤 Subiendo archivo a Supabase Storage...');
    const { data, error } = await supabase.storage
      .from(bucketName)
      .upload(fileName, imageBuffer, {
        contentType: contentType,
        upsert: true
      });

    if (error) {
      console.error('❌ Error subiendo imagen:', error);
      console.log('🔍 Detalles del error:', JSON.stringify(error, null, 2));
      return null;
    }

    console.log('✅ Archivo subido exitosamente:', data);

    // Obtener URL pública
    console.log('🔗 Generando URL pública...');
    const { data: { publicUrl } } = supabase.storage
      .from(bucketName)
      .getPublicUrl(fileName);

    console.log('🔗 URL pública generada:', publicUrl);

    if (!publicUrl) {
      console.error('❌ No se pudo generar URL pública');
      return null;
    }

    console.log('✅ URL pública obtenida:', publicUrl);
    console.log('🎉 ÉXITO: uploadImageToStorage completado');
    return publicUrl;
  } catch (error) {
    console.error('❌ Error en uploadImageToStorage:', error.message);
    console.error('🔍 Stack trace:', error.stack);
    console.error('🔍 Error completo:', error);
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
    console.log(`🎬 Procesando video en cola (${activeVideoGenerations}/${MAX_CONCURRENT_VIDEOS})`);
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
    console.log(`🔄 Procesando video en background: ${jobId}`);
    
    const maxAttempts = 60; // 10 minutos máximo
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
      console.log(`⏳ Video ${jobId} - Estado: ${videoData.status}, Progreso: ${videoData.progress}%`);
      
      // Actualizar estado en la cola
      const queueItem = videoProcessingQueue.get(jobId);
      if (queueItem) {
        queueItem.status = videoData.status;
        queueItem.progress = videoData.progress;
      }
      
      if (videoData.status === 'completed' || videoData.status === 'succeeded') {
        console.log(`✅ Video ${jobId} completado! Descargando...`);
        
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
        console.log(`✅ Video ${jobId} subido exitosamente: ${videoUrl}`);
        
        // Resolver la promesa
        if (queueItem) {
          queueItem.resolve(videoUrl);
          videoProcessingQueue.delete(jobId);
        }
        
        return videoUrl;
        
      } else if (videoData.status === 'failed' || videoData.status === 'error') {
        const error = `Video falló: ${videoData.error?.message || 'Error desconocido'}`;
        console.error(`❌ Video ${jobId} falló:`, error);
        
        if (queueItem) {
          queueItem.reject(new Error(error));
          videoProcessingQueue.delete(jobId);
        }
        
        throw new Error(error);
      }
      
      // Esperar 10 segundos antes del siguiente check
      await new Promise(resolve => setTimeout(resolve, 10000));
    }
    
    // Timeout
    const timeoutError = `Timeout procesando video ${jobId} después de ${maxAttempts} intentos`;
    console.error(`⏰ ${timeoutError}`);
    
    const queueItem = videoProcessingQueue.get(jobId);
    if (queueItem) {
      queueItem.reject(new Error(timeoutError));
      videoProcessingQueue.delete(jobId);
    }
    
    throw new Error(timeoutError);
    
  } catch (error) {
    console.error(`❌ Error procesando video ${jobId} en background:`, error);
    
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
    console.log('🎬 INICIO: generateVideoInternal (Sora)');
    console.log('📝 Prompt recibido:', prompt);
    console.log('🗣️ Acento:', accent);
    console.log('🎨 Estilo:', style);
    console.log('⏱️ Duración:', duration, 'segundos');

    if (!process.env.OPENAI_API_KEY) {
      console.error('❌ OPENAI_API_KEY no está configurado');
      return null;
    }

    const axios = require('axios');
    const apiKey = process.env.OPENAI_API_KEY;

    const maxDur = Math.min(Math.max(Number(duration) || 6, 1), 8);
    const videoPrompt = `Un video corto para Instagram Reels en español.\n\nTema: "${prompt}"\nEstilo visual: ${style}\nTono: profesional y dinámico.\nAudio: narración clara en español (acento ${accent}) y música de fondo sutil.\nFormato: vertical 9:16. Duración máxima: ${maxDur} segundos.`;

    console.log('📤 Solicitando generación a Sora via REST API...');
    console.log('📝 Prompt final enviado a Sora:', videoPrompt);
    
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
      console.error('❌ No se obtuvo jobId:', JSON.stringify(createResponse.data, null, 2));
      return null;
    }

    // Polling hasta que el video esté listo
    let status = createResponse.data?.status || 'processing';
    console.log('⏳ Job iniciado:', jobId, 'Estado:', status);
    
    let details = createResponse.data;
    let attempts = 0;
    const maxAttempts = 60; // 8 minutos máximo
    
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
      console.log(`⏳ Estado actual (intento ${attempts}):`, status);
      
      if (status === 'failed' || status === 'canceled') {
        console.error('❌ Job falló/cancelado:', JSON.stringify(details, null, 2));
        return null;
      }
    }

    if (attempts >= maxAttempts) {
      console.error('❌ Timeout esperando video después de', attempts, 'intentos');
      console.error('❌ Estado final:', status);
      console.error('❌ Detalles:', details);
      return null;
    }

    // Descargar el video desde el endpoint de contenido de OpenAI
    // https://api.openai.com/v1/videos/{video_id}/content
    const contentUrl = `https://api.openai.com/v1/videos/${jobId}/content`;
    console.log('📥 Descargando video desde content endpoint:', contentUrl);
    const resp = await axios.get(contentUrl, { 
      responseType: 'arraybuffer',
      headers: {
        Authorization: `Bearer ${apiKey}`
      }
    });
    let videoBuffer = Buffer.from(resp.data);
    console.log('📦 Video descargado, tamaño:', videoBuffer.length, 'bytes');
    
    console.log('📦 Video descargado a memoria, tamaño:', videoBuffer.length, 'bytes');
    
    if (!videoBuffer || videoBuffer.length === 0) {
      console.error('❌ Error: videoBuffer está vacío');
      return null;
    }
    
    // Generar nombre único para el archivo
    const timestamp = Date.now();
    const fileName = `ai-generated-reel-${timestamp}.mp4`;
    console.log('📝 Nombre de archivo:', fileName);
      
    // Subir a Supabase Storage
    console.log('☁️ Subiendo video a Supabase Storage...');
    const supabaseVideoUrl = await uploadImageToStorage(videoBuffer, fileName, 'video/mp4');
    
    if (!supabaseVideoUrl) {
      console.error('❌ Error subiendo video a Supabase Storage');
      return null;
    }
    
    console.log('✅ Video guardado en Supabase Storage:', supabaseVideoUrl);
    console.log('🎉 ÉXITO: generateVideoInternal completado');
    return supabaseVideoUrl;
  } catch (error) {
    console.error('❌ Error general en generateVideoInternal:', error.message);
    console.error('🔍 Stack trace:', error.stack);
    console.error('🔍 Error completo:', error);
    if (error.response && error.response.data) {
      console.error('🔍 Respuesta de error de la API:', JSON.stringify(error.response.data, null, 2));
    }
    return null;
  }
}

// Función principal que usa la cola para controlar concurrencia
async function generateVideo(prompt, accent = 'neutral', style = 'realista', duration = 8) {
  return new Promise((resolve, reject) => {
    // Crear job de video inmediatamente
    const createVideoJob = async () => {
      try {
        console.log('🎬 Creando job de video...');
        
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
        
        console.log(`✅ Job de video creado: ${jobId}`);
        
        // Agregar a la cola de procesamiento en background
        videoProcessingQueue.set(jobId, {
          status: 'queued',
          progress: 0,
          resolve,
          reject
        });
        
        // Iniciar procesamiento en background (no bloquea)
        processVideoInBackground(jobId).catch(error => {
          console.error(`❌ Error en background processing para ${jobId}:`, error);
        });
        
      } catch (error) {
        console.error('❌ Error creando job de video:', error);
        reject(error);
      }
    };
    
    // Ejecutar creación del job
    createVideoJob();
  });
}

// Función para generar imagen con Gemini (mantener como fallback)
async function generateImageWithGemini(prompt, referenceImage = null) {
  try {
    console.log('🚀 INICIO: generateImageWithGemini');
    console.log('📝 Prompt recibido:', prompt);
    console.log('🖼️ Imagen de referencia:', referenceImage ? 'Presente' : 'No presente');
    
    const geminiClient = getGeminiClient();
    if (!geminiClient) {
      console.error('❌ Cliente Gemini no disponible');
      return null;
    }
    console.log('✅ Cliente Gemini obtenido correctamente');

    console.log('🎨 Generando imagen con Gemini directamente...');
    
    // Usar Gemini directamente para generación de imágenes
    const model = geminiClient.getGenerativeModel({ model: "gemini-2.5-flash-image-preview" });
    console.log('✅ Modelo Gemini obtenido:', "gemini-2.5-flash-image-preview");
    
    let imagePrompt = `Create an illustrative, cartoon-style Instagram post image (1080x1080px) about: "${prompt}"

DESIGN REQUIREMENTS:
- High quality, professional illustration
- Instagram post dimensions (1080x1080px - square)
- Cartoon/caricature style with friendly characters
- Clean, modern layout with balanced composition
- Brand colors: blue (#4A90E2), white (#FFFFFF), orange (#FF6B6B)
- Illustrative and engaging visual style

TEXT TO INCLUDE IN IMAGE:
- Main title: Based on the topic "${prompt}" - create an appropriate title (in white, large and visible)
- Subtitle: "${prompt}" (in blue, medium size)
- Call to action: Create an appropriate call to action based on the content (in orange, highlighted)
- Minimal but effective text
- Professional, readable fonts

BRANDING REQUIREMENTS (MANDATORY):
- Watermark: "MAGNETO EMPLEOS" (in small, elegant font, bottom right corner)
- Instagram handle: "@magneto_empleos" (in small font, bottom left corner)
- Both branding elements should be subtle but visible
- Use brand colors for branding elements

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
- Well-distributed brand colors
- Visual elements that support the message
- Style that attracts tech professionals
- Complete image ready to publish
- Character-driven storytelling

${referenceImage ? 'Use the reference image as inspiration for style and composition. Analyze the reference image and apply the requested changes while maintaining the overall structure and visual elements.' : ''}

Generate a complete illustrative image ready for social media with proper branding.`;

    console.log('📤 Enviando prompt a Gemini...');
    console.log('📝 Prompt completo:', imagePrompt);
    
    // Construir el contenido con imagen de referencia si está disponible
    let content;
    if (referenceImage) {
      console.log('🖼️ Incluyendo imagen de referencia en el contenido');
      // Descargar la imagen de referencia
      const imageResponse = await fetch(referenceImage);
      const imageBuffer = await imageResponse.arrayBuffer();
      const imageBase64 = Buffer.from(imageBuffer).toString('base64');
      
      content = [
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
      content = imagePrompt;
    }
    
    const result = await model.generateContent(content);
    console.log('📥 Respuesta recibida de Gemini');
    
    const response = await result.response;
    console.log('📊 Response object:', response);
    
    // Gemini devuelve la imagen como datos binarios en base64
    const candidates = response.candidates;
    console.log('🔍 Candidates encontrados:', candidates?.length || 0);
    
    if (!candidates || candidates.length === 0) {
      console.error('❌ No se encontraron candidates en la respuesta');
      return null;
    }
    
    const candidate = candidates[0];
    console.log('🔍 Candidate:', candidate);
    
    const candidateContent = candidate.content;
    console.log('🔍 Content:', candidateContent);
    
    if (!candidateContent || !candidateContent.parts || candidateContent.parts.length === 0) {
      console.error('❌ No se encontraron parts en el content');
      return null;
    }
    
    // Buscar la imagen en todos los parts
    let imagePart = null;
    for (let i = 0; i < candidateContent.parts.length; i++) {
      const part = candidateContent.parts[i];
      console.log(`🔍 Part ${i}:`, part);
      
      if (part.inlineData) {
        imagePart = part;
        console.log(`✅ Imagen encontrada en part ${i}`);
        break;
      }
    }
    
    if (!imagePart) {
      console.error('❌ No se encontró inlineData en ningún part');
      console.log('🔍 Parts completos:', JSON.stringify(candidateContent.parts, null, 2));
      return null;
    }
    
    // Verificar si es una imagen (datos binarios)
    console.log('✅ Imagen encontrada como inlineData');
    console.log('📄 MIME type:', imagePart.inlineData.mimeType);
    console.log('📦 Tamaño de datos base64:', imagePart.inlineData.data.length, 'caracteres');
    
    // Convertir base64 a buffer
    const imageBuffer = Buffer.from(imagePart.inlineData.data, 'base64');
    console.log('📦 Tamaño de imagen convertida:', imageBuffer.length, 'bytes');
    
    // La imagen ya viene completa con texto incluido por la IA
    console.log('✅ Imagen generada directamente por la IA con texto incluido');
    
    // Generar nombre único para el archivo
    const timestamp = Date.now();
    const fileName = `ai-generated-${timestamp}.png`;
    console.log('📝 Nombre de archivo:', fileName);
      
      // Subir a Supabase Storage
      console.log('☁️ Subiendo imagen a Supabase Storage...');
      const supabaseImageUrl = await uploadImageToStorage(imageBuffer, fileName, 'image/png');
      
      if (!supabaseImageUrl) {
        console.error('❌ Error subiendo imagen a Supabase Storage');
        return null;
      }
      
      console.log('✅ Imagen guardada en Supabase Storage:', supabaseImageUrl);
      console.log('🎉 ÉXITO: generateImageWithGemini completado');
      return supabaseImageUrl;
  } catch (error) {
    console.error('❌ Error general en generateImageWithGemini:', error.message);
    console.error('🔍 Stack trace:', error.stack);
    console.error('🔍 Error completo:', error);
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

    console.log('🤖 Generando contenido con Gemini directamente...');
    
    // Usar Gemini directamente para generación de contenido con el modelo más reciente
    const model = geminiClient.getGenerativeModel({ model: "gemini-2.5-flash-lite" });
    
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const generatedContent = response.text();
    
    if (!generatedContent) {
      console.error('No se pudo generar contenido');
      return null;
    }

    console.log('✅ Contenido generado exitosamente');
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
      console.error('❌ INSTAGRAM_BUSINESS_ACCOUNT_ID no está configurado');
      return { success: false, error: 'Instagram Business Account ID no configurado' };
    }

    if (!process.env.INSTAGRAM_ACCESS_TOKEN) {
      console.error('❌ INSTAGRAM_ACCESS_TOKEN no está configurado');
      return { success: false, error: 'Instagram Access Token no configurado' };
    }

    console.log('📱 Publicando story en Instagram...');
    console.log('🖼️ Imagen URL:', imageUrl);

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
      console.error('❌ Error creando media container para story:', errorText);
      return { success: false, error: `Error creando media: ${errorText}` };
    }

    const mediaData = await createMediaResponse.json();
    console.log('✅ Media container para story creado:', mediaData.id);

    // Esperar un momento para que Instagram procese el media
    console.log('⏳ Esperando que Instagram procese el media...');
    await new Promise(resolve => setTimeout(resolve, 3000)); // 3 segundos de espera

    // Paso 2: Publicar la story
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
      console.error('❌ Error publicando story:', errorText);
      return { success: false, error: `Error publicando story: ${errorText}` };
    }

    const publishData = await publishResponse.json();
    console.log('✅ Story publicada exitosamente:', publishData.id);

    return {
      success: true,
      media_id: mediaData.id,
      story_id: publishData.id,
      data: publishData
    };

  } catch (error) {
    console.error('❌ Error general publicando story:', error);
    return { success: false, error: error.message };
  }
}

// Función para publicar post en Instagram usando Graph API
async function publishInstagramPost(imageUrl, caption) {
  try {
    if (!process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID) {
      console.error('❌ INSTAGRAM_BUSINESS_ACCOUNT_ID no está configurado');
      return { success: false, error: 'Instagram Business Account ID no configurado' };
    }

    if (!process.env.INSTAGRAM_ACCESS_TOKEN) {
      console.error('❌ INSTAGRAM_ACCESS_TOKEN no está configurado');
      return { success: false, error: 'Instagram Access Token no configurado' };
    }

    console.log('📱 Publicando post en Instagram...');
    console.log('🖼️ Imagen URL:', imageUrl);
    console.log('🖼️ Tipo de imageUrl:', typeof imageUrl);
    console.log('📝 Caption:', caption ? caption.substring(0, 100) + '...' : 'Sin caption');
    console.log('📝 Tipo de caption:', typeof caption);

    // Paso 1: Crear media container
    const createMediaResponse = await fetch(`https://graph.instagram.com/v21.0/${process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID}/media`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        image_url: imageUrl,
        caption: caption
      })
    });

    if (!createMediaResponse.ok) {
      const errorText = await createMediaResponse.text();
      console.error('❌ Error creando media container:', errorText);
      return { success: false, error: `Error creando media: ${errorText}` };
    }

    const mediaData = await createMediaResponse.json();
    console.log('✅ Media container creado:', mediaData.id);

    // Esperar un momento para que Instagram procese el media
    console.log('⏳ Esperando que Instagram procese el media...');
    await new Promise(resolve => setTimeout(resolve, 3000)); // 3 segundos de espera

    // Paso 2: Publicar el media
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
      console.error('❌ Error publicando media:', errorText);
      return { success: false, error: `Error publicando: ${errorText}` };
    }

    const publishData = await publishResponse.json();
    console.log('✅ Post publicado exitosamente:', publishData.id);

    return {
      success: true,
      media_id: mediaData.id,
      post_id: publishData.id,
      message: 'Post publicado exitosamente en Instagram'
    };

  } catch (error) {
    console.error('❌ Error en publishInstagramPost:', error);
    return { success: false, error: error.message };
  }
}

// Función para publicar Reel (video) en Instagram usando Graph API
async function publishInstagramReel(videoUrl, caption) {
  try {
    if (!process.env.INSTAGRAM_BUSINESS_ACCOUNT_ID) {
      console.error('❌ INSTAGRAM_BUSINESS_ACCOUNT_ID no está configurado');
      return { success: false, error: 'Instagram Business Account ID no configurado' };
    }
    if (!process.env.INSTAGRAM_ACCESS_TOKEN) {
      console.error('❌ INSTAGRAM_ACCESS_TOKEN no está configurado');
      return { success: false, error: 'Instagram Access Token no configurado' };
    }

    console.log('🎞️ Publicando Reel (direct video_url)...');
    console.log('🎞️ Video URL:', videoUrl);
    console.log('📝 Caption:', caption ? caption.substring(0, 100) + '...' : 'Sin caption');

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
        caption: caption || undefined
      })
    });

    if (!createContainerResp.ok) {
      const errorText = await createContainerResp.text();
      console.error('❌ Error creando contenedor (resumable):', errorText);
      return { success: false, error: `Error creando contenedor: ${errorText}` };
    }

    const container = await createContainerResp.json();
    const containerId = container.id;
    console.log('✅ Contenedor creado:', containerId);

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
        console.warn('⚠️ Error consultando status del contenedor:', err);
        await new Promise(r => setTimeout(r, 3000));
        continue;
      }
      const statusJson = await statusResp.json();
      status = statusJson.status_code || 'IN_PROGRESS';
      console.log(`⏳ Estado contenedor (${attempts}/${maxAttempts}):`, status);
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
      console.error('❌ Error publicando Reel:', errorText);
      return { success: false, error: `Error publicando Reel: ${errorText}` };
    }

    const publishData = await publishResp.json();
    console.log('✅ Reel publicado, media id:', publishData.id);

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
      console.warn('⚠️ No se pudo obtener permalink del Reel:', e.message);
    }

    return {
      success: true,
      media_id: containerId,
      post_id: publishData.id,
      permalink
    };
  } catch (error) {
    console.error('❌ Error general publicando Reel:', error);
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

    return {
      conversation,
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

    const model = geminiClient.getGenerativeModel({ model: "gemini-2.5-flash-lite" });
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const extractedData = response.text().trim();
    
    if (extractedData) {
      try {
        const parsed = JSON.parse(extractedData);
        console.log('🔍 Datos detectados automáticamente:', parsed);
        return parsed;
      } catch (error) {
        console.log('⚠️ Error parseando datos extraídos:', extractedData);
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

    const model = geminiClient.getGenerativeModel({ model: "gemini-2.5-flash-lite" });
    const result = await model.generateContent(extractionPrompt);
    const response = await result.response;
    const extractedData = response.text().trim();
    
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

    // Log de actualización
    console.log(`✅ Datos actualizados para usuario ${userId}:`, {
      dataType,
      dataValue,
      updatedFields: Object.keys(updateData)
    });

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

        return {
          ...post,
          stats: {
            total_comments: totalComments || 0,
            user_comments: userComments || 0,
            ai_comments: aiComments || 0,
            likes: 0 // Instagram no proporciona likes via API para posts normales
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
  getStoryInfo,
  getStoryInfoFromReply,
  sendInstagramDMReply,
  sendInstagramCommentReply,
  
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
  fuseOptions
};

// Función unificada para generar preview completo (imagen + captions + sugerencias)
async function generateCompletePreview(topic, style, targetAudience, type = 'post', referenceImage = null) {
  try {
    console.log(`🎯 Generando preview completo para ${type}...`);
    
    // Generar imagen según el tipo
    let mediaUrl;
    if (type === 'reel') {
      throw new Error('Para reels usar generateCompleteReelPreview');
    } else {
      mediaUrl = await generateImageWithGemini(topic, referenceImage);
    }
    
    if (!mediaUrl) {
      throw new Error('Error generando media');
    }
    
    // Generar captions y sugerencias en paralelo
    const [captionOptions, improveSuggestions] = await Promise.all([
      generateCaptionOptions(topic, style, targetAudience),
      generateImproveSuggestions(topic, style, targetAudience, mediaUrl)
    ]);
    
    return {
      mediaUrl,
      captionOptions,
      improveSuggestions
    };
  } catch (error) {
    console.error('❌ Error generando preview completo:', error);
    return null;
  }
}

// Función unificada para generar preview completo de reel
async function generateCompleteReelPreview(prompt, accent, style, duration, targetAudience) {
  try {
    console.log('🎬 Generando preview completo de reel...');
    
    // Generar video con retry
    let videoUrl = null;
    let attempts = 0;
    const maxVideoAttempts = 2;
    
    while (!videoUrl && attempts < maxVideoAttempts) {
      attempts++;
      console.log(`🎬 Intento ${attempts}/${maxVideoAttempts} generando video...`);
      
      videoUrl = await generateVideo(prompt, accent, style, duration);
      
      if (!videoUrl && attempts < maxVideoAttempts) {
        console.log(`⏳ Esperando 30 segundos antes del siguiente intento...`);
        await new Promise(resolve => setTimeout(resolve, 30000));
      }
    }
    
    if (!videoUrl) {
      console.error('❌ No se pudo generar video después de', maxVideoAttempts, 'intentos');
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
    console.error('❌ Error generando preview completo de reel:', error);
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
    console.log('🤖 Generando respuesta con function calling...');
    
    const geminiClient = getGeminiClient();
    if (!geminiClient) {
      console.error('❌ Cliente Gemini no disponible');
      return { reply: 'Lo siento, no puedo procesar tu mensaje en este momento.', functionCalls: [] };
    }

    // Construir mensajes
    const messages = await buildMessagesWithContent(userText, context, mediaInfo, messageHistory, userData);
    
    // Configurar el modelo con function calling
    const model = geminiClient.getGenerativeModel({ 
      model: "gemini-2.5-flash-lite",
      tools: AI_FUNCTIONS
    });

    // Generar contenido
    const result = await model.generateContent(convertMessagesForGemini(messages));
    const response = await result.response;
    
    // Verificar si hay function calls
    const functionCalls = response.functionCalls();
    let reply = response.text();
    
    // Procesar function calls si existen
    if (functionCalls && functionCalls.length > 0) {
      console.log(`🔧 ${functionCalls.length} function calls detectados`);
      
      for (const functionCall of functionCalls) {
        const functionName = functionCall.name;
        const args = functionCall.args;
        
        console.log(`🔧 Ejecutando función: ${functionName}`, args);
        
        if (userId) {
          const result = await processFunctionCall(functionName, args, userId);
          console.log(`✅ Resultado de ${functionName}:`, result);
        } else {
          console.warn('⚠️ No se proporcionó userId para function call');
        }
      }
    }

    return { reply, functionCalls: functionCalls || [] };
  } catch (error) {
    console.error('❌ Error generando respuesta con function calling:', error);
    return { reply: 'Lo siento, hubo un error procesando tu mensaje.', functionCalls: [] };
  }
}

// Agregar las nuevas funciones al module.exports
module.exports.generateCompletePreview = generateCompletePreview;
module.exports.generateCompleteReelPreview = generateCompleteReelPreview;
module.exports.generateResponseWithFunctionCalling = generateResponseWithFunctionCalling;
module.exports.AI_FUNCTIONS = AI_FUNCTIONS;
module.exports.processFunctionCall = processFunctionCall;
module.exports.videoProcessingQueue = videoProcessingQueue;
