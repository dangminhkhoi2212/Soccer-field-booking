import { PipelineStage } from 'mongoose';
import favoriteModel from '../models/favorite.model';
import { TOjectID } from './../utils/mongoose.util';

interface THandleFavorite {
    userID: TOjectID;
    sellerID: TOjectID;
}
interface TGetAllFavorite {
    userID: TOjectID;
    page: number;
    limit: number;
    sortBy: string;
}
class FavoriteService {
    private static instance: FavoriteService;

    static getInstance() {
        if (!FavoriteService.instance) {
            FavoriteService.instance = new FavoriteService();
        }
        return FavoriteService.instance;
    }
    async checkFavorite(data: THandleFavorite): Promise<boolean> {
        const { userID, sellerID } = data;

        const result = await favoriteModel.findOne({
            userID,
            favorites: { $in: [sellerID] },
        });

        return result !== null;
    }
    async handleFavorite(
        data: THandleFavorite
    ): Promise<{ status: string; isFavorite: boolean }> {
        const { userID, sellerID } = data;
        const checkFavorite: boolean = await this.checkFavorite({
            userID,
            sellerID,
        });
        let isFavorite: boolean = false;
        console.log(
            '🚀 ~ FavoriteService ~ handleFavorite ~ checkFavorite:',
            checkFavorite
        );
        let status: string;
        if (!checkFavorite) {
            await favoriteModel.findOneAndUpdate(
                { userID },
                { $addToSet: { favorites: sellerID } },
                { upsert: true }
            );
            status = 'add favorite';
            isFavorite = true;
        } else {
            await favoriteModel.findOneAndUpdate(
                { userID },
                {
                    $pull: { favorites: sellerID },
                }
            );
            status = 'remove favorite';
            isFavorite = false;
        }
        return { status, isFavorite };
    }
    async getFavorites(data: TGetAllFavorite) {
        const { userID, page = 1, limit = 30, sortBy } = data;
        const agg: PipelineStage[] = [];

        agg.push(
            {
                $match: { userID },
            },
            {
                $lookup: {
                    from: 'users',
                    localField: 'favorites',
                    foreignField: '_id',
                    as: 'favorites',
                    pipeline: [
                        {
                            $project: {
                                _id: 1,
                                name: 1,
                                avatar: 1,
                            },
                        },
                    ],
                },
            }
        );
        let result: any = await favoriteModel.aggregate(agg);
        let newResult: any = [...result][0]; // because result is array
        if (newResult.favorites && newResult.favorites.length) {
            newResult = await Promise.all(
                newResult.favorites.map(async (item: any) => {
                    item.followers = await this.getFavoriteCount(item._id);
                    return item;
                })
            );
        }

        return newResult;
    }
    async getFavoriteCount(userID: TOjectID) {
        return await favoriteModel.countDocuments({
            favorites: { $in: [userID] },
        });
    }
}
export default FavoriteService.getInstance();
