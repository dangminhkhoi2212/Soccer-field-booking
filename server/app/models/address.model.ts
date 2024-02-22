import { Schema, Types, model } from 'mongoose';

const AddressSchema: Schema = new Schema(
    {
        userID: { type: Types.ObjectId, ref: 'User' },
        latitude: { type: Number },
        longitude: { type: Number },
        ward: { type: String, default: '' },
        district: { type: String, default: '' },
        province: { type: String, default: '' },
        sub: { type: String, max: 500, default: '' },
        address: { type: String, max: 100, default: '' },
    },
    {
        timestamps: true,
        versionKey: false,
    }
);

export default model('Address', AddressSchema);
