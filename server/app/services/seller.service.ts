import mongoose from 'mongoose';
import SellerModel from '../models/seller.model';
import 'dotenv/config';
import '../utils/mongoose.util';
import MongooseUtil from '../utils/mongoose.util';
import { TGetSeller } from '../controllers/seller.controller';
import { refreshToken } from 'firebase-admin/app';
import { query } from 'express';
const USER_JSON = '_id name avatar role';
const mongooseUtil = new MongooseUtil();
class SellerService {
    static async updateSeller(
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
    static convertStringToProjectFields(fieldsString: string): any {
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
    static async getSeller(params: any) {
        const mongooseUtil = new MongooseUtil();
        const pipeline = [];

        // Initialize the query object with isInfo parameter
        let query: any = { isInfo: params.isInfo ?? false };

        // If sellerID is provided, add $match stage to filter by sellerID
        if (params.sellerID) {
            pipeline.push({
                $match: {
                    _id: mongooseUtil.createOjectID(params.sellerID),
                },
            });
        }

        // If userID is provided, add $match stage to filter by userID
        else if (params.userID) {
            pipeline.push({
                $match: {
                    userID: mongooseUtil.createOjectID(params.userID),
                },
            });
        } else pipeline.push({ $match: {} });
        // If isInfo is true, add $lookup stage to populate userID
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
                $project: SellerService.convertStringToProjectFields(
                    params.select
                ),
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
        // Execute the aggregation pipeline
        const result = await SellerModel.aggregate(pipeline);
        console.log('🚀 ~ SellerService ~ getSeller ~ pipeline:', pipeline);

        // If isInfo is true, map the result to remove the 'user' field from each document
        if (params.isInfo == false) {
            return result.map((doc) => {
                delete doc.user;
                return doc;
            });
        }
        const destructuredData = result.map((item) => {
            // Destructure user field and rest of the fields
            const result = { ...item, ...item.user };
            if (result.user) delete result.user;
            return result; // Return user and rest of the fields as separate objects
        });
        return result;
    }
    static async getOneSeller(query: { userID: string }) {
        const userID = mongooseUtil.createOjectID(query.userID);
        const result = await SellerModel.findOne({ userID });
        return result;
    }
}
export default SellerService;
