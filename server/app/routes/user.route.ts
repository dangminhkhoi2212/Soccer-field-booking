import { Router } from 'express';
import userController from '../controllers/user.controller';
import tokenMiddleware from '../middlewares/token.middleware';
const router: Router = Router();
router.route('/all').get(userController.getUsers);
router
    .route('/password')
    .post(tokenMiddleware.authenticateJWT, userController.changePassword);
router.route('/').put(userController.updateUser).get(userController.getOneUser);
export default router;
