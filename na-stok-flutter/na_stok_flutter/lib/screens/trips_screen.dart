import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na_stok_flutter/Widgets/drawer.dart';
import 'package:na_stok_flutter/home/home.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/models/trips_filter_model.dart';
import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:na_stok_flutter/screens/trip_details_screen.dart';
import 'package:na_stok_flutter/trips_filters/trips_filter.dart';
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
            return Scaffold(
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
              body: Container(
                  child: Center(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: filteredTrips.length,
                          itemBuilder: (context, index) {
                            final Trip trip = filteredTrips[index];
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
                                        flex: 2,
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 2.0),
                                            child: Text(DateFormat.yMd().add_Hm().format(DateTime.parse(trip.departureDateTime)), style: TextStyle(color: Colors.white))),
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Container(
                                            child: new LinearPercentIndicator(
                                              backgroundColor: Colors.green,
                                              width: 111.0,
                                              lineHeight: 20.0,
                                              percent: (maxDistance > 0) ? trip.distance/maxDistance : 0,
                                              center: Text("${trip.distance}km", style: TextStyle(fontSize: 14.0),),
                                              linearStrokeCap: LinearStrokeCap.butt,
                                              progressColor: Colors.red,
                                            ),
                                          )),
                                    ],
                                  ),
                                  trailing: Column(
                                      children: <Widget> [
                                        Text("${trip.prize}	zł", style: TextStyle(color: Colors.white, fontSize: 15.0)),
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
              )
          );
        }));
  }
}