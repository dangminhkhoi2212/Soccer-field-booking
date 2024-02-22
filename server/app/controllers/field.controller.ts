import { Request, Response } from 'express';
import FieldService from '../services/field.service';
import { Query } from 'mongoose';

interface TAddFiled {
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

interface TGetField {
    userID: string;
    fieldID: string;
}

class FieldController {
    static async addField(req: Request, res: Response) {
        try {
            const body: TAddFiled = req.body as TAddFiled;
            const result = await FieldService.createField(body);
            res.send(result);
        } catch (error: any) {
            console.log('🚀 ~ FieldController ~ addField ~ error:', error);

            return res
                .status(error.status || 500)
                .json({ err_mes: error.message }); // Use error.message for clarity
        }
    }

    static async getSoccerField(req: Request, res: Response) {
        try {
            const query: TGetField = req.query as unknown as TGetField;
            const userID = query.userID;
            const fieldID = query.fieldID;

            const result = await FieldService.getSoccerField(query);
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message }); // Use error.message for clarity
        }
    }
}

export default FieldController;
