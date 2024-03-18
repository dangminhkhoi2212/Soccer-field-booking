import { Request, Response, query } from 'express';
import OrderService from '../services/order.service';
export interface TCreateOrder {
    userID: string;
    sellerID: string;
    startTime: string;
    endTime: string;

    date: string;
    total: number;
}
export interface TUpdateOrder {
    orderID: string;
    status: string;
}
export interface TGetAllOrder {
    userID: string;
    sellerID: string;
    date?: string;
    status?: string;
    sortBy?: string;
}
export interface TGetOneOrder {
    orderID: string;
}
export interface TGetOrderedTime {
    fieldID: string;
    date: string;
}
export interface TGetFieldOrdered {
    sellerID: string;
    date: string;
    startTime: string;
    endTime: string;
}
class OrderController {
    async createOrder(req: Request, res: Response) {
        try {
            const data: TCreateOrder = req.body;
            const result = await OrderService.createOrder(data);
            return res.send(result);
        } catch (error: any) {
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
            console.log('🚀 ~ OrderController ~ getAllOrder ~ query:', query);
            const result = await OrderService.getAllOrder(query);
            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message });
        }
    }
    async getOneOrder(req: Request, res: Response) {
        try {
            const query = req.query as unknown as TGetOneOrder;
            const result = await OrderService.getOneOrder(query);
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
    async getFieldOrdered(req: Request, res: Response) {
        try {
            const query = req.query as unknown as TGetFieldOrdered;
            const result = await OrderService.getFieldOrdered(query);
            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message });
        }
    }
}
export default OrderController;
