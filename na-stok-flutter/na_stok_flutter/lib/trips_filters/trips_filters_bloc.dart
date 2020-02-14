import 'package:bloc/bloc.dart';
import 'package:na_stok_flutter/models/trips_filter_model.dart';
import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/trips_filters/trips_filter.dart';

class TripsFiltersBloc extends Bloc<TripsFiltersEvent, TripsFiltersState> {
  final List<Trip> trips;

  TripsFiltersBloc(this.trips);

  @override
  TripsFiltersState get initialState => TripsFiltersLoading();

  @override
  Stream<TripsFiltersState> mapEventToState(TripsFiltersEvent event) async* {
    if (event is UpdateTripsFilter) {
      if (state is TripsFiltersLoading) {
        List<Trip> filteredTrips = filterTrips(event.filter);
        filteredTrips = sortTrips(filteredTrips, event.sorting);
        yield TripsFiltersLoaded(filteredTrips, event.filter, event.sorting);
      } else {
        yield TripsFiltersLoading();
        List<Trip> filteredTrips = filterTrips(event.filter);
        filteredTrips = sortTrips(filteredTrips, event.sorting);
        yield TripsFiltersLoaded(filteredTrips, event.filter, event.sorting);
      }
    }
  }

  List<Trip> filterTrips(TripsFilters filter) {
    if (filter == TripsFilters.all) {
      return this.trips;
    } else if (filter == TripsFilters.actual) {
      return this.trips.where( (trip) => DateTime.parse(trip.departureDateTime).isAfter(DateTime.now())).toList();
    } else if(filter == TripsFilters.past){
      return this.trips.where( (trip) =>  DateTime.parse(trip.departureDateTime).isBefore(DateTime.now())).toList();
    } else {
      return this.trips.where( (trip) => DateTime.parse(trip.departureDateTime).isAfter(DateTime.now()) && trip.calculateFreePlaces() > 0 ).toList();
    }
  }

  List<Trip> sortTrips(List<Trip> unSortedTrips, TripsSortedBy sortingRule){
    if(sortingRule == TripsSortedBy.time){
      unSortedTrips.sort((b, a) => DateTime.parse(b.departureDateTime).compareTo(DateTime.parse(a.departureDateTime)));
      return unSortedTrips;
    } else if(sortingRule == TripsSortedBy.price){
      unSortedTrips.sort((a, b) => a.prize.compareTo(b.prize));
      return unSortedTrips;
    } else{
      unSortedTrips.sort( (a, b) => a.distance.compareTo(b.distance));
      return unSortedTrips;
    }
  }

}