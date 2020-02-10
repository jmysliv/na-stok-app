import 'package:flutter/material.dart';
import 'package:na_stok_flutter/Widgets/drawer.dart';
import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:intl/intl.dart';

class TripsScreen extends StatelessWidget{
  final UserRepository userRepository;
  final TripRepository tripRepository;
  final List<Trip> trips;
  final String title;
  final double maxDistance;

  TripsScreen(this.userRepository, this.tripRepository, this.trips, this.title, this.maxDistance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: HomeDrawer(),
        appBar: AppBar(
            title: Text(title),
            actions: [
              PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuItem>[
                  PopupMenuItem(
                    child: Text("Pokaż aktualne",),
                  ),
                  PopupMenuItem(
                    child: Text("Pokaż wszystkie",),
                  ),
                  PopupMenuItem(
                    child: Text("Pokaż przeszłe",),
                  ),
                  PopupMenuItem(
                    child: Text("Pokaż aktualne, z wolnymi miejscami", ),
                  ),
                ],
                icon: Icon(Icons.filter_list),
              ),
              PopupMenuButton(
                itemBuilder: (BuildContext context) => <PopupMenuItem>[
                  PopupMenuItem(
                    child: Text("Sortuj po czasie wyjazdu",),
                  ),
                  PopupMenuItem(
                    child: Text("Sortuj po cenie",),
                  ),
                  PopupMenuItem(
                    child: Text("Sortuj po odległości",),
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
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      final Trip trip = trips[index];
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
                                        width: 111.0,
                                        lineHeight: 20.0,
                                        percent: (maxDistance > 0) ? trip.distance/maxDistance : 0,
                                        center: Text("${trip.distance}km", style: TextStyle(fontSize: 14.0),),
                                        linearStrokeCap: LinearStrokeCap.butt,
                                        progressColor: (trip.distance < 5.0) ? Colors.green : Colors.red,
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
                            onTap: () {},
                          ),
                        ),
                      );
                    }))
        )
    );
  }
}