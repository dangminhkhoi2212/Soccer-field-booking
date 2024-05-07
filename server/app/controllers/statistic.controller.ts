import { Request, Response } from 'express';
import statisticService from '../services/statistic.service';
import mongooseUtil from '../utils/mongoose.util';
import fieldService from '../services/field.service';

interface TGetRevenue {
    sellerID: string;
    date?: string;
    month?: string;
    year?: string;
}

class StatisticController {
    private static instance: StatisticController;
    static getInstance() {
        if (!StatisticController.instance)
            StatisticController.instance = new StatisticController();
        return StatisticController.instance;
    }
    async getRevenue(req: Request, res: Response) {
        try {
            const query = req.query as unknown as TGetRevenue;
            const { date, sellerID, month, year } = query;
            console.log(
                '🚀 ~ StatisticController ~ getRevenue ~ query:',
                query
            );
            if (!sellerID)
                return res
                    .status(400)
                    .json({ err_mes: 'sellerID is required' });
            const validSellerID = mongooseUtil.createOjectID(sellerID);
            const result = await statisticService.getRevenue({
                sellerID: validSellerID,
                date,
                month,
                year,
            });
            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_msg: error.message || error });
        }
    }
    async getTotalFields(req: Request, res: Response) {
        try {
            const { userID } = req.query as { userID: string };
            const validUserID = mongooseUtil.createOjectID(userID);
            const [totalRevenue, totalFollow, totalField, totalOrder] =
                await Promise.all([
                    statisticService.getTotalRevenue(validUserID),
                    statisticService.getTotalFollow(validUserID),
                    fieldService.getFieldCount(validUserID),
                    statisticService.getTotalOrder(validUserID),
                ]);
            return res.send({
                totalRevenue,
                totalFollow,
                totalField,
                totalOrder,
            });
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_msg: error.message || error });
        }
    }
}
export default StatisticController.getInstance();
