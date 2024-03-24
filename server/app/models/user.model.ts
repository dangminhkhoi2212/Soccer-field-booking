import mongoose, { ObjectId, Schema, model } from 'mongoose';
import { ROLE } from '../const/user.const';

export interface TUser {
    _id: string;
    name: string;
    email: string;
    password: string;
    avatar: string;
    isPublic: Boolean;
    lock: {
        status: Boolean;
        content: string;
    };
    phone?: string;
    refreshToken: string;
    role: string;
}
const UserSchema: Schema<TUser> = new Schema(
    {
        name: { type: String, max: 30, trim: true, required: true },
        email: {
            type: String,
            trim: true,
            unique: true,
            lowercase: true,
            required: true,
        },
        password: { type: String, required: true },
        avatar: {
            type: String,
            default:
                'https://firebasestorage.googleapis.com/v0/b/stadium-booking-854aa.appspot.com/o/avatar%2Favatar_user.png?alt=media&token=d64d8608-ee56-4b91-bbff-ced68a52cc06',
        },
        isPublic: { type: Boolean, default: true, required: true },
        lock: {
            status: { type: Boolean, default: false },
            content: { type: String, default: '', max: 1500 },
        },
        phone: {
            type: String,
            minLength: [10, 'no should have minimum 10 digits'],
            maxLength: [10, 'no should have maximum 10 digits'],
            match: [/\d{10}/, 'no should only have digits'],
            validator: function (v: string) {
                return v.length == 10;
            },
            unique: true,
        },
        role: { type: String, enum: ROLE, default: ROLE.user },
        refreshToken: { type: String, default: '' },
    },
    {
        timestamps: true,
        versionKey: false,
    }
);
export default model<TUser>('User', UserSchema);
