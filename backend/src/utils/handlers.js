const {
  supabase,
  getGeminiClient,
  convertMessagesForGemini,
  getInstagramUserInfo,
  getInstagramUsername,
  getInstagramMediaInfo,
  getStoryInfo,
  getStoryInfoFromReply,
  sendInstagramDMReply,
  sendInstagramCommentReply,
  replyAndMaybeLike,
  detectUserEmotion,
  updateUserProfileInfo,
  getUserMessageHistory,
  buildMessages,
  buildMessagesWithContent,
  generateResponseWithFunctionCalling,
  saveConversationToSupabase,
  saveMessageToSupabase,
  isMessageAlreadyProcessed,
  generateDMConversationId,
  getOrCreateDMConversation,
  splitLongMessage,
  convertToInstagramFormat,
  getUserMissingData,
  getNextDataCollectionQuestion,
  extractUserDataFromMessage,
  detectAndExtractUserData,
  updateUserData,
  isCommentAlreadyProcessed,
  getOrCreateInstagramPost,
  saveInstagramComment,
  SYSTEM_PROMPT
} = require('./functions');

// Handler para comentarios de Instagram
async function handleInstagramComment(commentData) {
  try {
    console.log('Procesando comentario de Instagram:', commentData);
    
    // Verificar si es un comentario del bot mismo (no responder a nosotros mismos)
    if (commentData.from?.id === '17841477544945260' || commentData.from?.username === 'magneto_proyecto_ing') {
      console.log('Ignorando comentario del bot mismo');
      return;
    }
    
    // Verificar si ya procesamos este comentario
    if (await isCommentAlreadyProcessed(commentData.id)) {
      console.log('Comentario ya procesado, saltando...');
      return;
    }

    // Obtener información del media
    const mediaInfo = await getInstagramMediaInfo(commentData.media.id);
    
    // Obtener o crear el post
    const post = await getOrCreateInstagramPost(mediaInfo);
    
    // Obtener username del usuario
    let username = commentData.from.username;
    if (!username) {
      username = await getInstagramUsername(commentData.from.id);
    }

    // Guardar comentario
    const comment = await saveInstagramComment({
      post_id: post.id,
      instagram_comment_id: commentData.id,
      user_id: commentData.from.id,
      username: username,
      comment_text: commentData.text,
      is_ai_response: false
    });

      // Detectar emoción del usuario automáticamente
      console.log('😊 Detectando emoción del usuario en comentario...');
      try {
        const detectedEmotion = await detectUserEmotion(commentData.from.id);
        console.log(`🎭 Emoción detectada para comentario: ${detectedEmotion}`);
        
        if (detectedEmotion) {
          // Buscar conversación del usuario para actualizar emoción
          const { data: conversation, error: conversationError } = await supabase
            .from('conversaciones')
            .select('id')
            .eq('user_id', commentData.from.id)
            .eq('platform', 'instagram')
            .eq('conversation_type', 'dm')
            .single();
          
          if (conversationError) {
            console.error('❌ Error buscando conversación:', conversationError);
          } else if (conversation) {
            console.log(`📝 Actualizando emoción en conversación ${conversation.id} a: ${detectedEmotion}`);
            
            const { error: emotionError } = await supabase
              .from('conversaciones')
              .update({ 
                user_current_emotion: detectedEmotion,
                updated_at: new Date().toISOString()
              })
              .eq('id', conversation.id);
            
            if (emotionError) {
              console.error('❌ Error actualizando emoción:', emotionError);
            } else {
              console.log('✅ Emoción actualizada exitosamente:', detectedEmotion);
            }
          } else {
            console.log('⚠️ No se encontró conversación para actualizar emoción');
          }
        } else {
          console.log('⚠️ No se pudo detectar emoción del usuario');
        }
      } catch (emotionError) {
        console.error('❌ Error en detección de emoción:', emotionError);
      }

    if (comment) {
      // Obtener historial de mensajes para contexto
      const messageHistory = await getUserMessageHistory(commentData.from.id, 5);
      
      // Obtener datos del usuario para personalización
      const userData = await getUserMissingData(commentData.from.id);
      
      // Construir mensajes para la IA
      const messages = buildMessages(
        commentData.text,
        { type: 'comment', username: username },
        mediaInfo,
        messageHistory,
        userData?.conversation
      );

      // Generar respuesta con IA
      const geminiClient = getGeminiClient();
      if (geminiClient && geminiClient.models && typeof geminiClient.models.generateContent === 'function') {
        try {
          const prompt = convertMessagesForGemini(messages);

          // Preparar contenido con posible imagen del post como contexto visual
          let contents = prompt;
          
          // Si hay imagen, preparar para incluirla (puede requerir ajuste según la nueva API)
          try {
            if (mediaInfo?.media_url) {
              // Por ahora solo texto, la nueva API puede requerir formato diferente para imágenes
              contents = prompt;
            }
          } catch (_) {
            // Ignorar fallo de imagen y continuar solo con texto
          }

          // Usar la nueva API de @google/genai
          const response = await geminiClient.models.generateContent({
            model: "gemini-2.5-flash-lite",
            contents: contents
          });
          
          const aiReply = response.text || '';
          
          if (aiReply) {
            // Convertir formato para Instagram
            const formattedReply = convertToInstagramFormat(aiReply);
            
            // Responder y, según sentimiento, dar like automáticamente
            await replyAndMaybeLike(commentData.id, commentData.text, formattedReply);
            
            // Guardar respuesta de IA como comentario
            await saveInstagramComment({
              post_id: post.id,
              instagram_comment_id: `ai_reply_${Date.now()}`,
              parent_comment_id: comment.id,
              user_id: '17841477544945260',
              username: 'magneto_proyecto_ing',
              comment_text: formattedReply,
              is_ai_response: true,
              ai_model: 'google/gemini-2.5-flash-lite'
            });
            
            console.log('Respuesta enviada exitosamente al comentario:', commentData.id);
          }
        } catch (geminiError) {
          console.error('❌ Error generando respuesta con Gemini:', geminiError);
          console.error('   Tipo de error:', geminiError.constructor.name);
          console.error('   Mensaje:', geminiError.message);
          console.error('   Stack:', geminiError.stack);
          // Continuar sin respuesta de IA si falla
        }
      } else {
        console.warn('⚠️ Cliente Gemini no disponible o no tiene el método models.generateContent');
        if (geminiClient) {
          console.warn('   Tipo de cliente:', typeof geminiClient);
          console.warn('   Métodos disponibles:', Object.keys(geminiClient || {}));
        }
      }
    }
  } catch (error) {
    console.error('Error procesando comentario:', error);
  }
}

