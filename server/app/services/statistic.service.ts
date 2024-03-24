import { TGetRevenue } from '../controllers/statistic.controller';
import orderModel from '../models/order.model';

class StatisticService {
    private static instance: StatisticService;
    static getInstance() {
        if (!this.instance) this.instance = new StatisticService();
        return this.instance;
    }
    async getRevenue(data: TGetRevenue) {
        const { date, month, year } = data;
        const agg = [];
        if (date) {
            const parsedDateInput = new Date(date);
            const isoDateString = parsedDateInput.toISOString();
            agg.push({
                $addFields: {
                    dateParse: { $toDate: '$date' },
                },
            });
            agg.push({
                $match: {
                    dateParse: isoDateString,
                },
            });
            agg.push({
                $group: {
                    _id: '$date',
                    total: { $sum: '$total' },
                },
            });
        }
        const result = await orderModel.aggregate(agg);
        return result;
    }
}
export default StatisticService.getInstance();
