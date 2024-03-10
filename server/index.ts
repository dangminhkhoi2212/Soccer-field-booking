import express, { Request, Response, Application, NextFunction } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import sessions from 'express-session';

import db from './db';
import authRoute from './app/routes/auth.route';
import addressRoute from './app/routes/address.route';
import userRouter from './app/routes/user.route';
import fieldRoute from './app/routes/field.route';
import sellerRoute from './app/routes/seller.route';
import orderRoute from './app/routes/order.route';
dotenv.config();

const app: Application = express();
const PORT: number = Number(process.env.PROT) || 8000;

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// app.use(sessions());

app.use('/api/auth', authRoute);
app.use('/api/address', addressRoute);
app.use('/api/user', userRouter);
app.use('/api/field', fieldRoute);
app.use('/api/seller', sellerRoute);
app.use('/api/order', orderRoute);

//handle error
app.use((req: Request, res: Response, next: NextFunction) => {
    return res.status(404).json({ message: 'Resource not found' });
});
app.use((err: any, req: Request, res: Response, next: NextFunction) => {
    return res.status(err.status || 500).json({
        message: err || 'Internal Sever Error',
    });
});

const startApp = async () => {
    try {
        await db();
        app.listen(PORT, () => {
            console.log(`Server is running at port ${PORT}`);
        });
    } catch (error) {
        console.log(`Failed to listen on port ${PORT}`);
        console.log(error);
    }
};
startApp();
