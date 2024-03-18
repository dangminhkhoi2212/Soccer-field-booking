import { query } from 'express';
import {
    TCreateOrder,
    TGetAllOrder,
    TGetFieldOrdered,
    TGetOneOrder,
    TGetOrderedTime,
    TUpdateOrder,
} from '../controllers/order.controller';
import OrderModel from '../models/order.model';
import MongooseUtil from '../utils/mongoose.util';
const mongooseUtil = new MongooseUtil();
class OrderService {
    static async createOrder(data: TCreateOrder) {
        const result = await OrderModel.create(data);
        return result;
    }
    static async updateStatusOrder(data: TUpdateOrder) {
        const result = await OrderModel.findByIdAndUpdate(
            data.orderID,
            { status: data.status },
            { new: true }
        );
        return result;
    }
    static async getAllOrder(query: TGetAllOrder) {
        const { sellerID, userID, date, status, sortBy } = query;

        let newQuery: any = {};
        let sort: any = {};
        if (sellerID && userID) {
            newQuery = {
                $and: [{ sellerID: sellerID }, { userID: userID }],
            };
        } else if (sellerID) {
            newQuery.sellerID = sellerID;
        } else {
            newQuery.userID = userID;
        }

        if (date) {
            newQuery.date = date;
        }
        if (status) {
            newQuery.status = status;
        }
        switch (sortBy) {
            case 'time_asc':
                sort.startTime = 1;
                break;
            case 'time_desc':
                sort.startTime = -1;
                break;
            case 'total_asc':
                sort.total = 1;
                break;
            case 'total_desc':
                sort.total = -1;
                break;
        }

        console.log('🚀 ~ OrderService ~ getAllOrder ~ newQuery:', newQuery);
        const result = await OrderModel.find(newQuery)
            .populate('userID', 'name email phone avatar')
            .populate('sellerID', 'name email phone avatar')
            .populate('fieldID', 'name coverImage')
            .sort(sort);
        return result;
    }
    static async getOneOrder(query: TGetOneOrder) {
        const result = await OrderModel.findById(query.orderID)
            .populate('userID', 'name email phone avatar')
            .populate('sellerID', 'name email phone avatar')
            .populate('fieldID', 'name coverImage');
        return result;
    }
    static async getOrderedTime(query: TGetOrderedTime) {
        const fieldID = mongooseUtil.createOjectID(query.fieldID);
        const result = await OrderModel.aggregate([
            {
                $match: {
                    $and: [
                        {
                            fieldID: fieldID,
                        },
                        { date: query.date },
                    ],
                },
            },
            {
                $group: {
                    _id: { date: '$date' },
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
    static async getFieldOrdered(query: TGetFieldOrdered) {
        const sellerID = mongooseUtil.createOjectID(query.sellerID);
        var startTimeParts = query.startTime.split(':');
        var startTimeDate = new Date();
        startTimeDate.setHours(parseInt(startTimeParts[0]));
        startTimeDate.setMinutes(parseInt(startTimeParts[1]));

        var endTimeParts = query.endTime.split(':');
        var endTimeDate = new Date();
        endTimeDate.setHours(parseInt(endTimeParts[0]));
        endTimeDate.setMinutes(parseInt(endTimeParts[1]));
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
export default OrderService;
