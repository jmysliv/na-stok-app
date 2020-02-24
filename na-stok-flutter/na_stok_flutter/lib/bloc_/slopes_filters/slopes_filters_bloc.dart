import 'package:bloc/bloc.dart';
import 'package:na_stok_flutter/models/slope_filters_model.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/bloc_/slopes_filters/slopes_filters.dart';

class SlopesFiltersBloc extends Bloc<SlopesFiltersEvent, SlopesFiltersState> {
  final List<Slope> slopes;

  SlopesFiltersBloc(this.slopes);

  @override
  SlopesFiltersState get initialState => SlopesFiltersLoading();

  @override
  Stream<SlopesFiltersState> mapEventToState(SlopesFiltersEvent event) async* {
    if (event is UpdateFilter) {
      if (state is SlopesFiltersLoading) {
        List<Slope> filteredSlopes = filterSlopes(event.filter);
        filteredSlopes = sortSlopes(filteredSlopes, event.sorting);
        yield SlopesFiltersLoaded(filteredSlopes, event.filter, event.sorting);
      } else {
        yield SlopesFiltersLoading();
        List<Slope> filteredSlopes = filterSlopes(event.filter);
        filteredSlopes = sortSlopes(filteredSlopes, event.sorting);
        yield SlopesFiltersLoaded(filteredSlopes, event.filter, event.sorting);
      }
    }
  }

  List<Slope> filterSlopes(SlopesFilters filter) {
      if (filter == SlopesFilters.all) {
        return this.slopes;
      } else if (filter == SlopesFilters.open) {
        return this.slopes.where( (slope) => slope.status == "czynny").toList();
      } else {
        return this.slopes.where( (slope) => slope.status == "czynny" && DateTime.now().difference(DateTime.parse(slope.updateTime)).inDays < 14).toList();
      }
  }

  List<Slope> sortSlopes(List<Slope> unSortedSlopes, SlopesSortedBy sortedBy){
    if(sortedBy == SlopesSortedBy.updateTime){
      unSortedSlopes.sort((b, a) => DateTime.parse(a.updateTime).compareTo(DateTime.parse(b.updateTime)));
      return unSortedSlopes;
    } else if(sortedBy == SlopesSortedBy.temperature){
      unSortedSlopes.sort((a, b) => a.weatherList[0].temperature.compareTo(b.weatherList[0].temperature));
      return unSortedSlopes;
    } else{
      unSortedSlopes.sort((b, a) {
        int aCondition = (a.conditionEqual != null) ? a.conditionEqual : a.conditionMin;
        int bCondition = (b.conditionEqual != null) ? b.conditionEqual : b.conditionMin;
        return aCondition.compareTo(bCondition);
      });
      return unSortedSlopes;
    }
  }

}