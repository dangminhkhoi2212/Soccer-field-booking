import mongoose from 'mongoose';
import SellerModel from '../models/seller.model';
class SellerService {
    static async updateSeller(
        userID: string,
        startTime: string,
        endTime: string
    ) {
        const validUserID = new mongoose.Types.ObjectId(userID);
        return await SellerModel.findOneAndUpdate(
            { userID: validUserID },
            { userID: validUserID, startTime, endTime },
            { new: true, upsert: true }
        );
    }
    static async getSeller(userID: string) {
        return await SellerModel.findOne({
            userID: new mongoose.Types.ObjectId(userID),
        });
    }
}
export default SellerService;
