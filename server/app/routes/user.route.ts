import { Router } from 'express';
import UserController from '../controllers/user.controller';
const userController: UserController = new UserController();
const router: Router = Router();
router.route('/all').get(userController.getUsers);
router.route('/').put(userController.updateUser).get(userController.getOneUser);
export default router;
