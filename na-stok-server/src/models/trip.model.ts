import mongoose from "mongoose";

const tripSchema = new mongoose.Schema({
    creator: {
        required: true,
        type: String,
    },
    departureDateTime: {
        required: true,
        type: Date,
    },
    latitude: {
        required: true,
        type: Number,
    },
    longitude: {
        required: true,
        type: Number,
    },
    maxParticipants: {
        min: 1,
        required: true,
        type: Number,
    },
    participants: {
        type: [String],
    },
    participantsRequest: {
        type: [String],
    },
    prize: {
        min: 0,
        type: Number,
    },
    slope: {
        required: true,
        type: String,
    },
});

export interface ITrips {
    creator: string;
    participants: string[];

}
const TripModel = mongoose.model("Trips", tripSchema);
mongoose.set("useFindAndModify", false);

export default TripModel;
