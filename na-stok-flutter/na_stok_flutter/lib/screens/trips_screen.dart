import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na_stok_flutter/Widgets/drawer.dart';
import 'package:na_stok_flutter/bloc_/home/home.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/models/trips_filter_model.dart';
import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:na_stok_flutter/screens/trip_details_screen.dart';
import 'package:na_stok_flutter/bloc_/trips_filters/trips_filter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';

class TripsScreen extends StatelessWidget{
  final UserRepository userRepository;
  final TripRepository tripRepository;
  final List<Trip> trips;
  final List<Slope> slopes;
  final String title;
  final double maxDistance;


  TripsScreen(this.userRepository, this.tripRepository, this.trips, this.title, this.maxDistance, this.slopes);

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return BlocProvider<TripsFiltersBloc>(
        create: (context) => TripsFiltersBloc(this.trips)..add(UpdateTripsFilter(TripsFilters.actual, TripsSortedBy.time)),
        child: BlocBuilder<TripsFiltersBloc, TripsFiltersState>(
          builder: (context, state) {
            List<Trip> filteredTrips = (state is TripsFiltersLoaded) ? state.filteredTrips : this.trips;
            TripsFilters activeFilter =  (state is TripsFiltersLoaded) ? state.activeFilter : TripsFilters.actual;
            TripsSortedBy activeSorting = (state is TripsFiltersLoaded) ? state.activeSorting : TripsSortedBy.time;
            final activeStyle = Theme.of(context).textTheme.body1.copyWith(color: Theme.of(context).accentColor);
            final defaultStyle = Theme.of(context).textTheme.body1;
            return BlocListener<HomeBloc, HomeState>(
              listener: (context, state){
                if((state is HomeTrips && state.localizationOff) || (state is HomeMyTrips && state.localizationOff)){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Nie można pobrać aktualnej lokalizacji"),
                        content: Text('Włacz lokalizację i odśwież'),
                        actions: <Widget>[
                        FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                          Navigator.of(context).pop();
                          },
                         ),
                         ],
                       );
                      },
                    );
                  }
              },
              child: Scaffold(
                drawer: HomeDrawer(),
                appBar: AppBar(
                  title: Text(title),
                  actions: [
                    PopupMenuButton<TripsFilters>(
                      onSelected: (filter){
                        BlocProvider.of<TripsFiltersBloc>(context).add(UpdateTripsFilter(filter, activeSorting));
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuItem<TripsFilters>>[
                        PopupMenuItem<TripsFilters>(
                          value: TripsFilters.actual,
                          child: Text("Pokaż aktualne", style: (activeFilter == TripsFilters.actual) ? activeStyle : defaultStyle),
                        ),
                        PopupMenuItem<TripsFilters>(
                          value: TripsFilters.all,
                          child: Text("Pokaż wszystkie", style: (activeFilter == TripsFilters.all) ? activeStyle : defaultStyle),
                        ),
                        PopupMenuItem<TripsFilters>(
                          value: TripsFilters.past,
                          child: Text("Pokaż przeszłe", style: (activeFilter == TripsFilters.past) ? activeStyle : defaultStyle),
                        ),
                        PopupMenuItem<TripsFilters>(
                          value: TripsFilters.actualWithFreePlaces,
                          child: Text("Pokaż aktualne, z wolnymi miejscami", style: (activeFilter == TripsFilters.actualWithFreePlaces) ? activeStyle : defaultStyle),
                        ),
                      ],
                      icon: Icon(Icons.filter_list),
                    ),
                    PopupMenuButton<TripsSortedBy>(
                      onSelected: (sorting){
                        BlocProvider.of<TripsFiltersBloc>(context).add(UpdateTripsFilter(activeFilter, sorting));
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuItem<TripsSortedBy>>[
                        PopupMenuItem<TripsSortedBy>(
                          value: TripsSortedBy.time,
                          child: Text("Sortuj po czasie wyjazdu", style: (activeSorting == TripsSortedBy.time) ? activeStyle : defaultStyle),
                        ),
                        PopupMenuItem<TripsSortedBy>(
                          value: TripsSortedBy.price,
                          child: Text("Sortuj po cenie", style: (activeSorting == TripsSortedBy.price) ? activeStyle : defaultStyle),
                        ),
                        PopupMenuItem<TripsSortedBy>(
                          value: TripsSortedBy.distance,
                          child: Text("Sortuj po odległości", style: (activeSorting == TripsSortedBy.distance) ? activeStyle : defaultStyle),
                        ),
                      ],
                    ),
                  ]
              ),
              body: RefreshIndicator(
                  onRefresh: () {
                    if(BlocProvider.of<HomeBloc>(context).state is HomeMyTrips) BlocProvider.of<HomeBloc>(context).add(ShowMyTrips());
                    else BlocProvider.of<HomeBloc>(context).add(ShowTrips());
                    return Future.delayed(Duration(milliseconds: 1));
                  },
                  child: Container(
                    child: Center(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: false,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: (this.trips.length > 0) ? filteredTrips.length : 0,
                          itemBuilder: (context, index) {
                            final Trip trip = filteredTrips[index];
                            return Card(
                              elevation: 8.0,
                              margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 6.0),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.indigo),
                                child:ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 5.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(width: 1.0, color: Colors.white24))),
                                    child: Column(
                                        children: <Widget> [
                                          Text("${trip.calculateFreePlaces()} wolne", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                                          (trip.calculateFreePlaces() > 0) ? Icon(Icons.check, color: Colors.white, size: 30.0) : Icon(Icons.close, color: Colors.white, size: 30.0),
                                    ])
                                  ),
                                  title: Text(
                                    trip.slope,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),

                                  subtitle: Row(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 2.0),
                                            child: (DateTime.parse(trip.departureDateTime).isAfter(DateTime.now())) ? Text(
                                                "Odległość od miejsca wyjazdu:", style: TextStyle(color: Colors.white, fontSize: 10.0)
                                            ) : Text("Wyjazd już się odbył", style: TextStyle(color: Colors.white, fontSize: 10.0)),
                                        )
                                      ),
                                      Expanded(
                                          flex: 4,
                                          child: Container(
                                            child: (DateTime.parse(trip.departureDateTime).isAfter(DateTime.now())) ? new LinearPercentIndicator(
                                              backgroundColor: Colors.green,
                                              width: 110.0,
                                              lineHeight: 20.0,
                                              percent: (maxDistance > 0) ? trip.distance/maxDistance : 0,
                                              center: Text((trip.distance>1) ? "${trip.distance.round()}km" : "${trip.distance*1000}m", style: TextStyle(fontSize: 14.0),),
                                              linearStrokeCap: LinearStrokeCap.butt,
                                              progressColor: Colors.red,
                                            ) : Container(),
                                          )),
                                    ],
                                  ),
                                  trailing: Column(
                                      children: <Widget> [
                                        Text("${trip.prize}", style: TextStyle(color: Colors.white, fontSize: 15.0)),
                                        Icon(Icons.attach_money, color: Colors.white, size: 30.0),
                                      ]
                                  ),
                                  onTap: () {
                                    Slope specialSlope = null;
                                    for(Slope slope in this.slopes){
                                      if(slope.name == trip.slope) specialSlope = slope;
                                    }
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                      return BlocProvider.value(value: homeBloc, child: TripDetailsScreen(tripRepository, userRepository, trip.id, specialSlope));
                                    }));
                                  },
                                ),
                              ),
                            );
                          }))
              ))
          ));
        })
      );
  }
}