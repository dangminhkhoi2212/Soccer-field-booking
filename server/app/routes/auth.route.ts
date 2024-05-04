import { Router } from 'express';
import GoogleMiddleware from '../middlewares/google.middleware';
import AuthController from '../controllers/auth.controller';

const router: Router = Router();

// const googleMiddleware: GoogleMiddleware = new GoogleMiddleware();
// router.route('/login').post(AuthController.signIn);
router.route('/sign-in').post(AuthController.signIn);
router.route('/').post(AuthController.signUp);
export default router;
