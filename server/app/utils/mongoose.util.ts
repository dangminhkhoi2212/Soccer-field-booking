import mongoose from 'mongoose';

class MongooseUtil {
    createOjectID(id: string) {
        return new mongoose.Types.ObjectId(id);
    }
}
export default MongooseUtil;
