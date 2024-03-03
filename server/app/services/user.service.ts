import mongoose, { HydratedDocument, ObjectId } from 'mongoose';
import UserModel, { TUser } from '../models/user.model';
import 'dotenv/config';
import MongooseUtil from '../utils/mongoose.util';
import SellerModel from '../models/seller.model';
import addressModel from '../models/address.model';
const USER_JSON: string = process.env.USER_JSON?.toString() || '';
type TGetUser = {
    userID?: ObjectId;
    email?: string;
    phone?: string;
};
const mongooseUtil = new MongooseUtil();
class UserService {
    static async getOneUser(params: TGetUser) {
        const query: any = params;
        Object.keys(query).forEach((key) => {
            if (!query[key]) delete query[key];
        });

        if (query.userID) {
            const userID = mongooseUtil.createOjectID(query.userID);
            const result = await UserModel.findById(
                userID,
                '-password -refreshToken -createdAt -updatedAt'
            );
            return result;
        } else {
            const result = await UserModel.findOne(query);

            return result;
        }
    }
    static async getUsers(params: TGetUser) {
        const query: any = params;
        Object.keys(query).forEach((key) => {
            if (!query[key]) delete query[key];
        });

        return await UserModel.find(query).select(query.select || USER_JSON);
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
