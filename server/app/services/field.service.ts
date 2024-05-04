import mongoose from 'mongoose';
import FieldModel from '../models/field.model';
import MongooseUtil, { TOjectID } from '../utils/mongoose.util';
class FieldService {
    private static instance: FieldService;
    static getInstance() {
        if (!this.instance) this.instance = new FieldService();
        return this.instance;
    }
    async createField(fieldData: {
        userID: string;
        coverImage: string;
        name: string;
        type: number;
        width: number;
        height: number;
        description: string;
        isLock: boolean;
        isRepair: boolean;
    }) {
        return await FieldModel.create({
            ...fieldData,
            userID: new mongoose.Types.ObjectId(fieldData.userID),
        });
    }
    async updateField(fieldData: {
        userID: string;
        coverImage: string;
        name: string;
        type: number;
        width: number;
        height: number;
        description: string;
        isLock: boolean;
        isRepair: boolean;
        fieldID: string;
    }) {
        return await FieldModel.findByIdAndUpdate(
            fieldData.fieldID,
            {
                ...fieldData,
                userID: new mongoose.Types.ObjectId(fieldData.userID),
            },
            {
                upsert: true,
                new: true,
            }
        );
    }
    async getSoccerFields(data: { userID: TOjectID }) {
        const { userID } = data;
        return await FieldModel.find({ userID });
    }
    async getOneSoccerField(data: { fieldID: string }) {
        const fieldID = MongooseUtil.createOjectID(data.fieldID);
        return await FieldModel.findOne({ _id: fieldID });
    }
    async getFieldCount(userID: TOjectID) {
        return FieldModel.countDocuments({ userID });
    }
}
export default FieldService.getInstance();
