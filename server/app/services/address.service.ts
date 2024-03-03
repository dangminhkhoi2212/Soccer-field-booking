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
    static async getAddress(query: { userID?: string; isInfo?: boolean }) {
        const queryParams: any = {};
        if (query.userID)
            queryParams.userID = new mongoose.Types.ObjectId(query.userID);
        return await AddressModel.find(queryParams).populate(
            'userID',
            'name avatar'
        );
    }
}
export default AddressService;
