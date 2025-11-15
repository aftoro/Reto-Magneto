const express = require('express');
const UserController = require('../controllers/UserController');
const { authMiddleware } = require('../middlewares/auth.middleware');
const { 
  validateBody, 
  validateUserData, 
  sanitizeInput 
} = require('../middlewares/validation.middleware');
const { rateLimitByIP } = require('../middlewares/rate-limit.middleware');

const router = express.Router();
const userController = new UserController();

// Aplicar middlewares globales
router.use(validateBody);
router.use(sanitizeInput);

// Rutas públicas (sin autenticación)
router.post('/register', 
  rateLimitByIP({ maxRequests: 5, windowMs: 15 * 60 * 1000 }), // 5 registros por 15 min
  validateUserData,
  userController.register.bind(userController)
);

router.post('/login', 
  rateLimitByIP({ maxRequests: 10, windowMs: 15 * 60 * 1000 }), // 10 intentos por 15 min
  validateUserData,
  userController.login.bind(userController)
);

router.post('/send-verification', 
  rateLimitByIP({ maxRequests: 3, windowMs: 15 * 60 * 1000 }), // 3 emails por 15 min
  userController.sendVerificationEmail.bind(userController)
);

router.post('/reset-password', 
  rateLimitByIP({ maxRequests: 3, windowMs: 15 * 60 * 1000 }), // 3 resets por 15 min
  userController.resetPassword.bind(userController)
);

router.get('/check-email', 
  userController.checkEmailExists.bind(userController)
);

// Rutas protegidas (requieren autenticación)
router.use(authMiddleware);

router.get('/profile', 
  userController.getProfile.bind(userController)
);

router.put('/profile', 
  validateUserData,
  userController.updateProfile.bind(userController)
);

router.post('/logout', 
  userController.logout.bind(userController)
);

// Rutas de administración (requieren autenticación + rol admin)
router.get('/stats', 
  userController.getUserStats.bind(userController)
);

router.get('/list', 
  userController.listUsers.bind(userController)
);

router.get('/search', 
  userController.searchUsers.bind(userController)
);

router.get('/:id', 
  userController.getUserById.bind(userController)
);

router.delete('/:id', 
  userController.deleteUser.bind(userController)
);

module.exports = router;
