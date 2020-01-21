import { Request, Response } from "express";
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
