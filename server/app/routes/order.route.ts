import { Router } from 'express';
import OrderController from '../controllers/order.controller';
import tokenMiddleware from '../middlewares/token.middleware';

const router: Router = Router();
const orderController = new OrderController();

router.route('/time').get(orderController.getOrderedTime);
router.route('/field').get(orderController.getOrderedField);
router
    .route('/all')
    .get(tokenMiddleware.authenticateJWT, orderController.getAllOrder);
router
    .route('/')
    .post(orderController.createOrder)
    .put(orderController.updateOrder)
    .get(orderController.getOneOrder);

export default router;
