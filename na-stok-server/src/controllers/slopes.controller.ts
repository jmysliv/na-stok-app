import { Request, Response } from "express";
import cron from "node-cron";
import request from "request";
import SlopeModel from "../models/slope.model";

export const getSlopeByID = (req: Request, res: Response) => {
   SlopeModel.findById(req.params.id, (err, result) => {
       if (err) {
           res.status(400).send(err);
       } else {
           res.status(200).send(result);
       }
    });
};

export const getSlopes = (req: Request, res: Response) => {
    SlopeModel.find( (err, result) => {
        if (err) {
            res.status(400).send(err);
        } else {
            res.status(200).send(result);
        }
    });
};

cron.schedule("* 0 * * * *", () => {
    request("http://127.0.0.1:5000/", (error, response) =>  {
        if (error) {
            console.log(error);
        } else {
            console.log(response.statusCode);
        }
    });
});
