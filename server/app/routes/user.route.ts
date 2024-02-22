import { Router } from 'express';
import UserController from '../controllers/user.controller';

const router: Router = Router();

router.route('/').put(UserController.updateUser).get(UserController.getOneUser);
export default router;
