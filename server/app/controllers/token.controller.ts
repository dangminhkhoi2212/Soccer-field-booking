import jwt from 'jsonwebtoken';
import { Response } from 'express';
import userModel from '../models/user.model';
import { CustomRequest } from '../middlewares/token.middleware';
import tokenService, { TDataJWT } from '../services/token.service';

class Token {
    private static instance: Token;
    static getInstance() {
        if (!Token.instance) Token.instance = new Token();
        return Token.instance;
    }
    async createRefreshToken(req: CustomRequest, res: Response) {
        try {
            const { refreshToken } = req.body;
            console.log(
                '🚀 ~ Token ~ createRefreshToken ~ refreshToken:',
                refreshToken
            );

            if (!refreshToken) {
                return res
                    .status(403)
                    .json({ err_mes: 'No refresh token provided' });
            }
            const user = jwt.decode(refreshToken) as TDataJWT;
            console.log('🚀 ~ Token ~ createRefreshToken ~ user:', user);

            const userDB: any = await userModel
                .findById(user?._id)
                .select('refreshToken');
            console.log('🚀 ~ Token ~ createRefreshToken ~ userDB:', userDB);

            if (!userDB || refreshToken != userDB.refreshToken) {
                return res
                    .status(403)
                    .json({ err_mes: "Refresh token don't match" });
            }
            const accessToken = tokenService.createToken(user, '30s');
            console.log(
                '🚀 ~ Token ~ createRefreshToken ~ accessToken:',
                accessToken
            );

            return res.status(200).json({ accessToken });
        } catch (error) {
            console.error('Error in createRefreshToken:', error);
            return res.status(500).send('Internal Server Error');
        }
    }
}
export default Token.getInstance();
