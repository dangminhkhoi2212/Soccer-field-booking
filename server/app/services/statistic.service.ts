import { PipelineStage } from 'mongoose';
import orderModel from '../models/order.model';
import { TOjectID } from '../utils/mongoose.util';
interface TGetRevenue {
    sellerID: TOjectID;
    date?: string;
    month?: string;
    year?: string;
}

class StatisticService {
    private static instance: StatisticService;
    static getInstance() {
        if (!this.instance) this.instance = new StatisticService();
        return this.instance;
    }
    async getRevenue(data: TGetRevenue) {
        const { date, month, year, sellerID } = data;
        let typeID;
        let result;
        const agg: PipelineStage[] = [];
        agg.push(
            {
                $lookup: {
                    from: 'fields',
                    localField: 'fieldID',
                    foreignField: '_id',
                    as: 'field',
                    pipeline: [
                        {
                            $project: {
                                userID: 1,
                                _id: 1,
                            },
                        },
                    ],
                },
            },
            { $unwind: '$field' },
            {
                $lookup: {
                    from: 'users',
                    localField: 'field.userID',
                    foreignField: '_id',
                    as: 'seller',
                    pipeline: [
                        {
                            $project: {
                                _id: 1,
                            },
                        },
                    ],
                },
            },
            { $unwind: '$seller' },
            {
                $match: {
                    $and: [{ 'seller._id': sellerID }, { status: 'ordered' }],
                },
            }
        );
        if (date) {
            typeID = 'hour';

            agg.push(
                {
                    $match: {
                        $expr: {
                            $eq: [
                                {
                                    $dateToString: {
                                        format: '%d-%m-%Y',
                                        date: '$date',
                                    },
                                },
                                date,
                            ],
                        },
                    },
                },
                {
                    $group: {
                        _id: { $hour: '$date' },
                        revenue: {
                            $sum: '$total',
                        },
                    },
                },
                {
                    $project: {
                        revenue: 1,
                        id: '$_id',
                        _id: 0,
                    },
                }
            );
        } else if (month) {
            typeID = 'date';

            agg.push(
                {
                    $match: {
                        $expr: {
                            $eq: [
                                {
                                    $dateToString: {
                                        format: '%m-%Y',
                                        date: '$date',
                                    },
                                },
                                month,
                            ],
                        },
                    },
                },
                {
                    $group: {
                        _id: { $dayOfMonth: '$date' },
                        revenue: {
                            $sum: '$total',
                        },
                    },
                },
                {
                    $project: {
                        revenue: 1,
                        id: '$_id',
                        _id: 0,
                    },
                }
            );
        } else if (year) {
            typeID = 'month';

            agg.push(
                {
                    $match: {
                        $expr: {
                            $eq: [
                                {
                                    $dateToString: {
                                        format: '%Y',
                                        date: '$date',
                                    },
                                },
                                year,
                            ],
                        },
                    },
                },

                {
                    $group: {
                        _id: { $month: '$date' },
                        revenue: {
                            $sum: '$total',
                        },
                    },
                },
                {
                    $project: {
                        revenue: 1,
                        id: '$_id',
                        _id: 0,
                    },
                }
            );
        }

        result = await orderModel.aggregate(agg);

        return { typeID, values: result };
    }
}
export default StatisticService.getInstance();
