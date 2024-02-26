import express, { Router } from 'express';
import FieldController from '../controllers/field.controller';
const router: Router = Router();

router
    .route('/')
    .get(FieldController.getSoccerField)
    .post(FieldController.addField)
    .put(FieldController.updateField);
export default router;
