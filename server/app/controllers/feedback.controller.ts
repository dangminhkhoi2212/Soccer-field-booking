import { Request, Response } from 'express';
import feedbackService from '../services/feedback.service';
import MongooseUtil from '../utils/mongoose.util';
const mongooseUtil = new MongooseUtil();
export interface TCreateFeedback {
    orderID: string;
    fieldID: string;
    sellerID: string;
    images: string[];
    content: string;
    star: number;
}
export interface TGetFeedbacks {
    fieldID: string;
    star?: number;
    sortBy?: string;
    page?: number;
    limit?: number;
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
    async getFeedbacks(req: Request, res: Response) {
        try {
            const query = req.query as unknown as TGetFeedbacks;
            const { fieldID, limit = 30, page = 1, sortBy, star } = query;
            const validFieldID = mongooseUtil.createOjectID(fieldID);
            const match: any = { fieldID: validFieldID };
            const sort: any = {};

            const skip = (page - 1) * limit;

            if (star) {
                match.star = star;
            }
            switch (sortBy) {
                case 'newest':
                    sort._id = -1;
            }

            const [result1, result2] = await Promise.all([
                feedbackService.getFeedbacks({
                    skip,
                    sort,
                    limit,
                    match,
                }),
                feedbackService.getFeedbacks({
                    skip,
                    sort,
                    match,
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
