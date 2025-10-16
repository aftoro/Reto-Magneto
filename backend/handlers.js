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
    const detectedEmotion = await detectUserEmotion(commentData.from.id);
    
    if (detectedEmotion) {
      // Buscar conversación del usuario para actualizar emoción
      const { data: conversation } = await supabase
        .from('conversaciones')
        .select('id')
        .eq('user_id', commentData.from.id)
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
      if (geminiClient) {
        const model = geminiClient.getGenerativeModel({ model: "gemini-2.5-flash-lite" });
        const prompt = convertMessagesForGemini(messages);
        const result = await model.generateContent(prompt);
        const response = await result.response;
        const aiReply = response.text();
        
        if (aiReply) {
          // Convertir formato para Instagram
          const formattedReply = convertToInstagramFormat(aiReply);
          
          // Enviar respuesta
          await sendInstagramCommentReply(commentData.id, formattedReply);
          
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
      if (geminiClient) {
        const model = geminiClient.getGenerativeModel({ model: "gemini-2.5-flash-lite" });
        const prompt = convertMessagesForGemini(messages);
        const result = await model.generateContent(prompt);
        const response = await result.response;
        const aiReply = response.text();
        
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
      const detectedEmotion = await detectUserEmotion(messageData.sender?.id);
      
      if (detectedEmotion && conversation) {
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
          console.log('✅ Emoción actualizada:', detectedEmotion);
        }
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

module.exports = {
  handleInstagramComment,
  handleInstagramMention,
  handleInstagramMessage
};
