import express, { Router } from 'express';
import FieldController from '../controllers/field.controller';
const router: Router = Router();

router.route('/all').get(FieldController.getSoccerField);
router
    .route('/')
    .get(FieldController.getOneSoccerFile)
    .post(FieldController.addField)
    .put(FieldController.updateField);
export default router;
