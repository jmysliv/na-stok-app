import 'package:equatable/equatable.dart';
import 'package:na_stok_flutter/models/trips_model.dart';

abstract class TripDetailsState extends Equatable{
  const TripDetailsState();

  @override
  List<Object> get props => [];
}

class InitialTrip extends TripDetailsState{}

class DeletedTrip extends TripDetailsState{}

class NotParticipantTrip extends TripDetailsState{
  final Trip trip;
  const NotParticipantTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "NotParticipantTrip: {trip: $trip}";
}

class ParticipantTrip extends TripDetailsState{
  final Trip trip;
  const ParticipantTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "ParticipantTrip: {trip: $trip}";
}

class LoadingTrip extends TripDetailsState{
  final Trip trip;
  const LoadingTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "LoadingTrip: {trip: $trip}";
}

class CreatorTrip extends TripDetailsState{
  final Trip trip;
  const CreatorTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "CreatorTrip: {trip: $trip}";
}

class AwaitingTrip extends TripDetailsState{
  final Trip trip;
  const AwaitingTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "AwaitingTrip: {trip: $trip}";
}

class OldTrip extends TripDetailsState{
  final Trip trip;
  const OldTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "OldTrip: {trip: $trip}";
}

class NotEnoughPlaceTrip extends TripDetailsState{
  final Trip trip;
  const NotEnoughPlaceTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "NotEnoughPlaceTrip: {trip: $trip}";
}

class CreatorFullTrip extends TripDetailsState{
  final Trip trip;
  const CreatorFullTrip(this.trip);

  @override
  List<Object> get props => [trip];

  @override
  String toString() => "CreatorFullTrip: {trip: $trip}";
}

class TripFailure extends TripDetailsState{
  final String errorMessage;
  const TripFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'TripFailure { error: $errorMessage }';
}
