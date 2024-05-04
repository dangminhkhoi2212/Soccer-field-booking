import { Request, Response } from 'express';
import mongooseUtil, { TOjectID } from '../utils/mongoose.util';
import favoriteService from '../services/favorite.service';
interface TGetFavorites {
    userID: string;
    page?: string;
    limit?: string;
    sort?: string;
}
class FavoriteController {
    private static instance: FavoriteController;

    static getInstance() {
        if (!FavoriteController.instance) {
            FavoriteController.instance = new FavoriteController();
        }
        return FavoriteController.instance;
    }

    async handleFavorite(req: Request, res: Response) {
        try {
            const { userID, sellerID } = req.body;
            if (!userID) {
                res.status(400).json({ err_mes: 'userID is required' });
            }
            if (!sellerID) {
                res.status(400).json({ err_mes: 'sellerID is required' });
            }
            const validUserID: TOjectID = mongooseUtil.createOjectID(userID);
            const validSellerID: TOjectID =
                mongooseUtil.createOjectID(sellerID);

            const result = await favoriteService.handleFavorite({
                userID: validUserID,
                sellerID: validSellerID,
            });

            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
    async checkFavorite(req: Request, res: Response) {
        try {
            const { userID, sellerID } = req.query as {
                userID: string;
                sellerID: string;
            };
            console.log(
                '🚀 ~ FavoriteController ~ checkFavorite ~ req.params:',
                req.query
            );
            if (!userID) {
                return res.status(400).json({ err_mes: 'userID is required' });
            }
            if (!sellerID) {
                return res
                    .status(400)
                    .json({ err_mes: 'sellerID is required' });
            }
            const validUserID: TOjectID = mongooseUtil.createOjectID(userID);
            const validSellerID: TOjectID =
                mongooseUtil.createOjectID(sellerID);

            const result = await favoriteService.checkFavorite({
                userID: validUserID,
                sellerID: validSellerID,
            });

            return res.send({ isFavorite: result });
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
    async getFavorites(req: Request, res: Response) {
        try {
            const { userID } = req.query as unknown as TGetFavorites;
            console.log(
                '🚀 ~ FavoriteController ~ getFavorites ~ userID:',
                userID
            );
            if (!userID) {
                return res.status(400).json({ err_mes: 'userID is required' });
            }

            const validUserID: TOjectID = mongooseUtil.createOjectID(userID);

            const result = await favoriteService.getFavorites({
                userID: validUserID,
                page: 1,
                limit: 20,
                sortBy: '',
            });

            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
}
export default FavoriteController.getInstance();
