import { Request, Response } from 'express';
import SellerService from '../services/seller.service';

interface TUpdateSeller {
    userID: string;
    startTime: string;
    endTime: string;
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
                body.endTime
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
            const params = req.query as { userID: string };
            console.log('🚀 ~ SellerController ~ getSeller ~ params:', params);
            const userID = params.userID;
            if (!userID)
                return res.status(404).json({ err_mes: 'userID not found' });
            const result = await SellerService.getSeller(userID);
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ msg: error.message || error });
        }
    }
}
export default SellerController;
