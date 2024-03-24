import { query, Application } from 'express';
import {
    TCreateFeedback,
    TGetFeedbacks,
    TGetStatisticFeedbacks,
} from './../controllers/feedback.controller';
import FeedbackModel from '../models/feedback.model';
import MongooseUtil, { TOjectID } from '../utils/mongoose.util';
import TokenService1 from '../services/token.service';
import TokenService2 from '../services/token.service';
import fieldModel from '../models/field.model';
import { PipelineStage } from 'mongoose';
interface TGetFeedbacksService {
    skip?: number;
    page?: number;
    fieldID: TOjectID;
    sortBy?: string;
    star?: number;
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
        const result = await FeedbackModel.create(data);
        return result;
    }
    async getLengthFeedback(fieldID: string) {
        return (await FeedbackModel.find({ fieldID }).lean()).length;
    }
    async isFeedback(query: { userID: TOjectID; orderID: TOjectID }) {
        const { userID, orderID } = query;
        const result = await FeedbackModel.findOne({ userID, orderID });
        return result != null;
    }
    async getFeedbacks(query: TGetFeedbacksService) {
        const { limit, fieldID, page = 1, star, sortBy, skip } = query;
        const agg: PipelineStage[] = [];
        agg.push(
            {
                $lookup: {
                    from: 'orders',
                    localField: 'orderID',
                    foreignField: '_id',
                    as: 'order',
                },
            },
            { $unwind: '$order' },
            {
                $lookup: {
                    from: 'users',
                    localField: 'userID',
                    foreignField: '_id',
                    as: 'user',
                    pipeline: [{ $project: { name: 1, avatar: 1 } }],
                },
            },
            { $unwind: '$user' },
            { $match: { 'order.fieldID': fieldID } },
            { $project: { order: 0 } }
        );

        if (star) {
            agg.push({
                $match: { star },
            });
        }
        switch (sortBy) {
            case 'newest':
                agg.push({ $sort: { _id: -1 } });
                break;
        }
        if (skip) {
            agg.push({ $skip: skip });
        }
        if (limit) {
            agg.push({ $limit: limit });
        }
        const result = await FeedbackModel.aggregate(agg);
        console.log('🚀 ~ FeedbackService ~ getFeedbacks ~ agg:', agg);
        return result;
    }
    async getStatisticFeedbacks(query: TGetStatisticFeedbacks) {
        const { userID, fieldID } = query;
        let validFieldID = fieldID && MongooseUtil.createOjectID(fieldID);
        let validUserID = userID && MongooseUtil.createOjectID(userID);

        const agg: PipelineStage[] = [];
        agg.push(
            {
                $lookup: {
                    from: 'orders',
                    localField: 'orderID',
                    foreignField: '_id',
                    as: 'order',
                },
            },
            { $unwind: '$order' },
            {
                $match: {
                    ...(userID && { userID: validUserID }),
                    ...(fieldID && { 'order.fieldID': validFieldID }),
                },
            },
            {
                $group: {
                    _id: null,
                    oneStar: { $sum: { $cond: [{ $eq: ['$star', 1] }, 1, 0] } },
                    twoStar: { $sum: { $cond: [{ $eq: ['$star', 2] }, 1, 0] } },
                    threeStar: {
                        $sum: { $cond: [{ $eq: ['$star', 3] }, 1, 0] },
                    },
                    fourStar: {
                        $sum: { $cond: [{ $eq: ['$star', 4] }, 1, 0] },
                    },
                    fiveStar: {
                        $sum: { $cond: [{ $eq: ['$star', 5] }, 1, 0] },
                    },
                    ratingStar: { $sum: '$star' },
                    totalFeedback: { $sum: 1 },
                },
            },
            {
                $project: {
                    _id: 0,
                    oneStar: 1,
                    twoStar: 1,
                    threeStar: 1,
                    fourStar: 1,
                    fiveStar: 1,
                    ratingStar: 1,
                    totalFeedback: 1,
                },
            }
        );
        let result: any = await FeedbackModel.aggregate(agg);
        result = result.length ? result[0] : {};

        if (result.totalFeedback) {
            result.ratingStar /= result.totalFeedback;
            result.ratingStar = parseFloat(result.ratingStar.toFixed(2));
        } else {
            result.ratingStar = 0;
        }

        return result;
    }
    async getAvgStar(fieldID: TOjectID) {
        const result = await FeedbackModel.aggregate([
            {
                $lookup: {
                    from: 'orders',
                    localField: 'orderID',
                    foreignField: '_id',
                    as: 'order',
                },
            },
            { $unwind: '$order' },
            {
                $match: {
                    'order.fieldID': fieldID,
                },
            },
            {
                $group: {
                    _id: '$fieldID',
                    avgStar: {
                        $avg: '$star',
                    },
                },
            },
            {
                $project: {
                    avgStar: 1,
                    _id: 0,
                },
            },
        ]);
        return result![0] ?? { avgStar: 0 };
    }
}
export default FeedbackService.getInstance();
