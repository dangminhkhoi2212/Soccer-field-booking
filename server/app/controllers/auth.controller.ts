import { Request, Response } from 'express';
import UserModel from '../models/user.model';
import UserService from '../services/user.service';
import AuthService from '../services/auth.service';
import TokenService from '../services/token.service';
import AddressService from '../services/address.service';
import bcrypt from 'bcrypt';
import 'dotenv/config';
import { ROLE } from '../const/user.const';
import sellerService from '../services/seller.service';
const BCRYPT_SECRET = Number.parseInt(process.env.BCRYPT_SECRET || '10');
class AuthController {
    private static instance: AuthController;

    // singleton design pattern
    static getInstance() {
        if (!AuthController.instance) {
            AuthController.instance = new AuthController();
        }
        return AuthController.instance;
    }
    async login(req: Request, res: Response) {
        try {
            const email: string = req.body.email;
            const imageUrl: string = req.body.imageUrl;
            const name: string = req.body.name;

            if (!email) {
                return res.status(400).json({ err_mes: 'email is required' });
            }

            let user = await UserService.getOneUser({ email });
            if (!user) {
                user = await AuthService.create({ email, name, imageUrl });
            }

            const accessToken: string = TokenService.createToken(
                user._id,
                '30s'
            );
            const refreshToken: string = TokenService.createToken(
                user._id,
                '30s'
            );

            user.refreshToken = refreshToken;
            const userID = user._id;
            console.log('🚀 ~ AuthController ~ login ~ userID:', userID);

            await user.save();
            const addresses = await AddressService.getAddress({ userID });
            console.log('🚀 ~ AuthController ~ login ~ addresses:', addresses);
            let isUpdatedAddress = true;
            if (addresses.length) {
                isUpdatedAddress = addresses[0].latitude != null;
            } else isUpdatedAddress = false;
            return res.send({
                ...user.toJSON(),
                accessToken,
                isUpdatedAddress,
            });
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
    async signUp(req: Request, res: Response) {
        try {
            const email: string = req.body.email;
            const avatar: string = req.body.avatar;
            const name: string = req.body.name;
            const phone: string = req.body.phone;
            const role: string = req.body.role;
            var password: string = req.body.password;

            if (!email) {
                return res.status(400).json({ err_mes: 'Email is required' });
            }

            let user = await UserService.getOneUser({ email });
            if (user)
                return res
                    .status(400)
                    .json({ err_mes: 'This email is existed.' });
            const checkPhone = await UserService.getOneUser({ phone });
            if (checkPhone)
                return res
                    .status(400)
                    .json({ err_mes: 'This phone is existed.' });
            if (!BCRYPT_SECRET) {
                throw 'BCRYPT_SECRET not found';
            }

            password = await bcrypt.hash(password, BCRYPT_SECRET);
            user = await AuthService.signUp({
                email,
                name,
                avatar,
                phone,
                password,
                role,
            });
            console.log('🚀 ~ AuthController ~ signUp ~ user:', user);

            const accessToken: string = TokenService.createToken(
                user._id,
                '30s'
            );
            const refreshToken: string = TokenService.createToken(
                user._id,
                '30s'
            );

            user.refreshToken = refreshToken;
            const userID = user._id;
            if (role == ROLE.seller) {
                const startTime = '5:00';
                const endTime = '23:00';
                await sellerService.updateSeller(user._id, startTime, endTime);
            }
            await user.save();
            const address = await AddressService.getAddress({ userID });
            let isUpdatedAddress = address != null;
            return res.send({
                ...user.toJSON(),
                accessToken,
                isUpdatedAddress,
            });
        } catch (error: any) {
            console.log('🚀 ~ AuthController ~ signUp ~ error:', error);
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
    async signIn(req: Request, res: Response) {
        try {
            const email: string = req.body.email;
            const password: string = req.body.password;

            if (!email)
                return res.status(404).json({ err_mes: 'Email not found.' });
            const user = await UserModel.findOne({ email });
            if (!user)
                return res.status(404).json({ err_mes: 'User not found.' });
            const checkPass = await bcrypt.compare(
                password,
                user?.password || ''
            );
            if (!checkPass)
                return res.status(404).json({ err_mes: 'password invalid.' });

            const accessToken: string = TokenService.createToken(
                user._id,
                '30s'
            );
            const refreshToken: string = TokenService.createToken(
                user._id,
                '30s'
            );
            const result = await UserModel.findByIdAndUpdate(user._id, {
                refreshToken,
            })
                .select('-password')
                .lean();
            const address = await AddressService.getAddress({
                userID: user._id,
            });
            let isUpdatedAddress = address != null;
            return res.send({
                ...result,
                isUpdatedAddress,
                accessToken,
            });
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_mes: error.message || error });
        }
    }
}

export default AuthController.getInstance();
