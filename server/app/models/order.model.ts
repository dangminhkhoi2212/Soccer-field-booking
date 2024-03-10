import { Schema, Types, model, ObjectId } from 'mongoose';
import { COrder } from '../consts/order.const';

export interface TOrder {
    userID: ObjectId;
    sellerID: ObjectId;
    fieldID: ObjectId;
    total: number;
    isPay: boolean;
    startTime: string;
    endTime: string;
    date: string;
    status: string;
}
const OrderSchema: Schema<TOrder> = new Schema(
    {
        userID: { type: Types.ObjectId, ref: 'User' },
        sellerID: { type: Types.ObjectId, ref: 'User' },
        fieldID: { type: Types.ObjectId, ref: 'Field' },
        total: { type: Number, default: 0 },
        isPay: { type: Boolean, default: true },
        startTime: { type: String, required: true },
        endTime: { type: String, required: true },
        date: {
            type: String,
            required: true,
            default: new Date().toISOString(),
        },
        status: {
            type: String,
            enum: [COrder.pending, COrder.ordered, COrder.cancel],
            default: COrder.pending,
        },
    },
    { timestamps: true, versionKey: false }
);
export default model<TOrder>('Order', OrderSchema);
