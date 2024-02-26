import mongoose from 'mongoose';
import FieldModel from '../models/field.model';

class FieldService {
    static async createField(fieldData: {
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
    static async updateField(fieldData: {
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
    static async getSoccerField(data: { userID?: string; fieldID?: string }) {
        return await FieldModel.find({
            $or: [
                {
                    userID: data.userID
                        ? new mongoose.Types.ObjectId(data.userID)
                        : null,
                },
                {
                    _id: data.fieldID
                        ? new mongoose.Types.ObjectId(data.fieldID)
                        : null,
                },
            ],
        });
    }
}
export default FieldService;
