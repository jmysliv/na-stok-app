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

  const SlopesFiltersLoaded(this.filteredSlopes, this.activeFilter, this.activeSorting);

  @override
  List<Object> get props => [filteredSlopes, activeFilter, activeSorting];

  @override
  String toString() {
    return 'SlopesFiltersLoaded { filteredSlopes: $filteredSlopes, activeFilter: $activeFilter, activeSorting: $activeSorting }';
  }
}