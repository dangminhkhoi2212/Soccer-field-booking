import { Schema, Types, model } from 'mongoose';

const FieldSchema: Schema = new Schema(
    {
        userID: { type: Types.ObjectId, ref: 'User', required: true },
        name: { type: String, max: 30, trim: true, required: true },
        views: { type: Number, default: 0 },
        price: { type: Number, required: true, default: 0 },
        coverImage: { type: String, default: '' },
        type: {
            type: Number,
            required: true,
            default: 5,
            max: 11,
        },
        isPublic: { type: Boolean, default: true, required: true }, // true is public
        isLock: { type: Boolean, default: true, required: true }, // true is public
        isRepair: { type: Boolean, default: false, required: true }, // true is repair
        description: { type: String, default: '', max: 3000 },
        length: { type: Number, required: true },
        width: { type: Number, required: true },
        lock: {
            status: { type: Boolean, default: false },
            content: { type: String, default: '', max: 1500 },
        },
    },
    {
        timestamps: true,
        versionKey: false,
    }
);

export default model('Field', FieldSchema);
