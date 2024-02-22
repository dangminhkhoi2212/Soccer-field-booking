import mongoose, { ObjectId } from 'mongoose';
import AddressModel from '../models/address.model';
class AddressService {
    static async updateAddress({
        userID,
        latitude,
        longitude,
        province,
        district,
        ward,
        address,
    }: any) {
        const result = await AddressModel.findOneAndUpdate(
            { userID: new mongoose.Types.ObjectId(userID) },
            {
                userID: new mongoose.Types.ObjectId(userID),
                latitude,
                longitude,
                province,
                district,
                ward,
                address,
            },
            { new: true, upsert: true }
        );
        return result;
    }
    static async getAddress({ userID }: any) {
        return await AddressModel.findOne({
            userID: new mongoose.Types.ObjectId(userID),
        });
    }
}
export default AddressService;
