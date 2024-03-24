import { Request, Response } from 'express';
import FieldService from '../services/field.service';
import { Query } from 'mongoose';
import mongooseUtil, { TOjectID } from '../utils/mongoose.util';
import feedbackService from '../services/feedback.service';

interface TAddField {
    userID: string;
    coverImage: string;
    name: string;
    type: number;
    width: number;
    height: number;
    description: string;
    isLock: boolean;
    fieldID?: string;
    isRepair: boolean;
}
interface TUpdateField extends TAddField {
    fieldID: string;
}

interface TGetField {
    userID: string;
    fieldID: string;
}

class FieldController {
    static async addField(req: Request, res: Response) {
        try {
            const body: TAddField = req.body as TAddField;
            const result = await FieldService.createField(body);
            res.send(result);
        } catch (error: any) {
            console.log('🚀 ~ FieldController ~ addField ~ error:', error);

            return res
                .status(error.status || 500)
                .json({ err_mes: error.message }); // Use error.message for clarity
        }
    }
    static async updateField(req: Request, res: Response) {
        try {
            const body: TUpdateField = req.body as TUpdateField;
            const result = await FieldService.updateField(body);
            res.send(result);
        } catch (error: any) {
            console.log('🚀 ~ FieldController ~ addField ~ error:', error);

            return res
                .status(error.status || 500)
                .json({ err_mes: error.message }); // Use error.message for clarity
        }
    }
    static async getSoccerFields(req: Request, res: Response) {
        try {
            const query: TGetField = req.query as unknown as TGetField;
            const userID = query.userID;
            if (!userID)
                return res.status(400).json({ err_mes: 'userID not found' });
            const validUserID = mongooseUtil.createOjectID(userID);
            const fields = await FieldService.getSoccerFields({
                userID: validUserID,
            });
            const mapAPI = fields.map((field) =>
                feedbackService.getAvgStar(field._id as TOjectID)
            );

            const starAvg = await Promise.all(mapAPI);
            const result: any = [];
            for (let i = 0; i < fields.length; i++) {
                result.push({
                    ...fields[i].toJSON(),
                    ...{ avgStar: starAvg[i].avgStar },
                });
            }
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message }); // Use error.message for clarity
        }
    }
    static async getOneSoccerFile(req: Request, res: Response) {
        try {
            const query = req.query as { fieldID: string };
            if (!query.fieldID)
                return res.status(400).json({ err_mes: 'fieldID not found' });
            const result = await FieldService.getOneSoccerField(query);
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message }); // Use error.message for clarity
        }
    }
}

export default FieldController;
