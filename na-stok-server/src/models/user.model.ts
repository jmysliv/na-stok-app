import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
  email: {
      required: true,
      type: String,
      unique: true,
      validate: {
        validator: (v: string) => {
            return /\S+@\S+\.\S+/.test(v);
        },
    },
  },
  name: {
    required: true,
    type: String,
  },
  password: {
    required: true,
    type: String,
  },
});

export interface IUser {
    _id: string;
    email: string;
    password: string;
    name: string;
}

const UserModel = mongoose.model("Users", userSchema);
mongoose.set("useFindAndModify", false);

export default UserModel;
