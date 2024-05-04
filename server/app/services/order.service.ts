import { PipelineStage } from 'mongoose';
import {
    TCreateOrder,
    TGetFieldOrdered,
    TGetOrderedTime,
    TUpdateOrder,
} from '../controllers/order.controller';
import OrderModel from '../models/order.model';
import MongooseUtil, { TOjectID } from '../utils/mongoose.util';
import FeedbackService from './feedback.service';
interface TGetAllOrder {
    userID?: TOjectID;
    sellerID?: TOjectID;
    date?: string;
    status?: string;
    sortBy?: string;
}
class OrderService {
    private static instance: OrderService;
    static getInstance() {
        if (!this.instance) {
            this.instance = new OrderService();
        }
        return this.instance;
    }
    async createOrder(data: TCreateOrder) {
        const result = await OrderModel.create(data);
        return result;
    }
    async updateStatusOrder(data: TUpdateOrder) {
        const result = await OrderModel.findByIdAndUpdate(
            data.orderID,
            { status: data.status },
            { new: true }
        );
        return result;
    }
    async getAllOrder(query: TGetAllOrder) {
        const { sellerID, userID, date, status, sortBy } = query;

        const aggPipeline: PipelineStage[] = [];
        let sortStage: PipelineStage | undefined = undefined;
        aggPipeline.push(
            {
                $lookup: {
                    from: 'fields',
                    localField: 'fieldID',
                    foreignField: '_id',
                    as: 'field',
                    pipeline: [
                        {
                            $project: {
                                name: 1,
                                coverImage: 1,
                                userID: 1,
                            },
                        },
                    ],
                },
            },
            {
                $lookup: {
                    from: 'users',
                    localField: 'userID',
                    foreignField: '_id',
                    as: 'user',
                    pipeline: [
                        {
                            $project: {
                                name: 1,
                                email: 1,
                                phone: 1,
                                avatar: 1,
                            },
                        },
                    ],
                },
            },
            {
                $lookup: {
                    from: 'users',
                    localField: 'userID',
                    foreignField: '_id',
                    as: 'seller',
                    pipeline: [
                        {
                            $project: {
                                name: 1,
                                email: 1,
                                phone: 1,
                                avatar: 1,
                            },
                        },
                    ],
                },
            },
            { $unwind: '$field' },
            { $unwind: '$user' },
            { $unwind: '$seller' }
        );
        if (sellerID) {
            aggPipeline.push(
                { $match: { 'field.userID': sellerID } },
                {
                    $project: {
                        userID: 0,
                        fieldID: 0,
                    },
                }
            );
        } else {
            aggPipeline.push({ $match: { userID: userID } });
        }

        if (date) {
            aggPipeline.push({
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
            });
        }

        if (status) {
            aggPipeline.push({ $match: { status: status } });
        }

        switch (sortBy) {
            case 'time_asc':
                sortStage = { $sort: { startTime: 1 } };
                break;
            case 'time_desc':
                sortStage = { $sort: { startTime: -1 } };
                break;
            case 'total_asc':
                sortStage = { $sort: { total: 1 } };
                break;
            case 'total_desc':
                sortStage = { $sort: { total: -1 } };
                break;
        }
        if (sortBy && sortStage) aggPipeline.push(sortStage);

        const result = await OrderModel.aggregate(aggPipeline).exec();

        return result;
    }

    async getOneOrder(query: { userID: TOjectID; orderID: TOjectID }) {
        const { userID, orderID } = query;

        const agg: PipelineStage[] = [];
        agg.push(
            {
                $match: {
                    _id: orderID,
                },
            },
            {
                $lookup: {
                    from: 'users',
                    localField: 'userID',
                    foreignField: '_id',
                    as: 'user',
                    pipeline: [
                        {
                            $project: {
                                name: 1,
                                email: 1,
                                phone: 1,
                                avatar: 1,
                            },
                        },
                    ],
                },
            },
            { $unwind: '$user' },
            {
                $lookup: {
                    from: 'fields',
                    localField: 'fieldID',
                    foreignField: '_id',
                    as: 'field',
                    pipeline: [
                        {
                            $project: {
                                name: 1,
                                coverImage: 1,
                                userID: 1,
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
                                name: 1,
                                email: 1,
                                phone: 1,
                                avatar: 1,
                            },
                        },
                    ],
                },
            },
            { $unwind: '$seller' },
            {
                $project: {
                    userID: 0,
                    fieldID: 0,
                },
            }
        );
        const [result, isFeedback] = await Promise.all([
            OrderModel.aggregate(agg),
            FeedbackService.isFeedback({ userID, orderID }),
        ]);
        return { ...result[0], isFeedback };
    }

    async getOrderedTime(query: TGetOrderedTime) {
        const fieldID = MongooseUtil.createOjectID(query.fieldID);
        const result = await OrderModel.aggregate([
            {
                $match: {
                    $and: [
                        {
                            fieldID: fieldID,
                        },
                        {
                            $expr: {
                                $eq: [
                                    {
                                        $dateToString: {
                                            format: '%d-%m-%Y',
                                            date: '$date',
                                        },
                                    },
                                    query.date,
                                ],
                            },
                        },
                    ],
                },
            },
            {
                $group: {
                    _id: {
                        date: {
                            $dateToString: {
                                format: '%d-%m-%Y',
                                date: '$date',
                            },
                        },
                    },
                    times: {
                        $push: {
                            startTime: '$startTime',
                            endTime: '$endTime',
                        },
                    },
                },
            },
            {
                $project: {
                    _id: 0,
                    date: '$_id.date',
                    times: 1,
                },
            },
        ]);
        if (result.length == 1) return result[0];
        return {};
    }
    async getOrderedField(query: TGetFieldOrdered) {
        const sellerID = MongooseUtil.createOjectID(query.sellerID);
        // var startTimeParts = query.startTime.split(':');
        // var startTimeDate = new Date();
        // startTimeDate.setHours(parseInt(startTimeParts[0]));
        // startTimeDate.setMinutes(parseInt(startTimeParts[1]));

        // var endTimeParts = query.endTime.split(':');
        // var endTimeDate = new Date();
        // endTimeDate.setHours(parseInt(endTimeParts[0]));
        // endTimeDate.setMinutes(parseInt(endTimeParts[1]));
        const result = await OrderModel.find({
            $and: [
                { sellerID },
                { date: query.date },

                { startTime: { $gte: query.startTime } },
                { endTime: { $lte: query.endTime } },
            ],
        });
        return result;
    }
}
export default OrderService.getInstance();
