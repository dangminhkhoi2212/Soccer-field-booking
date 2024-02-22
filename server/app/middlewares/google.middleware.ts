import { LoginTicket, OAuth2Client, TokenPayload } from 'google-auth-library';
import ApiError from '../services/apiError.service';
import { NextFunction, Request, Response } from 'express';
import 'dotenv/config.js';
import firbase from 'firebase-admin';
var serviceAccount = require('../assets/google_firebase_key.json');
const firebaseClient = firbase.initializeApp({
    credential: firbase.credential.cert(serviceAccount),
});
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
const URL_VERIFY_ACCESS_TOKEN =
    'https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=';

interface dataAccessResponse {
    error_description: string;
    email: string;
}
class GoogleMiddleware {
    async verifyIdToken(req: Request, res: Response, next: NextFunction) {
        try {
            const accessToken: string = req.body.accessToken;
            // console.log(
            //     '🚀 ~ GoogleMiddleware ~ verifyIdToken ~ req.body:',
            //     req.body
            // );
            if (!accessToken)
                return res
                    .status(401)
                    .json({ message: 'accessToken not found' });

            const response = await fetch(URL_VERIFY_ACCESS_TOKEN + accessToken);

            const data: dataAccessResponse = await response.json();
            if (data['error_description']) {
                return res.status(401).json({ msg: data['error_description'] });
            }
            req.body.email = data['email'];
            next();
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ message: error.message || error });
        }
    }
}
export default GoogleMiddleware;
