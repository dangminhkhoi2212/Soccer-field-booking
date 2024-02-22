class ApiError extends Error {
    status: number;
    message: string;
    constructor(code: number, message: string) {
        console.log('🚀 ~ ApiError ~ constructor ~ message:', message);
        super(message);
        this.message = message;
        this.status = code;
    }
}

export default ApiError;
