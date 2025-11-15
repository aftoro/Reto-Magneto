#!/usr/bin/env node

/**
 * Script para verificar el estado de un contenedor de reel y publicarlo cuando esté listo
 * 
 * Uso:
 *   node scripts/check-and-publish-reel.js <container-id>
 */

require('dotenv').config();

async function checkAndPublish(containerId) {
  try {
    console.log(`🔍 Verificando estado del contenedor: ${containerId}`);
    
    let status = 'IN_PROGRESS';
    let attempts = 0;
    const maxAttempts = 60; // 5 minutos máximo (60 * 5 segundos)
    
    while (attempts < maxAttempts) {
      attempts++;
      
      const statusResp = await fetch(`https://graph.instagram.com/v24.0/${containerId}?fields=status_code`, {
        headers: { 'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}` }
      });
      
      if (!statusResp.ok) {
        const err = await statusResp.text();
        console.warn(`⚠️ Error consultando status (${attempts}/${maxAttempts}):`, err);
        await new Promise(r => setTimeout(r, 5000));
        continue;
      }
      
      const statusJson = await statusResp.json();
      status = statusJson.status_code || 'IN_PROGRESS';
      console.log(`⏳ Estado contenedor (${attempts}/${maxAttempts}): ${status}`);
      
      if (status === 'FINISHED' || status === 'PUBLISHED') {
        console.log('✅ Contenedor listo! Publicando...');
        break;
      }
      
      if (status === 'ERROR' || status === 'EXPIRED') {
        console.error(`❌ Error en el contenedor: ${status}`);
        process.exit(1);
      }
      
      await new Promise(r => setTimeout(r, 5000)); // Esperar 5 segundos entre checks
    }
    
    if (status !== 'FINISHED' && status !== 'PUBLISHED') {
      console.error(`⏰ Timeout esperando contenedor (status=${status})`);
      process.exit(1);
    }
    
    // Publicar
    console.log('📤 Publicando reel...');
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
      process.exit(1);
    }
    
    const publishData = await publishResp.json();
    console.log('✅ Reel publicado exitosamente!');
    console.log(`   Media ID: ${publishData.id}`);
    
    // Obtener permalink
    try {
      const fieldsResp = await fetch(`https://graph.instagram.com/v24.0/${publishData.id}?fields=permalink,media_type,media_url,media_product_type`, {
        headers: { 'Authorization': `Bearer ${process.env.INSTAGRAM_ACCESS_TOKEN}` }
      });
      if (fieldsResp.ok) {
        const fields = await fieldsResp.json();
        if (fields.permalink) {
          console.log(`   URL: ${fields.permalink}`);
        }
      }
    } catch (e) {
      console.warn('⚠️ No se pudo obtener permalink:', e.message);
    }
    
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

const containerId = process.argv[2];
if (!containerId) {
  console.error('❌ Uso: node scripts/check-and-publish-reel.js <container-id>');
  process.exit(1);
}

checkAndPublish(containerId);

