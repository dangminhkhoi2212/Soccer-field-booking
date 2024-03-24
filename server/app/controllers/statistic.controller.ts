import { Request, Response } from 'express';
import statisticService from '../services/statistic.service';

export interface TGetRevenue {
    date?: string;
    month?: number;
    year?: number;
}
class StatisticController {
    private static instance: StatisticController;
    static getInstance() {
        if (!this.instance) this.instance = new StatisticController();
        return this.instance;
    }
    async getRevenue(req: Request, res: Response) {
        try {
            const query = req.query as unknown as TGetRevenue;
            const { date, month, year } = query;
            const result = await statisticService.getRevenue({
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
}
export default StatisticController.getInstance();
