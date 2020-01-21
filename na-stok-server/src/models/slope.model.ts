import mongoose from "mongoose";

const slopeSchema = new mongoose.Schema({
    address: {
        type: String,
    },
    city: {
        required: true,
        type: String,
    },
    condition_equal: {
        min: 0,
        type: Number,
    },
    condition_max: {
        min: 0,
        type: Number,
    },
    condition_min: {
        min: 0,
        type: Number,
    },
    name: {
        required: true,
        type: String,
      },
    snow_fall: {
        min: 0,
        required: true,
        type: Number,
    },
    status: {
        enum: ["czynny", "nieczynny"],
        required: true,
        type: String,
    },
    update_time: {
        type: Date,
    },
    weather: [{
        clouds: {
            type: String,
        },
        day: {
            required: true,
            type: String,
            validate: {
                validator: (v: string)  => {
                    return /\d(\d|).\d(\d|)/.test(v);
                },
            },
        },
        day_name: {
            required: true,
            type: String,
        },
        temperature: {
            type: Number,
        },
    }],
});

const SlopeModel = mongoose.model("Slopes", slopeSchema);
mongoose.set("useFindAndModify", false);

export default SlopeModel;
