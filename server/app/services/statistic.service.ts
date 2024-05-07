import { PipelineStage } from 'mongoose';
import orderModel from '../models/order.model';
import { TOjectID } from '../utils/mongoose.util';
import Favorite from '../models/favorite.model';
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
        agg.push({
            $sort: {
                id: 1,
            },
        });
        result = await orderModel.aggregate(agg);

        return { typeID, values: result };
    }
    async getTotalRevenue(userID: TOjectID) {
        const agg: PipelineStage[] = [
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
            {
                $unwind: '$field',
            },
            {
                $match: {
                    'field.userID': userID,
                },
            },
            {
                $group: {
                    _id: '$field.userID',
                    totalRevenue: { $sum: '$total' },
                },
            },

            {
                $project: {
                    totalRevenue: 1,
                },
            },
        ];

        const result = await orderModel.aggregate(agg);
        return (result.length != 0 && result[0].totalRevenue) || 0;
    }
    async getTotalFollow(userID: TOjectID) {
        const result = await Favorite.countDocuments({
            favorites: {
                $in: userID,
            },
        });
        return result ?? 0;
    }
    async getTotalOrder(userID: TOjectID) {
        const agg: PipelineStage[] = [
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
            {
                $unwind: '$field',
            },
            {
                $match: {
                    'field.userID': userID,
                },
            },
            {
                $group: {
                    _id: '$field.userID',
                    totalOrder: { $sum: 1 },
                },
            },

            {
                $project: {
                    totalOrder: 1,
                },
            },
        ];

        const result = await orderModel.aggregate(agg);
        return (result.length !== 0 && result[0].totalOrder) || 0;
    }
}
export default StatisticService.getInstance();
