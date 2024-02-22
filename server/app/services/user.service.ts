import mongoose, { HydratedDocument, ObjectId } from 'mongoose';
import UserModel, { TUser } from '../models/user.model';
import 'dotenv/config';
const USER_JSON: string = process.env.USER_JSON?.toString() || '';
type TGetUser = {
    userID?: ObjectId;
    email?: string;
    phone?: string;
};
class UserService {
    static async getUser(params: TGetUser) {
        const query: any = params;
        Object.keys(query).forEach((key) => {
            if (!query[key]) delete query[key];
        });

        if (query.userID)
            return await UserModel.findById(
                new mongoose.Types.ObjectId(query.userID)
            );
        return await UserModel.findOne(query).select(USER_JSON);
    }

    static async updateUser({
        userID,
        name,
        phone,
        avatar,
    }: {
        userID: string;
        name: string;
        phone: string;
        avatar: string;
    }) {
        return await UserModel.findByIdAndUpdate(
            { _id: new mongoose.Types.ObjectId(userID) },
            { name, phone, avatar },
            { new: true }
        );
    }
}

export default UserService;
