import { Router } from 'express';
import statisticController from '../controllers/statistic.controller';

const router: Router = Router();

router.route('/total-fields').get(statisticController.getTotalFields);
router.route('/').get(statisticController.getRevenue);
export default router;
