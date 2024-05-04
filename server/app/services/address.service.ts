import mongoose, { ObjectId } from 'mongoose';
import AddressModel from '../models/address.model';
import { TOjectID } from '../utils/mongoose.util';
class AddressService {
    private static instance: AddressService;
    static getInstance() {
        if (!AddressService.instance) {
            AddressService.instance = new AddressService();
        }
        return AddressService.instance;
    }

    async updateAddress({
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
    async getAddress(query: {
        userID?: string;
        isInfo?: boolean;
    }): Promise<Array<any>> {
        const queryParams: any = {};
        if (query.userID)
            queryParams.userID = new mongoose.Types.ObjectId(query.userID);
        return await AddressModel.find(queryParams).populate(
            'userID',
            'name avatar'
        );
    }

    async getOneAddress(query: { userID: TOjectID }) {
        return await AddressModel.findOne({ userID: query.userID }).populate(
            'userID',
            'name avatar'
        );
    }
}
export default AddressService.getInstance();
