import { Request, Response } from 'express';
import feedbackService from '../services/feedback.service';
import MongooseUtil from '../utils/mongoose.util';
import { PipelineStage } from 'mongoose';
export interface TCreateFeedback {
    orderID: string;
    userID: string;
    images: string[];
    content: string;
    star: number;
}
export interface TGetFeedbacks {
    fieldID: string;
    star?: string;
    sortBy?: string;
    page?: string;
    limit?: string;
}
export interface TGetStatisticFeedbacks {
    fieldID?: string;
    userID?: string;
}
class FeedbackController {
    private static instance: FeedbackController;
    static getInstance(): FeedbackController {
        if (!FeedbackController.instance) {
            FeedbackController.instance = new FeedbackController();
        }
        return FeedbackController.instance;
    }
    async createFeedback(req: Request, res: Response) {
        try {
            const data = req.body as TCreateFeedback;

            const result = await feedbackService.createFeedback(data);
            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
    async getStatisticFeedback(req: Request, res: Response) {
        try {
            const { fieldID, userID } = req.query as TGetStatisticFeedbacks;
            if (!fieldID && !userID)
                return res
                    .status(400)
                    .json({ err_mes: 'fieldID or userID not found' });
            const result = await feedbackService.getStatisticFeedbacks({
                fieldID,
                userID,
            });
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
    async getFeedbacks(req: Request, res: Response) {
        try {
            const query = req.query as unknown as TGetFeedbacks;
            const { fieldID, sortBy } = query;
            const limit = query.limit ? parseInt(query.limit) : 30;
            const page = query.page ? parseInt(query.page) : 1;
            const star = query.star ? parseInt(query.star) : undefined;
            if (!fieldID)
                return res.status(400).json({ err_mes: 'fieldID is required' });
            const validFieldID = MongooseUtil.createOjectID(fieldID);
            const skip = (page - 1) * limit;

            const [result1, result2] = await Promise.all([
                feedbackService.getFeedbacks({
                    limit,
                    page,
                    sortBy,
                    star,
                    skip,
                    fieldID: validFieldID,
                }),
                feedbackService.getFeedbacks({
                    page,
                    sortBy,
                    star,
                    fieldID: validFieldID,
                }),
            ]);
            const pageCount = result2.length / limit;
            return res.send({
                pageCount: Math.ceil(pageCount),
                feedbacks: result1,
            });
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
}
export default FeedbackController.getInstance();
