import mongoose, { ObjectId, Schema, model } from 'mongoose';

const timeDefault = (h: number, m: number, s: number, ms: number) => {
    const date = new Date();
    date.setHours(h, m, s, ms);
    return date;
};
interface TSeller extends Document {
    userID: ObjectId;
    startTime: String;
    endTime: String;
    revenue: number;
    isHalfHour: boolean;
}
const SellerSchema: Schema = new Schema({
    userID: { type: mongoose.Types.ObjectId, ref: 'User', required: true },
    startTime: {
        type: String,
        required: true,
        default: timeDefault(0, 0, 0, 0),
    },
    endTime: { type: String, required: true, default: timeDefault(0, 0, 0, 0) },
    revenue: { type: Number, default: 0 },
    isHalfHour: { type: Boolean, default: true },
});
export default model<TSeller>('Seller', SellerSchema);
