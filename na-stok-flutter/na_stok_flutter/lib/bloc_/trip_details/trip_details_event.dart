import 'package:equatable/equatable.dart';
import 'package:na_stok_flutter/models/trips_model.dart';

abstract class TripDetailsEvent extends Equatable{
  const TripDetailsEvent();

  @override
  List<Object> get props => [];
}

class JoinTrip extends TripDetailsEvent{
  final Trip trip;
  const JoinTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "JoinTrip: {trip: $trip}";
}

class LeaveTrip extends TripDetailsEvent{
  final Trip trip;
  const LeaveTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "LeaveTrip: {trip: $trip}";
}

class AcceptSbToTrip extends TripDetailsEvent{
  final Trip trip;
  final String acceptId;
  const AcceptSbToTrip(this.trip, this.acceptId);

  @override
  List<Object> get props => [trip, acceptId];

  @override
  String toString() => "AcceptSbToTrip: {trip: $trip, acceptId: $acceptId}";
}

class DiscardSbFromTrip extends TripDetailsEvent{
  final Trip trip;
  final String discardId;
  const DiscardSbFromTrip(this.trip, this.discardId);

  @override
  List<Object> get props => [trip, discardId];

  @override
  String toString() => "DiscardSbFromTrip: {trip: $trip, discardId: $discardId}";
}

class CancelTrip extends TripDetailsEvent{
  final String tripId;
  const CancelTrip(this.tripId);

  @override
  List<Object> get props => [tripId];

  @override
  String toString() => "CancelTrip: {tripId: $tripId}";
}

class InitTrip extends TripDetailsEvent{
  final String tripId;
  const InitTrip(this.tripId);

  @override
  List<Object> get props => [tripId];

  @override
  String toString() => "InitTrip: {tripId: $tripId}";
}


class RefreshTrip extends TripDetailsEvent{
  final Trip trip;
  const RefreshTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "RefreshTrip: {trip: $trip}";
}