// Handler para menciones de Instagram
async function handleInstagramMention(mentionData) {
  try {
    console.log('Procesando mención de Instagram:', mentionData);
    
    // Verificar si es una mención del bot mismo (no responder a nosotros mismos)
    if (mentionData.from?.id === '17841477544945260' || mentionData.from?.username === 'magneto_proyecto_ing') {
      console.log('Ignorando mención del bot mismo');
      return;
    }
    
    // Verificar si ya procesamos este mensaje
    if (await isMessageAlreadyProcessed(mentionData.id)) {
      console.log('Mención ya procesada, saltando...');
      return;
    }

    // Obtener información del media
    const mediaInfo = await getInstagramMediaInfo(mentionData.media.id);
    
    // Obtener username del usuario
    let username = mentionData.from.username;
    if (!username) {
      username = await getInstagramUsername(mentionData.from.id);
    }

    // Crear datos de conversación
    const conversationData = {
      platform: 'instagram',
      conversation_type: 'mention',
      external_conversation_id: `mention_${mentionData.id}`,
      user_id: mentionData.from.id,
      username: username,
      status: 'active'
    };

    // Guardar conversación
    const conversation = await saveConversationToSupabase(conversationData);
    
    if (conversation) {
      // Guardar mensaje entrante
      const incomingMessageData = {
        conversacion_id: conversation.id,
        platform_message_id: mentionData.id,
        content: mentionData.text,
        message_type: 'incoming',
        media_context: mediaInfo ? {
          media_id: mediaInfo.id,
          media_type: mediaInfo.media_type,
          media_url: mediaInfo.media_url,
          caption: mediaInfo.caption
        } : null,
        is_ai_generated: false,
        author_name: username || 'Usuario',
        author_type: 'user'
      };

      await saveMessageToSupabase(incomingMessageData);

      // Detectar emoción del usuario automáticamente
      console.log('😊 Detectando emoción del usuario en mención...');
      const detectedEmotion = await detectUserEmotion(mentionData.from.id);
      
      if (detectedEmotion) {
        // Buscar conversación del usuario para actualizar emoción
        const { data: conversation } = await supabase
          .from('conversaciones')
          .select('id')
          .eq('user_id', mentionData.from.id)
          .eq('platform', 'instagram')
          .eq('conversation_type', 'dm')
          .single();
        
        if (conversation) {
          const { error: emotionError } = await supabase
            .from('conversaciones')
            .update({ 
              user_current_emotion: detectedEmotion,
              updated_at: new Date().toISOString()
            })
            .eq('id', conversation.id);
          
          if (emotionError) {
            console.error('❌ Error actualizando emoción:', emotionError);
          } else {
            console.log('✅ Emoción actualizada:', detectedEmotion);
          }
        }
      }

      // Obtener historial de mensajes para contexto
      const messageHistory = await getUserMessageHistory(mentionData.from.id, 5);
      
      // Obtener datos del usuario para personalización
      const userData = await getUserMissingData(mentionData.from.id);
      
      // Construir mensajes para la IA
      const messages = buildMessages(
        mentionData.text,
        { type: 'mention', username: username },
        mediaInfo,
        messageHistory,
        userData?.conversation
      );

      // Generar respuesta con IA
      const geminiClient = getGeminiClient();
      if (geminiClient && geminiClient.models && typeof geminiClient.models.generateContent === 'function') {
        try {
          const prompt = convertMessagesForGemini(messages);
          
          // Usar la nueva API de @google/genai
          const response = await geminiClient.models.generateContent({
            model: "gemini-2.5-flash-lite",
            contents: prompt
          });
          
          const aiReply = response.text || '';
          
          if (aiReply) {
            // Convertir formato para Instagram
            const formattedReply = convertToInstagramFormat(aiReply);
            
            // Enviar respuesta
            await sendInstagramCommentReply(mentionData.id, formattedReply);
            
            // Guardar respuesta de IA
            const aiMessageData = {
              conversacion_id: conversation.id,
              platform_message_id: `ai_reply_${Date.now()}`,
              content: formattedReply,
              message_type: 'outgoing',
              is_ai_generated: true,
              ai_model: 'gemini-2.5-flash-lite',
              author_name: 'Magneto AI',
              author_type: 'ai'
            };

            await saveMessageToSupabase(aiMessageData);
          }
        } catch (geminiError) {
          console.error('❌ Error generando respuesta con Gemini para mención:', geminiError);
          console.error('   Mensaje:', geminiError.message);
        }
      }
    }
  } catch (error) {
    console.error('Error procesando mención:', error);
  }
}

