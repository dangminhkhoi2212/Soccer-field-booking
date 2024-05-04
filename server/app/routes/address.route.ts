import { Router } from 'express';
import AddressController from '../controllers/address.controller';

const router: Router = Router();
router.route('/all').get(AddressController.getAddress);
router
    .route('/')
    .get(AddressController.getOneAddress)
    .put(AddressController.updateAddress);

export default router;
