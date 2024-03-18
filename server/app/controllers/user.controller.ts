import { Request, Response } from 'express';
import UserService from '../services/user.service';
import mongoose, { ObjectId } from 'mongoose';
import userModel from '../models/user.model';
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
    async updateUser(req: Request, res: Response) {
        try {
            const body = req.body;
            const userID: string = body.userID;
            console.log('🚀 ~ UserController ~ updateUser ~ userID:', userID);
            const name: string = body.name;
            const phone: string = body.phone;
            const avatar: string = body.avatar;

            if (!userID)
                return res.status(401).json({ msg: 'userID not found' });
            const result = await UserService.updateUser({
                userID,
                name,
                phone,
                avatar,
            });
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ msg: error.message || error });
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
                .json({ msg: error.message || error });
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
                .json({ msg: error.message || error });
        }
    }
}
export default UserController;
