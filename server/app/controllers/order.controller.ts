import { Request, Response, query } from 'express';
import OrderService from '../services/order.service';
import mongooseUtil, { TOjectID } from '../utils/mongoose.util';
export interface TCreateOrder {
    userID: string;
    startTime: Date;
    endTime: Date;
    date: Date;
    total: number;
}
export interface TUpdateOrder {
    orderID: string;
    status: string;
}
export interface TGetAllOrder {
    userID?: string;
    sellerID?: string;
    date?: string;
    status?: string;
    sortBy?: string;
}
export interface TGetOneOrder {
    orderID: string;
    userID: string;
}
export interface TGetOrderedTime {
    fieldID: string;
    date: string;
}
export interface TGetFieldOrdered {
    sellerID: string;
    date: Date;
    startTime: Date;
    endTime: Date;
}
class OrderController {
    async createOrder(req: Request, res: Response) {
        try {
            const data: TCreateOrder = req.body;
            console.log('🚀 ~ OrderController ~ createOrder ~ data:', data);
            const result = await OrderService.createOrder(data);
            return res.send(result);
        } catch (error: any) {
            console.log('🚀 ~ OrderController ~ createOrder ~ error:', error);
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message });
        }
    }
    async updateOrder(req: Request, res: Response) {
        try {
            const data: TUpdateOrder = req.body;
            const result = await OrderService.updateStatusOrder(data);
            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message });
        }
    }
    async getAllOrder(req: Request, res: Response) {
        try {
            const query = req.query as unknown as TGetAllOrder;
            const { date, sellerID, sortBy, status, userID } = query;
            if (!sellerID && !userID) {
                return res
                    .status(400)
                    .json({ err_mes: 'userID or sellerID is required' });
            }
            const validUserID = userID
                ? mongooseUtil.createOjectID(userID)
                : undefined;
            const validSellerID = sellerID
                ? mongooseUtil.createOjectID(sellerID)
                : undefined;

            console.log('🚀 ~ OrderController ~ getAllOrder ~ query:', query);
            const result = await OrderService.getAllOrder({
                date,
                sellerID: validSellerID,
                userID: validUserID,
                sortBy,
                status,
            });
            return res.send(result);
        } catch (error: any) {
            console.log('🚀 ~ OrderController ~ getAllOrder ~ error:', error);
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
    async getOneOrder(req: Request, res: Response) {
        try {
            const query = req.query as unknown as TGetOneOrder;
            console.log('🚀 ~ OrderController ~ getOneOrder ~ query:', query);
            const { orderID, userID } = query;
            if (!orderID || !userID)
                return res
                    .status(400)
                    .json({ err_mes: 'orderID or userID not found' });

            const validOrderID: TOjectID = mongooseUtil.createOjectID(orderID);
            const validUserID: TOjectID = mongooseUtil.createOjectID(userID);

            const result = await OrderService.getOneOrder({
                orderID: validOrderID,
                userID: validUserID,
            });
            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message });
        }
    }
    async getOrderedTime(req: Request, res: Response) {
        try {
            const query = req.query as unknown as TGetOrderedTime;
            console.log(
                '🚀 ~ OrderController ~ getOrderedTime ~ query:',
                query
            );
            const result = await OrderService.getOrderedTime(query);
            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message });
        }
    }
    async getOrderedField(req: Request, res: Response) {
        try {
            const query = req.query as unknown as TGetFieldOrdered;
            const result = await OrderService.getOrderedField(query);
            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message });
        }
    }
}
export default OrderController;
