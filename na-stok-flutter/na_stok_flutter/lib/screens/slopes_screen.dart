import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na_stok_flutter/Widgets/drawer.dart';
import 'package:na_stok_flutter/models/slope_filters_model.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:na_stok_flutter/screens/slope_details_screen.dart';
import 'package:na_stok_flutter/bloc_/slopes_filters/slopes_filters.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SlopesScreen extends StatelessWidget {
  final UserRepository userRepository;
  final List<Slope> slopes;
  final int maxSnow;
  final TripRepository tripRepository;

  SlopesScreen({Key key, @required this.userRepository, @required this.slopes, @required this.maxSnow, @required this.tripRepository})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
      return BlocProvider<SlopesFiltersBloc>(
        create: (context) => SlopesFiltersBloc(this.slopes)..add(UpdateFilter(SlopesFilters.all, SlopesSortedBy.updateTime)),
        child: BlocBuilder<SlopesFiltersBloc, SlopesFiltersState>(
          builder: (context, state) {
            List<Slope> filteredSlopes = (state is SlopesFiltersLoaded) ? state.filteredSlopes : this.slopes;
            SlopesFilters activeFilter =  (state is SlopesFiltersLoaded) ? state.activeFilter : SlopesFilters.all;
            SlopesSortedBy activeSorting = (state is SlopesFiltersLoaded) ? state.activeSorting : SlopesSortedBy.updateTime;
            final activeStyle = Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).accentColor);
            final defaultStyle = Theme.of(context).textTheme.body1;
            return Scaffold(
                drawer: HomeDrawer(),
                appBar: AppBar(
                  title: Text('Stoki'),
                  actions: [
                    PopupMenuButton<SlopesFilters>(
                      onSelected: (filter) {
                        BlocProvider.of<SlopesFiltersBloc>(context).add(UpdateFilter(filter, activeSorting));
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuItem<SlopesFilters>>[
                        PopupMenuItem<SlopesFilters>(
                          value: SlopesFilters.all,
                          child: Text("Pokaż wszystkie", style: activeFilter == SlopesFilters.all ? activeStyle : defaultStyle),
                        ),
                        PopupMenuItem<SlopesFilters>(
                          value: SlopesFilters.open,
                          child: Text("Pokaż czynne", style: activeFilter == SlopesFilters.open ? activeStyle : defaultStyle),
                        ),
                        PopupMenuItem<SlopesFilters>(
                          value: SlopesFilters.openAndActive,
                          child: Text("Pokaż czynne, aktualizowane w ostatnich 2 tygodniach", style: activeFilter == SlopesFilters.openAndActive ? activeStyle : defaultStyle),
                        ),
                      ],
                      icon: Icon(Icons.filter_list),
                    ),
                    PopupMenuButton<SlopesSortedBy>(
                      onSelected: (sorting){
                        BlocProvider.of<SlopesFiltersBloc>(context).add(UpdateFilter(activeFilter, sorting));
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuItem<SlopesSortedBy>>[
                        PopupMenuItem<SlopesSortedBy>(
                          value: SlopesSortedBy.updateTime,
                          child: Text("Sortuj po czasie aktualizacji", style: activeSorting == SlopesSortedBy.updateTime ? activeStyle : defaultStyle),
                        ),
                        PopupMenuItem<SlopesSortedBy>(
                          value: SlopesSortedBy.condition,
                          child: Text("Sortuj po pokrywie śnieżnej", style: activeSorting == SlopesSortedBy.condition ? activeStyle : defaultStyle),
                        ),
                        PopupMenuItem<SlopesSortedBy>(
                          value: SlopesSortedBy.temperature,
                          child: Text("Sortuj po temperaturze", style: activeSorting == SlopesSortedBy.temperature ? activeStyle : defaultStyle),
                        ),
                      ],
                    ),
                  ]
                ),
                body: Container(
                      child: Center(
                             child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: filteredSlopes.length,
                                itemBuilder: (context, index) {
                                  final slope = filteredSlopes[index];
                                  return Card(
                                    elevation: 8.0,
                                    margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                    child: Container(
                                      decoration: BoxDecoration(color: Colors.indigo),
                                      child:ListTile(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                        leading: Container(
                                          padding: EdgeInsets.only(right: 12.0),
                                          decoration: new BoxDecoration(
                                              border: new Border(
                                                  right: new BorderSide(width: 1.0, color: Colors.white24))),
                                          child: (slope.status == 'czynny') ? Icon(Icons.check, color: Colors.white) : Icon(Icons.close, color: Colors.white),
                                        ),
                                        title: Text(
                                            slope.name,
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                        ),


                                        subtitle: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 2,
                                              child: Padding(
                                                  padding: EdgeInsets.only(left: 2.0),
                                                  child: Text(slope.city,
                                                      style: TextStyle(color: Colors.white))),
                                            ),
                                            Expanded(
                                                flex: 3,
                                                child: Container(
                                                  child: new LinearPercentIndicator(
                                                    width: 120.0,
                                                    lineHeight: 20.0,
                                                    percent: calculateProgress(slope),
                                                    center: Text("${(slope.conditionMin != null) ? slope.conditionMin : slope.conditionEqual}cm śniegu", style: TextStyle(fontSize: 14.0),),
                                                    linearStrokeCap: LinearStrokeCap.butt,
                                                    progressColor: (slope.conditionMin != null) ? ((slope.conditionMin/maxSnow > 0.4) ? Colors.green : Colors.red): ((slope.conditionEqual != null) ? ((slope.conditionEqual/maxSnow > 0.4) ? Colors.green : Colors.red) : Colors.red),
                                                  ),
                                                )),
                                          ],
                                        ),
                                        trailing: Column(
                                          children: <Widget> [
                                            Text("${slope.weatherList[0].temperature}	C°", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                                            Icon(Icons.ac_unit, color: Colors.white, size: 30.0),
                                          ]
                                          ),
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                                                return SlopeDetailsScreen(slope, userRepository, tripRepository);
                                              }));
                                        },
                                      ),
                                    ),
                                  );
                                }))
                      )
            );
            }));
  }

  double calculateProgress(Slope slope){
    if(slope.conditionMin != null) return slope.conditionMin/this.maxSnow;
    else if(slope.conditionEqual != null) return slope.conditionEqual/maxSnow;
    else{
      return 0.01;
    }
  }
}