import { Router } from 'express';
import tokenController from '../controllers/token.controller';
import tokenMiddleware from '../middlewares/token.middleware';

const router = Router();

router.route('/refreshToken').post(tokenController.createRefreshToken);
export default router;
