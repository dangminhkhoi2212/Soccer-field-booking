import { Router } from 'express';
import SellerController from '../controllers/seller.controller';

const router: Router = Router();

router
    .route('/')
    .post(SellerController.updateSeller)
    .get(SellerController.getSeller);

export default router;
