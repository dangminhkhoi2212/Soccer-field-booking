import mongoose, { Schema, Document, Types, Model } from 'mongoose';

interface IFavorite extends Document {
    userID: Types.ObjectId;
    favorites: Types.ObjectId[];
}

const FavoriteModel: Schema = new Schema(
    {
        userID: {
            type: Types.ObjectId,
            ref: 'User',
            required: true,
        },
        favorites: {
            type: [{ type: Types.ObjectId, ref: 'User' }],
            validate: {
                validator: (ids: Types.ObjectId[]) => {
                    return ids.length <= 2000;
                },
                message: 'Favorites have a maximum length of 2000',
            },
        },
    },
    {
        timestamps: true,
        versionKey: false,
    }
);

const Favorite: Model<IFavorite> = mongoose.model<IFavorite>(
    'Favorite',
    FavoriteModel
);

export default Favorite;