// Handler para mensajes DM de Instagram
async function handleInstagramMessage(messageData) {
  try {
    console.log('Procesando mensaje DM de Instagram:', messageData);
    
    // Saltar si el mensaje viene del bot mismo
    const botId = '17841477544945260';
    if (messageData.sender?.id === botId) {
      console.log('Mensaje del bot mismo, saltando...');
      return;
    }

    // Verificar si ya procesamos este mensaje
    if (await isMessageAlreadyProcessed(messageData.id)) {
      console.log('Mensaje ya procesado, saltando...');
      return;
    }

    // Detectar si es respuesta a story
    const storyInfo = await getStoryInfoFromReply(messageData);
    
    // Obtener información básica del usuario de Instagram
    console.log('🔍 Obteniendo información básica del perfil de Instagram...');
    const userInfo = await getInstagramUserInfo(messageData.sender?.id);
    
    let username = userInfo?.username || await getInstagramUsername(messageData.sender?.id);
    
    console.log('👤 Información básica del usuario obtenida:', {
      username,
      name: userInfo?.name
    });

    // Obtener o crear conversación de DM
    const conversation = await getOrCreateDMConversation(
      messageData.sender?.id, 
      messageData.recipient?.id, 
      username
    );
    
    // Actualizar perfil del usuario con datos básicos de Instagram
    if (conversation && userInfo) {
      console.log('📝 Actualizando perfil con datos básicos de Instagram...');
      
      // Solo actualizar campos básicos
      const profileUpdateData = {
        last_profile_update: new Date().toISOString(),
        updated_at: new Date().toISOString()
      };

      // Agregar solo datos básicos disponibles
      if (userInfo.name) {
        profileUpdateData.user_full_name = userInfo.name;
      }

      console.log('📊 Datos básicos a actualizar:', profileUpdateData);

      // Actualizar la conversación con los datos básicos del perfil
      const { error: updateError } = await supabase
        .from('conversaciones')
        .update(profileUpdateData)
        .eq('id', conversation.id);

      if (updateError) {
        console.error('❌ Error actualizando perfil:', updateError);
      } else {
        console.log('✅ Perfil actualizado exitosamente con datos básicos');
      }
    } else if (conversation) {
      // Si no hay userInfo pero sí hay conversación, al menos actualizar la fecha
      console.log('📝 Actualizando solo fecha de perfil...');
      const { error: updateError } = await supabase
        .from('conversaciones')
        .update({
          last_profile_update: new Date().toISOString(),
          updated_at: new Date().toISOString()
        })
        .eq('id', conversation.id);

      if (updateError) {
        console.error('❌ Error actualizando fecha de perfil:', updateError);
      } else {
        console.log('✅ Fecha de perfil actualizada');
      }
    }

    // Guardar mensaje entrante
    if (conversation) {
      const incomingMessageData = {
        conversacion_id: conversation.id,
        platform_message_id: messageData.id,
        content: messageData.text,
        message_type: 'incoming',
        media_context: storyInfo ? {
          story_id: storyInfo.id,
          media_type: storyInfo.media_type,
          media_url: storyInfo.media_url,
          caption: storyInfo.caption
        } : null,
        is_ai_generated: false,
        author_name: username || 'Usuario',
        author_type: 'user'
      };

      await saveMessageToSupabase(incomingMessageData);

      // Detectar emoción del usuario automáticamente
      console.log('😊 Detectando emoción del usuario...');
      try {
        const detectedEmotion = await detectUserEmotion(messageData.sender?.id);
        console.log(`🎭 Emoción detectada para DM: ${detectedEmotion}`);
        
        if (detectedEmotion && conversation) {
          console.log(`📝 Actualizando emoción en conversación ${conversation.id} a: ${detectedEmotion}`);
          
          // Actualizar emoción en la conversación
          const { error: emotionError } = await supabase
            .from('conversaciones')
            .update({ 
              user_current_emotion: detectedEmotion,
              updated_at: new Date().toISOString()
            })
            .eq('id', conversation.id);
          
          if (emotionError) {
            console.error('❌ Error actualizando emoción:', emotionError);
          } else {
            console.log('✅ Emoción actualizada exitosamente:', detectedEmotion);
          }
        } else if (!detectedEmotion) {
          console.log('⚠️ No se pudo detectar emoción del usuario');
        } else if (!conversation) {
          console.log('⚠️ No hay conversación para actualizar emoción');
        }
      } catch (emotionError) {
        console.error('❌ Error en detección de emoción:', emotionError);
      }

      // Obtener historial de mensajes para contexto
      const messageHistory = await getUserMessageHistory(messageData.sender?.id, 10);
      
      // Obtener datos del usuario para personalización
      const userData = await getUserMissingData(messageData.sender?.id);
      
      // Detectar contexto del mensaje para decidir si hacer preguntas
      const messageText = messageData.text.toLowerCase();
      let context = 'general';
      
      if (messageText.includes('vacante') || messageText.includes('trabajo') || messageText.includes('empleo') || 
          messageText.includes('oportunidad') || messageText.includes('busco trabajo')) {
        context = 'vacancy_interest';
      } else if (messageText.includes('cv') || messageText.includes('hoja de vida') || 
                 messageText.includes('curriculum') || messageText.includes('mejorar')) {
        context = 'cv_help';
      } else if (messageText.includes('buscar') || messageText.includes('encontrar') || 
                 messageText.includes('aplicar')) {
        context = 'job_search';
      }
      
      // Generar respuesta con function calling (actualización automática de datos)
      console.log('🤖 Generando respuesta con function calling...');
      const { reply: aiReply, functionCalls } = await generateResponseWithFunctionCalling(
        messageData.text,
        { type: 'dm', username: username },
        storyInfo,
        messageHistory,
        userData?.conversation,
        messageData.sender?.id
      );
      
      // Log de function calls ejecutados
      if (functionCalls && functionCalls.length > 0) {
        console.log(`✅ ${functionCalls.length} function calls ejecutados automáticamente`);
      }
      
      if (aiReply) {
        // Convertir formato para Instagram
        const formattedReply = convertToInstagramFormat(aiReply);
        
        // Enviar respuesta DM
        const sendResult = await sendInstagramDMReply(messageData.sender?.id, formattedReply);
        
        // Solo guardar si se envió exitosamente
        if (sendResult.success) {
          const aiMessageData = {
            conversacion_id: conversation.id,
            platform_message_id: `ai_reply_${Date.now()}`,
            content: formattedReply,
            message_type: 'outgoing',
            is_ai_generated: true,
            ai_model: 'google/gemini-2.5-flash-lite',
            author_name: 'Magneto AI',
            author_type: 'ai'
          };

          await saveMessageToSupabase(aiMessageData);
        }
      }
    }
  } catch (error) {
    console.error('Error procesando mensaje DM:', error);
  }
}

