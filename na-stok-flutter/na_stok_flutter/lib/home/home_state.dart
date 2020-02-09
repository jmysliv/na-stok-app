import 'package:equatable/equatable.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/models/user_model.dart';

abstract class HomeState extends Equatable{
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState{}

class HomeFailure extends HomeState{}

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

class HomeTrips extends HomeState{}

class HomeMyTrips extends HomeState{}

class HomeMyProfile extends HomeState{
  final User user;
  const HomeMyProfile(this.user);
  @override
  List<Object> get props => [user];

  @override
  String toString() => 'HomeMyProfile { user: $user }';
}