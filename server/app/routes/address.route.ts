import { Router } from 'express';
import AddressController from '../controllers/address.controller';

const router: Router = Router();

router
    .route('/')
    .get(AddressController.getAddress)
    .put(AddressController.updateAddress);

export default router;
