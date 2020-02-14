import 'package:equatable/equatable.dart';
import 'package:na_stok_flutter/models/trips_filter_model.dart';
import 'package:na_stok_flutter/models/trips_model.dart';


abstract class TripsFiltersState extends Equatable {
  const TripsFiltersState();

  @override
  List<Object> get props => [];
}

class TripsFiltersLoading extends TripsFiltersState {}

class TripsFiltersLoaded extends TripsFiltersState {
  final List<Trip> filteredTrips;
  final TripsFilters activeFilter;
  final TripsSortedBy activeSorting;

  const TripsFiltersLoaded(this.filteredTrips, this.activeFilter, this.activeSorting);

  @override
  List<Object> get props => [filteredTrips, activeFilter, activeSorting];

  @override
  String toString() {
    return 'TripsFiltersLoaded { filteredTrips: $filteredTrips, activeFilter: $activeFilter, activeSorting: $activeSorting }';
  }
}