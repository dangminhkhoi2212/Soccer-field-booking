import { Request, Response } from 'express';
import SellerService from '../services/seller.service';

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
                .json({ msg: error.message || error });
        }
    }
    static async getSeller(req: Request, res: Response) {
        try {
            const params: any = req.query;
            if (params.isInfo) params.isInfo = params.isInfo == 'true';
            console.log('🚀 ~ SellerController ~ getSeller ~ params:', params);
            const result = await SellerService.getSeller(params);
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ msg: error.message || error });
        }
    }
    static async getOneSeller(req: Request, res: Response) {
        try {
            const params: any = req.query;
            if (params.isInfo) params.isInfo = params.isInfo == 'true';
            console.log('🚀 ~ SellerController ~ getSeller ~ params:', params);
            const result = await SellerService.getOneSeller(params);
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ msg: error.message || error });
        }
    }
}
export default SellerController;
