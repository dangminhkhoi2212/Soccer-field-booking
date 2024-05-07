import { CustomRequest } from './../middlewares/token.middleware';
import { Request, Response } from 'express';
import UserService from '../services/user.service';
import mongoose, { ObjectId } from 'mongoose';
import userModel from '../models/user.model';
import bcrypt from 'bcrypt';
const BCRYPT_SECRET = Number.parseInt(process.env.BCRYPT_SECRET || '10');
export interface TGetUsers {
    textSearch?: string;
    role?: string;
}
export interface TGetOneUser {
    userID?: string;
    email?: string;
    phone?: string;
}

class UserController {
    private static instance: UserController;
    static getInstance() {
        if (!UserController.instance)
            UserController.instance = new UserController();
        return UserController.instance;
    }
    async updateUser(req: Request, res: Response) {
        try {
            const body = req.body;
            const userID: string = body.userID;

            const name: string = body.name;
            const phone: string = body.phone;
            const avatar: string = body.avatar;
            const email: string = body.email;

            if (!userID)
                return res.status(400).json({ err_mes: 'userID not found' });

            const user: any = await userModel.findById(userID);
            if (!user)
                return res.status(400).json({ err_mes: 'user not found' });
            if (phone !== user.phone) {
                const checkPhone = await userModel.findOne({ phone });

                if (checkPhone) {
                    return res
                        .status(400)
                        .json({ err_mes: 'Phone was existed.' });
                }
            }
            if (email !== user.email) {
                const checkEmail = await userModel.findOne({ email });

                if (checkEmail) {
                    return res
                        .status(400)
                        .json({ err_mes: 'Email was existed.' });
                }
            }
            const result = await UserService.updateUser({
                userID,
                name,
                email,
                phone,
                avatar,
            });
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
    async getOneUser(req: Request, res: Response) {
        try {
            const query: any = req.query as unknown as TGetOneUser;
            const result = await UserService.getOneUser(query);
            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
    async getUsers(req: Request, res: Response) {
        try {
            const query: any = req.query as unknown as TGetUsers;

            console.log('🚀 ~ UserController ~ getUsers ~ query:', query);

            const result = await UserService.getUsers(query);

            return res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
    async changePassword(req: CustomRequest, res: Response) {
        try {
            const { oldPass, newPass } = req.body;
            console.log(
                '🚀 ~ UserController ~ changePassword ~  { oldPass, newPass }:',
                { oldPass, newPass }
            );
            const id = req.user?._id;

            const user: any = await userModel.findById(id);
            if (!user)
                return res.status(400).json({ err_mes: 'user not found' });

            const checkPass = await bcrypt.compare(oldPass, user.password);

            if (!checkPass)
                return res
                    .status(400)
                    .json({ err_mes: "Password don't match" });
            const newPassHash = await bcrypt.hash(newPass, BCRYPT_SECRET);

            user.password = newPassHash;
            await user.save();

            return res.send({
                success: true,
                title: 'Updated password successfully',
            });
        } catch (error: any) {
            console.log('🚀 ~ UserController ~ changePassword ~ error:', error);
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
}
export default UserController.getInstance();
