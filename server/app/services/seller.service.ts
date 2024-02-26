import mongoose from 'mongoose';
import SellerModel from '../models/seller.model';
import 'dotenv/config';
import '../utils/mongoose.util';
import MongooseUtil from '../utils/mongoose.util';
import { TGetSeller } from '../controllers/seller.controller';
const USER_JSON = '_id name avatar role';
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
    static async getSeller(params: TGetSeller) {
        const mongooseUtil = new MongooseUtil();
        let query: any = { isInfo: params.isInfo ?? false };

        if (params.sellerID) {
            query._id = mongooseUtil.createOjectID(params.sellerID);
        }
        if (params.userID) {
            query.userID = mongooseUtil.createOjectID(params.userID);
        }

        // Find sellers based on the query
        if (params.isInfo)
            return await SellerModel.find(query).populate('userID', USER_JSON);
        return await SellerModel.find(query);
    }
}
export default SellerService;
