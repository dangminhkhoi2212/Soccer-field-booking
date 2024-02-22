import UserModel, { TUser } from '../models/user.model';

type CreateUserParams = {
    email?: string;
    name?: string;
    imageUrl?: string;
};
class AuthService {
    static async create(user: CreateUserParams) {
        const data = {
            email: user.email,
            name: user.name,
            avatar: user.imageUrl,
        };
        const result = await UserModel.create(data);
        return result;
    }
    static async signUp(data: {
        email: string;
        name: string;
        avatar: string;
        phone: string;
        password: string;
        role: string;
    }) {
        const result = await UserModel.create(data);
        return result;
    }
}
export default AuthService;
