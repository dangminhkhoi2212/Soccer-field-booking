import { Schema, Types, model } from 'mongoose';

const FavoriteModel: Schema = new Schema(
    {
        userId: {
            type: Types.ObjectId,
            ref: 'User',
        },
        favorites: [{ type: Types.ObjectId, ref: 'Field' }],
    },
    {
        timestamps: true,
        versionKey: false,
    }
);

export default model('Favorite', FavoriteModel);
