import 'package:equatable/equatable.dart';
import 'package:na_stok_flutter/models/slope_filters_model.dart';

abstract class SlopesFiltersEvent extends Equatable {
  const SlopesFiltersEvent();
}

class UpdateFilter extends SlopesFiltersEvent {
  final SlopesFilters filter;
  final SlopesSortedBy sorting;
  final String search;

  const UpdateFilter(this.filter, this.sorting, this.search);

  @override
  List<Object> get props => [filter, sorting, search];

  @override
  String toString() => 'UpdateFilter { filter: $filter, sorting: $sorting, search: $search }';
}
