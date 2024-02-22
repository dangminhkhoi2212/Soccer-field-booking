import mongoose from 'mongoose';
import dotenv from 'dotenv';
dotenv.config();
const atlas_url: string = process.env.ATLAS_URL || '';

const db = async () => {
    try {
        console.log(`Connecting to database...`);

        await mongoose
            .set({
                strictQuery: true,
            })
            .connect(atlas_url);
        console.log(`Connected to database.`);
    } catch (error) {
        console.log(`ERROR DATABASE:`);
        console.log(error);
    }
};
export default db;
