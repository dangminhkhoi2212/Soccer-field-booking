import { Schema, Types, model } from 'mongoose';

const FeedbackSchema: Schema = new Schema(
    {
        userID: { type: Types.ObjectId, ref: 'User', required: true },
        fieldID: { type: Types.ObjectId, ref: 'Field', required: true },
        star: { type: Number, required: true, default: 5, min: 1, max: 5 },
        content: { type: String, max: 1500, default: '' },
    },
    {
        timestamps: true,
        versionKey: false,
    }
);

export default model('Feedback', FeedbackSchema);
