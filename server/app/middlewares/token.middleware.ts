import jwt, { JwtPayload, JsonWebTokenError } from 'jsonwebtoken';
import { Request, Response, NextFunction } from 'express';
import { TDataJWT } from '../services/token.service';

export interface CustomRequest extends Request {
    user?: DecodedUser;
}

export interface DecodedUser extends JwtPayload, TDataJWT {}

class TokenMiddleware {
    private static instance: TokenMiddleware;

    private constructor() {}

    static getInstance() {
        if (!TokenMiddleware.instance) {
            TokenMiddleware.instance = new TokenMiddleware();
        }
        return TokenMiddleware.instance;
    }

    async authenticateJWT(
        req: CustomRequest,
        res: Response,
        next: NextFunction
    ) {
        try {
            const accessToken = req.headers.authorization?.split(' ')[1];

            // console.log('🚀 ~ TokenMiddleware ~ token:', accessToken);

            if (!accessToken) {
                return res.status(403).json({ err_mes: 'token not founded' });
            }

            jwt.verify(
                accessToken,
                process.env.JWT_SECRET as string,
                function (err, decoded) {
                    if (err) {
                        console.log('🚀 ~ TokenMiddleware ~ err:', err);

                        return res
                            .status(403)
                            .json({ err_mes: 'token expired' });
                    }
                    req.user = decoded as DecodedUser;
                    next();
                }
            );
        } catch (error) {
            if (error instanceof JsonWebTokenError) {
                res.status(403).json({ err_mes: 'Invalid token' });
            } else {
                res.sendStatus(401);
            }
        }
    }
}
export default TokenMiddleware.getInstance();
