import {
    TCreateFeedback,
    TGetFeedbacks,
} from './../controllers/feedback.controller';
import feedbackModel from '../models/feedback.model';

interface TGetFeedbacksService {
    skip: number;
    match: {};
    sort: {};
    limit?: number;
}
class FeedbackService {
    private static instance: FeedbackService;
    static getInstance(): FeedbackService {
        if (!FeedbackService.instance)
            FeedbackService.instance = new FeedbackService();
        return FeedbackService.instance;
    }

    async createFeedback(data: TCreateFeedback) {
        const result = await feedbackModel.create(data);
        return result;
    }
    async getLengthFeedback(fieldID: string) {
        return (await feedbackModel.find({ fieldID }).lean()).length;
    }
    async getFeedbacks(query: TGetFeedbacksService) {
        const { skip, limit = 30, sort, match } = query;
        const result = await feedbackModel
            .find(match)
            .limit(limit)
            .sort(sort)
            .skip(skip)
            .populate('userID', 'name avatar');
        return result;
    }
}
export default FeedbackService.getInstance();
