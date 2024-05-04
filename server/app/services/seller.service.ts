import mongoose from 'mongoose';
import SellerModel from '../models/seller.model';
import 'dotenv/config';
import '../utils/mongoose.util';
import MongooseUtil, { TOjectID } from '../utils/mongoose.util';
const USER_JSON = '_id name avatar role';
class SellerService {
    private static instance: SellerService;
    static getInstance() {
        if (!this.instance) this.instance = new SellerService();
        return this.instance;
    }
    async updateSeller(
        userID: string,
        startTime: string,
        endTime: string,
        isHalfHour?: boolean
    ) {
        const validUserID = new mongoose.Types.ObjectId(userID);
        return await SellerModel.findOneAndUpdate(
            { userID: validUserID },
            { userID: validUserID, startTime, endTime, isHalfHour },
            { new: true, upsert: true }
        );
    }
    convertStringToProjectFields(fieldsString: string): any {
        const fields: any = {};

        fieldsString.split(' ').forEach((field) => {
            if (field.startsWith('-')) {
                // Exclude field if preceded by '-'
                const fieldName = field.substring(1);
                fields[fieldName] = 0;
            } else {
                // Include field otherwise
                fields[field] = 1;
            }
        });
        console.log(
            '🚀 ~ SellerService ~ fieldsString.split ~ fields:',
            fields
        );

        return fields;
    }
    async getSellers(params: any) {
        const pipeline = [];

        if (params.sellerID) {
            pipeline.push({
                $match: {
                    _id: MongooseUtil.createOjectID(params.sellerID),
                },
            });
        } else if (params.userID) {
            pipeline.push({
                $match: {
                    userID: MongooseUtil.createOjectID(params.userID),
                },
            });
        } else pipeline.push({ $match: {} });
        if (params.isInfo) {
            pipeline.push({
                $lookup: {
                    from: 'users',
                    localField: 'userID',
                    foreignField: '_id',
                    as: 'user',
                },
            });
            pipeline.push({
                $unwind: {
                    path: '$user',
                    preserveNullAndEmptyArrays: true,
                },
            });
            // pipeline.push({
            //     $addFields: {
            //         user: '$user', // Rename the populated field to user
            //     },
            // });
        }
        if (params.select)
            pipeline.push({
                $project: this.convertStringToProjectFields(params.select),
            });
        pipeline.push({
            $project: {
                _id: 1,
                startTime: 1,
                endTime: 1,
                isHalfHour: 1,
                'user._id': 1,
                'user.name': 1,
                'user.email': 1,
                'user.avatar': 1,
                'user.phone': 1,
                'user.role': 1,
                'user.isPublic': 1,
                'user.lock': 1,
            },
        });
        const result = await SellerModel.aggregate(pipeline);
        console.log('🚀 ~ SellerService ~ getSeller ~ pipeline:', pipeline);

        if (params.isInfo == false) {
            return result.map((doc) => {
                delete doc.user;
                return doc;
            });
        }
        const destructuredData = result.map((item) => {
            const result = { ...item, ...item.user };
            if (result.user) delete result.user;
            return result;
        });
        return result;
    }
    async getOneSeller(query: { userID: TOjectID }) {
        const { userID } = query;
        const result = await SellerModel.findOne({ userID });
        return result;
    }
}
export default SellerService.getInstance();
