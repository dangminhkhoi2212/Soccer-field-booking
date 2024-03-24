import { Router } from 'express';
import feedbackController from '../controllers/feedback.controller';

const router: Router = Router();
router.route('/statistic').get(feedbackController.getStatisticFeedback);
router
    .route('/')
    .post(feedbackController.createFeedback)
    .get(feedbackController.getFeedbacks);
export default router;
