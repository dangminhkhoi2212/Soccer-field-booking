import { Schema, Types, model } from 'mongoose';
import { COrder } from '../consts/order.const';

const OrderSchema: Schema = new Schema(
    {
        userID: { type: Types.ObjectId, ref: 'User' },
        ownerID: { type: Types.ObjectId, ref: 'User' },
        fieldID: { type: Types.ObjectId, ref: 'Field' },
        total: { type: Number, default: 0 },
        paid: { type: Boolean, default: true },
        status: {
            type: String,
            enum: [COrder.CO1, COrder.CO2, COrder.CO3],
            default: COrder.CO1,
        },
    },
    { timestamps: true, versionKey: false }
);
export default model('Order', OrderSchema);