// Handler para likes de posts de Instagram
async function handleInstagramLike(likeData) {
  try {
    console.log('Procesando like de Instagram:', likeData);
    
    const PostLikeRepository = require('../repositories/PostLikeRepository');
    const { getInstagramMediaInfo } = require('./functions');
    const postLikeRepository = new PostLikeRepository();

    // Extraer información del webhook de Instagram
    const {
      object_id: postId,
      user_id: userId,
      username,
      timestamp
    } = likeData;

    if (!postId || !userId) {
      console.error('Datos incompletos en like:', likeData);
      return { success: false, message: 'Datos incompletos' };
    }

    // Verificar si ya existe este like (evitar duplicados)
    const existingLike = await postLikeRepository.findByPostAndUser(postId, userId);
    if (existingLike) {
      console.log('Like ya existe, actualizando timestamp');
      // Actualizar timestamp si es un nuevo like del mismo usuario
      return { success: true, message: 'Like ya registrado', like: existingLike };
    }

    // Obtener información del post desde Instagram API
    let mediaInfo = null;
    try {
      mediaInfo = await getInstagramMediaInfo(postId);
    } catch (error) {
      console.warn('No se pudo obtener información del post:', error.message);
      // Continuar sin la información del post si no está disponible
    }

    // Crear el like en la base de datos
    const like = await postLikeRepository.create({
      instagramPostId: postId,
      instagramUserId: userId,
      username: username || 'unknown',
      mediaType: mediaInfo?.media_type || 'UNKNOWN',
      mediaUrl: mediaInfo?.media_url || null,
      caption: mediaInfo?.caption || null,
      timestamp: timestamp ? new Date(timestamp * 1000) : new Date()
    });

    console.log('✅ Like registrado exitosamente:', like.id);

    // Analizar preferencias del usuario (asíncrono, no bloquea la respuesta)
    setImmediate(async () => {
      try {
        const UserPreferencesService = require('../services/UserPreferencesService');
        const preferencesService = new UserPreferencesService();
        
        // Verificar si tiene suficientes datos para análisis
        const hasEnoughData = await preferencesService.hasEnoughData(userId, 5);
        if (hasEnoughData) {
          console.log(`📊 Usuario ${userId} tiene suficientes likes para análisis de preferencias`);
          // Opcional: Generar resumen de preferencias
          // const summary = await preferencesService.generateAIPreferencesSummary(userId);
          // console.log('Resumen de preferencias:', summary);
        }
      } catch (error) {
        console.error('Error analizando preferencias del usuario:', error);
        // No fallar si el análisis de preferencias falla
      }
    });

    return {
      success: true,
      message: 'Like procesado exitosamente',
      like: like.toResponseJson()
    };
  } catch (error) {
    console.error('❌ Error procesando like de Instagram:', error);
    throw error;
  }
}

module.exports = {
  handleInstagramComment,
  handleInstagramMention,
  handleInstagramMessage,
  handleInstagramLike
};
