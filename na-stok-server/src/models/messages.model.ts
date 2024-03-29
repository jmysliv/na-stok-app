import mongoose from "mongoose";

const messageSchema = new mongoose.Schema({
    authorId: {
        required: true,
        type: String,
    },
    authorName: {
        required: true,
        type: String,
    },
    content: {
        required: true,
        type: String,
    },
    dateTime: {
        required: true,
        type: Date,
    },
    tripId: {
        required: true,
        type: String,
    },
});

export interface IMessage {
    authorId: string;
    authorName: string;
    content: string;
    tripId: string;
    dateTime: Date;
}

const MessageModel = mongoose.model("Messages", messageSchema);
mongoose.set("useFindAndModify", false);

export default MessageModel;
