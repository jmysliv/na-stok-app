import 'package:equatable/equatable.dart';
import 'package:na_stok_flutter/models/trips_filter_model.dart';

abstract class TripsFiltersEvent extends Equatable {
  const TripsFiltersEvent();
}

class UpdateTripsFilter extends TripsFiltersEvent {
  final TripsFilters filter;
  final TripsSortedBy sorting;

  const UpdateTripsFilter(this.filter, this.sorting);

  @override
  List<Object> get props => [filter, sorting];

  @override
  String toString() => 'UpdateTripsFilter { filter: $filter, sorting: $sorting }';
}
