import mongoose from 'mongoose';
export type TOjectID = mongoose.Types.ObjectId;
class MongooseUtil {
    private static instance: MongooseUtil;
    static getInstance() {
        if (!this.instance) {
            this.instance = new MongooseUtil();
        }
        return this.instance;
    }
    createOjectID(id: string): TOjectID {
        return new mongoose.Types.ObjectId(id);
    }
}
export default MongooseUtil.getInstance();
