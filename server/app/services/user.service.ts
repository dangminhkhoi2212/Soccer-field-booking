import mongoose, { HydratedDocument, ObjectId } from 'mongoose';
import UserModel, { TUser } from '../models/user.model';
import 'dotenv/config';
import MongooseUtil from '../utils/mongoose.util';
import SellerModel from '../models/seller.model';
import addressModel from '../models/address.model';
import { TGetOneUser, TGetUsers } from '../controllers/user.controller';
import { ROLE } from '../consts/user.const';
const USER_JSON: string = process.env.USER_JSON?.toString() || '';

const mongooseUtil = new MongooseUtil();
class UserService {
    static async getOneUser(params: TGetOneUser) {
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
    static async getUsers(params: TGetUsers) {
        const aggregate = [];

        if (params.textSearch) {
            aggregate.push({
                $search: {
                    index: 'search_user',
                    text: {
                        query: params.textSearch,
                        path: ['name', 'email', 'phone'],
                        fuzzy: { maxEdits: 1 },
                    },
                },
            });
        }
        aggregate.push({
            $match: {
                role: params.role ? params.role : 'user',
            },
        });
        aggregate.push({
            $project: {
                _id: 1,
                name: 1,
                email: 1,
                phone: 1,
                role: 1,
                avatar: 1,
                lock: 1,
                isPublic: 1,
            },
        });
        const result = await UserModel.aggregate(aggregate);
        return result;
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
