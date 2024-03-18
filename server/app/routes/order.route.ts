import { Router } from 'express';
import OrderController from '../controllers/order.controller';

const router: Router = Router();
const orderController = new OrderController();

router.route('/time').get(orderController.getOrderedTime);
router.route('/field').get(orderController.getFieldOrdered);
router.route('/all').get(orderController.getAllOrder);
router
    .route('/')
    .post(orderController.createOrder)
    .put(orderController.updateOrder)
    .get(orderController.getOneOrder);

export default router;
