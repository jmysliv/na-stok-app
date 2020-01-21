"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const slopeSchema = new mongoose_1.default.Schema({
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
                    validator: (v) => {
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
const SlopeModel = mongoose_1.default.model("Slopes", slopeSchema);
mongoose_1.default.set("useFindAndModify", false);
exports.default = SlopeModel;
//# sourceMappingURL=slope.model.js.map