# Magneto Empleos Backend API v2.0

## 🏗️ Arquitectura

Este backend utiliza una **Arquitectura por Capas (Layered Architecture)** con middlewares para proporcionar una estructura escalable, mantenible y robusta.

### Estructura de Capas

```
src/
├── config/           # Configuraciones del sistema
│   ├── database.js   # Configuración de Supabase
│   └── environment.js # Variables de entorno
├── controllers/      # Capa de Controladores
│   ├── UserController.js
│   └── MessageController.js
├── services/         # Capa de Servicios (Lógica de Negocio)
│   ├── UserService.js
│   └── MessageService.js
├── repositories/     # Capa de Repositorios (Acceso a Datos)
│   ├── UserRepository.js
│   └── MessageRepository.js
├── models/           # Capa de Modelos (Entidades de Dominio)
│   ├── User.js
│   ├── Message.js
│   └── Conversation.js
├── middlewares/      # Middlewares de la Aplicación
│   ├── auth.middleware.js
│   ├── logging.middleware.js
│   ├── validation.middleware.js
│   └── rate-limit.middleware.js
├── routes/           # Definición de Rutas
│   ├── user.routes.js
│   ├── message.routes.js
│   ├── instagram.routes.js
│   └── index.js
└── server.js         # Punto de entrada principal
```

## 🔧 Middlewares Implementados

### 1. Autenticación (`auth.middleware.js`)
- **authMiddleware**: Verifica tokens JWT de Supabase
- **optionalAuthMiddleware**: Autenticación opcional para endpoints públicos

### 2. Logging (`logging.middleware.js`)
- **loggingMiddleware**: Registra todas las peticiones HTTP
- **errorLoggingMiddleware**: Captura y registra errores no manejados
- Logs en consola y archivos por fecha

### 3. Validación (`validation.middleware.js`)
- **validateBody**: Valida que el body no esté vacío
- **validateUserData**: Valida datos de usuario
- **validateInstagramData**: Valida datos de Instagram
- **validateFileSize**: Valida tamaño de archivos
- **validateFileType**: Valida tipos de archivo
- **sanitizeInput**: Sanitiza datos de entrada

### 4. Rate Limiting (`rate-limit.middleware.js`)
- **rateLimitByIP**: Limita peticiones por IP
- **rateLimitByUser**: Limita peticiones por usuario autenticado
- **rateLimitWebhooks**: Limita webhooks de Instagram

## 🚀 Instalación y Uso

### Prerrequisitos
- Node.js >= 16.0.0
- Variables de entorno configuradas

### Instalación
```bash
npm install
```

### Variables de Entorno
Crear archivo `.env` con:
```env
# Servidor
PORT=3000
NODE_ENV=development

# Supabase
SUPABASE_URL=tu_supabase_url
SUPABASE_ANON_KEY=tu_supabase_anon_key
SUPABASE_SERVICE_KEY=tu_supabase_service_key

# Instagram
INSTAGRAM_VERIFY_TOKEN=tu_verify_token
INSTAGRAM_ACCESS_TOKEN=tu_access_token
INSTAGRAM_APP_ID=tu_app_id
INSTAGRAM_APP_SECRET=tu_app_secret

# Google AI
GOOGLE_AI_API_KEY=tu_google_ai_key

# CORS
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:3001

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=1000
WEBHOOK_RATE_LIMIT_MAX_REQUESTS=10
WEBHOOK_RATE_LIMIT_WINDOW_MS=60000

# Logging
LOG_LEVEL=info
ENABLE_FILE_LOGGING=true
LOG_DIRECTORY=./logs

# Archivos
MAX_FILE_SIZE=10485760
ALLOWED_FILE_TYPES=image/jpeg,image/png,image/gif,video/mp4
```

### Ejecución
```bash
# Desarrollo
npm run dev

# Producción
npm start
```

## 📚 Endpoints de la API

### Usuarios (`/api/users`)
- `POST /register` - Registro de usuario
- `POST /login` - Inicio de sesión
- `GET /profile` - Obtener perfil (requiere auth)
- `PUT /profile` - Actualizar perfil (requiere auth)
- `POST /logout` - Cerrar sesión (requiere auth)
- `GET /stats` - Estadísticas de usuarios (requiere auth)
- `GET /list` - Listar usuarios (requiere auth)
- `GET /search` - Buscar usuarios (requiere auth)
- `GET /:id` - Obtener usuario por ID (requiere auth)
- `DELETE /:id` - Eliminar usuario (requiere auth)

### Mensajes (`/api/messages`)
- `POST /` - Crear mensaje (requiere auth)
- `GET /conversation/:id` - Mensajes de conversación (requiere auth)
- `GET /my-messages` - Mis mensajes (requiere auth)
- `GET /search` - Buscar mensajes (requiere auth)
- `GET /type/:type` - Mensajes por tipo (requiere auth)
- `GET /unprocessed` - Mensajes no procesados (requiere auth)
- `GET /stats` - Estadísticas de mensajes (requiere auth)
- `GET /ai-history/:id` - Historial para AI (requiere auth)
- `POST /ai-response` - Crear respuesta de AI (requiere auth)
- `POST /batch-process` - Procesar en lote (requiere auth)
- `GET /:id` - Obtener mensaje por ID (requiere auth)
- `PUT /:id` - Actualizar mensaje (requiere auth)
- `PATCH /:id/process` - Marcar como procesado (requiere auth)
- `DELETE /:id` - Eliminar mensaje (requiere auth)

### Instagram (`/api/instagram`)
- `GET /webhook/verify` - Verificación de webhook
- `POST /webhook/comment` - Webhook de comentarios
- `POST /webhook/mention` - Webhook de menciones
- `POST /webhook/message` - Webhook de mensajes
- `GET /posts` - Obtener posts de Instagram
- `GET /posts/:id/comments` - Comentarios de post
- `POST /publish/post` - Publicar post
- `POST /publish/story` - Publicar story
- `POST /publish/reel` - Publicar reel

## 🔒 Seguridad

- **Autenticación JWT** con Supabase
- **Rate Limiting** por IP y usuario
- **Validación de datos** en todos los endpoints
- **Sanitización de entrada** para prevenir XSS
- **CORS** configurado
- **Logging** de todas las operaciones

## 📊 Monitoreo

- **Health Check**: `GET /health`
- **API Info**: `GET /api/info`
- **Logs**: Consola y archivos en `./logs/`
- **Métricas**: Endpoints de estadísticas

## 🧪 Testing

```bash
# Ejecutar tests
npm test

# Linting
npm run lint

# Linting con auto-fix
npm run lint:fix
```

## 🔄 Migración desde v1.0

La nueva arquitectura mantiene compatibilidad con los endpoints existentes:
- Todas las rutas de Instagram siguen funcionando
- Las funciones existentes están disponibles
- Los webhooks mantienen la misma interfaz

## 📈 Beneficios de la Nueva Arquitectura

1. **Separación de Responsabilidades**: Cada capa tiene una función específica
2. **Mantenibilidad**: Código más fácil de mantener y modificar
3. **Testabilidad**: Cada capa puede ser probada independientemente
4. **Escalabilidad**: Fácil agregar nuevas funcionalidades
5. **Seguridad**: Middlewares robustos para protección
6. **Monitoreo**: Logging y métricas integradas
7. **Flexibilidad**: Fácil cambiar implementaciones

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.
