import { query, Request, Response } from 'express';
import SellerService from '../services/seller.service';
import fieldService from '../services/field.service';
import mongooseUtil from '../utils/mongoose.util';

interface TUpdateSeller {
    userID: string;
    startTime: string;
    endTime: string;
    isHalfHour: boolean;
}
export interface TGetSeller {
    sellerID?: string;
    userID?: string;
    isInfo?: string | false;
}
class SellerController {
    static async updateSeller(req: Request, res: Response) {
        try {
            const body = req.body as TUpdateSeller;
            console.log('🚀 ~ SellerController ~ updateSeller ~ body:', body);

            if (!body.userID)
                return res.status(401).json({ err_mes: 'userID not found' });
            const result = await SellerService.updateSeller(
                body.userID,
                body.startTime,
                body.endTime,
                body.isHalfHour
            );
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_msg: error.message || error });
        }
    }
    static async getSeller(req: Request, res: Response) {
        try {
            const params: any = req.query;
            if (params.isInfo) params.isInfo = params.isInfo == 'true';
            const userID = params.userID;
            if (!userID)
                return res.status(400).json({ err_mes: 'userID is required' });
            const validID = mongooseUtil.createOjectID(userID);
            params.userID = validID;
            const result = await SellerService.getSellers(params);
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_msg: error.message || error });
        }
    }
    static async getOneSeller(req: Request, res: Response) {
        try {
            const params: any = req.query;
            const userID = params.userID;
            if (!userID)
                return res.status(400).json({ err_mes: 'userID is required' });

            const validID = mongooseUtil.createOjectID(userID);

            const [result, fieldCount] = await Promise.all([
                SellerService.getOneSeller({ userID: validID }),
                fieldService.getFieldCount(validID),
            ]);
            res.send({ ...result?.toJSON(), fieldCount });
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_msg: error.message || error });
        }
    }
}
export default SellerController;
