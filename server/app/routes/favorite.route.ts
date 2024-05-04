import { Router } from 'express';
import favoriteController from '../controllers/favorite.controller';

const router: Router = Router();

router.route('/all').get(favoriteController.getFavorites);
router
    .route('/')
    .get(favoriteController.checkFavorite)
    .post(favoriteController.handleFavorite);
export default router;
