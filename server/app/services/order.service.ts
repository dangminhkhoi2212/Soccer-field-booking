import { query } from 'express';
import {
    TCreateOrder,
    TGetAllOrder,
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
        let newQuery: any = {};
        if (query.sellerID && query.userID)
            newQuery = {
                $and: [{ sellerID: query.sellerID }, { userID: query.userID }],
            };
        else if (query.sellerID) {
            newQuery.sellerID = query.sellerID;
        } else {
            newQuery.userID = query.userID;
        }
        const result = await OrderModel.find(newQuery)
            .populate('userID', 'name email phone avatar')
            .populate('sellerID', 'name email phone avatar')
            .populate('fieldID', 'name coverImage');
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
        return result;
    }
}
export default OrderService;
