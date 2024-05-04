import { Request, Response } from 'express';
import AddressService from '../services/address.service';
import mongooseUtil from '../utils/mongoose.util';

class AddressController {
    private static instance: AddressController;

    static getInstance(): AddressController {
        if (!AddressController.instance) {
            AddressController.instance = new AddressController();
        }
        return AddressController.instance;
    }

    async getAddress(req: Request, res: Response) {
        try {
            const query = req.query as { userID?: string };

            const addresses = await AddressService.getAddress(query);
            return res.send(addresses);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_msg: error.message || error });
        }
    }
    async getOneAddress(req: Request, res: Response) {
        try {
            const { userID } = req.query as { userID?: string };
            if (!userID)
                return res.status(400).json({ err_mes: 'userID is required' });

            const validID = mongooseUtil.createOjectID(userID);

            const addresses = await AddressService.getOneAddress({
                userID: validID,
            });

            return res.send(addresses);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_msg: error.message || error });
        }
    }
    async updateAddress(req: Request, res: Response) {
        try {
            const body = req.body;
            console.log('🚀 ~ AddressController ~ updateAddress ~ body:', body);
            const userID: string = body.userID;
            if (!userID)
                return res.status(400).send({ err_msg: 'userID not found' });

            const latitude: number | null | undefined = body.latitude;
            const longitude: number | null | undefined = body.longitude;
            const district: string | null | undefined = body.district;
            const province: string | null | undefined = body.province;
            const ward: string | null | undefined = body.ward;
            const address: string | null | undefined = body.address;

            const result = await AddressService.updateAddress({
                userID,
                latitude,
                longitude,
                province,
                district,
                ward,
                address,
            });
            res.send(result);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ err_msg: error.message || error });
        }
    }
}

export default AddressController.getInstance();
