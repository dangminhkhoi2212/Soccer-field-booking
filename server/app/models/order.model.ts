import { Schema, Types, model, ObjectId } from 'mongoose';
import { COrder } from '../const/order.const';

export interface TOrder {
    userID: ObjectId;
    sellerID: ObjectId;
    fieldID: ObjectId;
    total: number;
    isPay: boolean;
    startTime: Date;
    endTime: Date;
    date: Date;
    status: string;
}
const OrderSchema: Schema<TOrder> = new Schema(
    {
        userID: { type: Types.ObjectId, ref: 'User' },
        fieldID: { type: Types.ObjectId, ref: 'Field' },
        total: { type: Number, default: 0 },
        isPay: { type: Boolean, default: true },
        startTime: { type: Date, required: true },
        endTime: { type: Date, required: true },
        date: {
            type: Date,
            required: true,
            default: new Date(),
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
