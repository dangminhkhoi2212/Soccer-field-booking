import { Router } from 'express';
import SellerController from '../controllers/seller.controller';

const router: Router = Router();
router.route('/all').get(SellerController.getSeller);
router
    .route('/')
    .post(SellerController.updateSeller)
    .get(SellerController.getOneSeller);

export default router;
