import mongoose, { HydratedDocument, ObjectId } from 'mongoose';
import UserModel, { TUser } from '../models/user.model';
import 'dotenv/config';
import MongooseUtil from '../utils/mongoose.util';
import { TGetOneUser, TGetUsers } from '../controllers/user.controller';
import fieldService from './field.service';
import mongooseUtil from '../utils/mongoose.util';
const USER_JSON: string = process.env.USER_JSON?.toString() || '';

class UserService {
    static async getOneUser(params: TGetOneUser) {
        const query: any = params;
        Object.keys(query).forEach((key) => {
            if (!query[key]) delete query[key];
        });

        if (query.userID) {
            const userID = MongooseUtil.createOjectID(query.userID);
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
        let result = await UserModel.aggregate(aggregate);
        result = await Promise.all(
            result.map(async (user) => {
                user.fieldCount = await fieldService.getFieldCount(
                    mongooseUtil.createOjectID(user._id)
                );
                return user;
            })
        );
        return result;
    }
    static async updateUser({
        userID,
        name,
        email,
        phone,
        avatar,
    }: {
        userID: string;
        name: string;
        email: string;
        phone: string;
        avatar: string;
    }) {
        return await UserModel.findByIdAndUpdate(
            { _id: new mongoose.Types.ObjectId(userID) },
            { name, phone, avatar, email },
            { new: true }
        );
    }
}

export default UserService;
