import { Request, Response } from 'express';
import AddressService from '../services/address.service';

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
            if (addresses.length == 1) return res.send(addresses[0]);
            return res.send(addresses);
        } catch (error: any) {
            return res
                .status(error.status || 500)
                .json({ msg: error.message || error });
        }
    }

    async updateAddress(req: Request, res: Response) {
        try {
            const body = req.body;
            console.log('🚀 ~ AddressController ~ updateAddress ~ body:', body);
            const userID: string = body.userID;
            if (!userID)
                return res.status(400).send({ msg: 'userID not found' });
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
                .json({ msg: error.message || error });
        }
    }
}

export default AddressController.getInstance();
