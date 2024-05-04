import jwt from 'jsonwebtoken';
export interface TDataJWT {
    _id: string;
    name: string;
    email: string;
    role: string;
}

class TokenService {
    private static instance: TokenService;
    static getInstance() {
        if (!TokenService.instance) {
            TokenService.instance = new TokenService();
        }
        return TokenService.instance;
    }

    createToken(data: TDataJWT, expiresIn: string) {
        const secret = process.env.JWT_SECRET || '';

        if ('exp' in data) {
            delete data.exp;
        }
        if ('iat' in data) {
            delete data.iat;
        }
        return jwt.sign(data, secret, { expiresIn });
    }
}
export default TokenService.getInstance();
