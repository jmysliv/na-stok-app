import { Request, Response } from "express";
import TripModel from "../models/trip.model";

export const insertTrip = (req: Request, res: Response) => {
    const trip = new TripModel(req.body);
    trip.save((err: Error, result) => {
        if (err) {
        res.status(400).send({
            message: err,
        });
        } else {
        res.status(201).send({
            id: result._id,
        });
        }
    });

};

export const getTripByID = (req: Request, res: Response) => {
    TripModel.findById(req.params.id, (err, result) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(result);
        }
    });
};

export const getTrips = (req: Request, res: Response) => {
    TripModel.find((err, result) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(result);
        }
    });
};

export const putTrip = (req: Request, res: Response) => {
    TripModel.findByIdAndUpdate(req.params.id, req.body, (err, result) => {
        if (err) {
            res.status(500).send(err);
        } else {
            res.status(200).send(result);
        }
    });
};

export const deleteTripById = (req: Request, res: Response) => {
    TripModel.findByIdAndRemove(req.params.id, (err, result) => {
        if (err) { res.status(500).send(err); } else { res.status(204).send(result); }
    });
};
