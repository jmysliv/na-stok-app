import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable{
  @override
  List<Object> get props => [];
}
class ShowSlopes extends HomeEvent {}

class ShowTrips extends HomeEvent {}

class ShowMyTrips extends HomeEvent {}

class ShowMyProfile extends HomeEvent{}