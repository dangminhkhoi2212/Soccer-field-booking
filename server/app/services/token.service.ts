import jwt from 'jsonwebtoken';
class TokenService {
    static createToken(data: string, exp: string) {
        return jwt.sign(data.toString(), exp);
    }
}
export default TokenService;
