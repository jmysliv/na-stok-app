import 'package:equatable/equatable.dart';
import 'package:na_stok_flutter/models/slope_filters_model.dart';
import 'package:na_stok_flutter/models/slope_model.dart';

abstract class SlopesFiltersState extends Equatable {
  const SlopesFiltersState();

  @override
  List<Object> get props => [];
}

class SlopesFiltersLoading extends SlopesFiltersState {}

class SlopesFiltersLoaded extends SlopesFiltersState {
  final List<Slope> filteredSlopes;
  final SlopesFilters activeFilter;
  final SlopesSortedBy activeSorting;
  final String activeSearch;
  SlopesFiltersLoaded(this.filteredSlopes, this.activeFilter, this.activeSorting, this.activeSearch);

  @override
  List<Object> get props => [filteredSlopes, activeFilter, activeSorting, activeSearch];

  @override
  String toString() {
    return 'SlopesFiltersLoaded { filteredSlopes: $filteredSlopes, activeFilter: $activeFilter, activeSorting: $activeSorting, search: $activeSearch}';
  }
}