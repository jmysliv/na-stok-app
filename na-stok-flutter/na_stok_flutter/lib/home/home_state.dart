import 'package:equatable/equatable.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/models/user_model.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';

abstract class HomeState extends Equatable{
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState{}

class HomeFailure extends HomeState{
  final String errorMessage;
  const HomeFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'HomeFailure { error: $errorMessage }';
}

class HomeSlopes extends HomeState{
  final List<Slope> slopes;
  const HomeSlopes(this.slopes);
  @override
  List<Object> get props => [slopes];

  int maxSnow(){
    int max = 0;
    slopes.forEach( (slope) {
      if(slope.conditionMin != null && slope.conditionMin > max) max = slope.conditionMin;
      else if(slope.conditionEqual != null && slope.conditionEqual > max) max = slope.conditionEqual;
    });
    return max;
  }

  @override
  String toString() => 'HomeSlopes { slopes: $slopes }';
}

class HomeTrips extends HomeState{
  final List<Trip> trips;
  final TripRepository tripRepository;
  final double maxDistance;

  const HomeTrips(this.tripRepository, this.trips, this.maxDistance);


  @override
  List<Object> get props => [trips];

  @override
  String toString() => 'HomeTrips { trips: $trips }';
}

class HomeMyTrips extends HomeState{
  final List<Trip> myTrips;
  final TripRepository tripRepository;
  final double maxDistance;
  const HomeMyTrips(this.tripRepository, this.myTrips, this.maxDistance);



  @override
  List<Object> get props => [myTrips];

  @override
  String toString() => 'HomeMyTrips { myTrips: $myTrips }';
}

class HomeMyProfile extends HomeState{
  final User user;
  const HomeMyProfile(this.user);
  @override
  List<Object> get props => [user];

  @override
  String toString() => 'HomeMyProfile { user: $user }';
}