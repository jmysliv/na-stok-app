import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/models/user_model.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:na_stok_flutter/home/home.dart';
import 'package:na_stok_flutter/screens/chat_screen.dart';
import 'package:na_stok_flutter/screens/loading_screen.dart';
import 'package:na_stok_flutter/screens/slope_details_screen.dart';
import 'package:na_stok_flutter/screens/user_profile_screen.dart';
import 'package:na_stok_flutter/trip_details/trip_details.dart';
import 'package:na_stok_flutter/authentication/authentication.dart';

class TripDetailsScreen extends StatelessWidget{
  final UserRepository userRepository;
  final TripRepository tripRepository;
  final Slope slope;
  final String tripId;

  TripDetailsScreen(this.tripRepository, this.userRepository, this.tripId, this.slope);

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/trip.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildItem(String label, String count, IconData icon, Function onTap) {
    TextStyle _statStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 13.0,
      fontWeight: FontWeight.bold,
    );
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: ListTile(
          leading: Text(
                label,
                style: _statStyle,
              ),
          title: Row(
            children: <Widget>[
              Icon(icon),
              Expanded(
                  child: Text(
                  count,
                  style: _statStyle,
                ),
              )
            ],
          ),
          trailing: (label == "Stok:") ? Icon(Icons.arrow_forward_ios) : null,
          onTap: onTap,
        ),
    );
  }

  Widget _buildItemsContainer(Trip trip, BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Color(0xFFEFF4F7),
        ),
        child: Column(
            children: <Widget>[
              _buildItem("Stok:", "${trip.slope}", Icons.landscape, () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return SlopeDetailsScreen(slope, userRepository, tripRepository);
                }));
              }),
              Divider(color: Colors.black54,
                thickness: 1.0,
                indent: 8.0,
                endIndent: 8.0,),
              _buildItem("Kiedy:", "${DateFormat.yMd().add_Hm().format(DateTime.parse(trip.departureDateTime))}", Icons.event, () => {}),
              Divider(color: Colors.black54,
                thickness: 1.0,
                indent: 8.0,
                endIndent: 8.0,),
              _buildItem("Z kąd:", "${trip.address}", Icons.place, () => {}),
              Divider(color: Colors.black54,
                thickness: 1.0,
                indent: 8.0,
                endIndent: 8.0,),
              _buildItem("Wolne miejsca:", "${trip.calculateFreePlaces()}", Icons.people, () => {}),
              Divider(color: Colors.black54,
                thickness: 1.0,
                indent: 8.0,
                endIndent: 8.0,),
              _buildItem("Cena:", "${trip.prize}", Icons.attach_money, () => {}),
            ]
        )
    );
  }


  Widget _buildButton(IconData icon, String label, BuildContext context, Function onTap, Color color) {
    return  Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child:  MaterialButton(
            onPressed: onTap,
            color: color,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
              child:Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white),
                  Container(
                    margin: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ))
        )
    );
  }

  Widget builtParticipantList(Trip trip, BuildContext context){
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child:Column(
          children: <Widget>[
            Text("Uczestnicy:", textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0),),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: trip.participantUsers.length,
                itemBuilder: (context, index) {
                  final User user = trip.participantUsers[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(width: 1.0, color: Colors.black))),
                        child:  Icon(Icons.person, color: Colors.black, size: 30.0),
                    ),
                    title: Text(
                      user.name,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text( (trip.creatorId == user.id) ? "Organizator" : "Uczestnik",
                      style: TextStyle(color: Colors.black),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 30.0),
                    ),
                    onTap: () async {
                      try{
                        List<Trip> trips = await tripRepository.getTrips().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));;
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                          return UserProfileScreen(user: user, favouriteSlope: user.favouriteSlope(trips), tripCreatorNumber: user.calculateCreator(trips), tripsNumber: user.calculateTrips(trips),);
                        }));
                      } catch(exception){
                        Navigator.of(context).pop();
                        BlocProvider.of<AuthenticationBloc>(context).add(ErrorOccurred(errorMessage: (exception as TimeoutException).message));
                      }
                    },
                  );
                  }
                )
          ]
        )
    );
  }

  Widget builtParticipantRequestList(Trip trip, BuildContext context){
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child:Column(
            children: <Widget>[
              Text("Uczestnicy do zatwierdzenia:", textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0),),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: trip.participantRequestUsers.length,
                  itemBuilder: (newContext, index) {
                    final User user = trip.participantRequestUsers[index];
                    return Dismissible(
                      key: ValueKey(user),
                      background: Container(
                        color: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: AlignmentDirectional.centerStart,
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.green,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        alignment: AlignmentDirectional.centerEnd,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction){
                        if (direction == DismissDirection.startToEnd) {
                          if(DateTime.parse(trip.departureDateTime).isAfter(DateTime.now())){
                            BlocProvider.of<TripDetailsBloc>(context).add(DiscardSbFromTrip(trip, user.id));
                          }
                          else{
                            BlocProvider.of<TripDetailsBloc>(context).add(InitTrip(trip.id));
                          }
                        } else {
                          if(DateTime.parse(trip.departureDateTime).isAfter(DateTime.now())){
                            BlocProvider.of<TripDetailsBloc>(context).add(AcceptSbToTrip(trip, user.id));
                          }
                          else{
                            BlocProvider.of<TripDetailsBloc>(context).add(InitTrip(trip.id));
                          }
                        }
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          decoration: new BoxDecoration(
                              border: new Border(
                                  right: new BorderSide(width: 1.0, color: Colors.black))),
                          child:  Icon(Icons.person, color: Colors.black, size: 30.0),
                        ),
                        title: Text(
                          user.name,
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text( (trip.creatorId == user.id) ? "Organizator" : "Uczestnik",
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Container(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Icon(Icons.arrow_forward_ios, color: Colors.black, size: 30.0),
                        ),
                        onTap: () async {
                          try{
                            List<Trip> trips = await tripRepository.getTrips().timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));;
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                              return UserProfileScreen(user: user, favouriteSlope: user.favouriteSlope(trips), tripCreatorNumber: user.calculateCreator(trips), tripsNumber: user.calculateTrips(trips),);
                            }));
                          } catch(exception){
                            Navigator.of(context).pop();
                            BlocProvider.of<AuthenticationBloc>(context).add(ErrorOccurred(errorMessage: (exception as TimeoutException).message));
                          }
                        },
                      ),
                    );

                  }
              )
            ]
        )
    );
  }

  Widget floatingButton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.message),
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return ChatScreen(tripId: tripId, userRepository: userRepository,);
      }));
    }
    );
  }


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    return BlocProvider<TripDetailsBloc>(
        create: (context) => TripDetailsBloc(userRepository, tripRepository)..add(InitTrip(tripId)),
        child:Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: (){
                  Navigator.of(context).pop();
                  if(BlocProvider.of<HomeBloc>(context).state is HomeMyTrips) BlocProvider.of<HomeBloc>(context).add(ShowMyTrips());
                  else BlocProvider.of<HomeBloc>(context).add(ShowTrips());
                }
            ),
            title: Text('Szczegóły wyjazdu'),
          ),
          body: BlocListener<TripDetailsBloc, TripDetailsState>(
                listener: (context, state) {
                  if(state is LoadingTrip) {
                    Scaffold.of(context)..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('Ładowanie'), CircularProgressIndicator()],
                      ),
                      backgroundColor: Colors.black,
                      ));
                    } else{
                      Scaffold.of(context)..removeCurrentSnackBar();
                    }
                  },
                  child: BlocBuilder<TripDetailsBloc, TripDetailsState>(
                    builder: (context, state) {
                      if(state is TripFailure){
                        Navigator.of(context).pop();
                        BlocProvider.of<AuthenticationBloc>(context).add(ErrorOccurred(errorMessage:  state.errorMessage));
                        return Text(state.errorMessage);
                      } else if(state is InitialTrip) {
                        return LoadingScreen();
                      } else if(state is CreatorFullTrip){
                        Trip trip = state.trip;
                        return Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  _buildCoverImage(screenSize),
                                  _buildItemsContainer(trip, context),
                                  _buildButton(Icons.cancel, "Odwołaj wyjazd", context, () {
                                      if(DateTime.parse(trip.departureDateTime).isAfter(DateTime.now())){
                                          BlocProvider.of<TripDetailsBloc>(context).add(CancelTrip(trip.id));
                                    } else {
                                        BlocProvider.of<TripDetailsBloc>(context).add(InitTrip(trip.id));
                                    }
                                  }, Colors.orange),
                                  builtParticipantList(trip, context),
                                  SizedBox(height: 70.0,)
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if(state is NotParticipantTrip){
                        Trip trip = state.trip;
                        return Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  _buildCoverImage(screenSize),
                                  _buildItemsContainer(trip, context),
                                  _buildButton(Icons.add, "Dołącz", context, () {
                                    if(DateTime.parse(trip.departureDateTime).isAfter(DateTime.now())){
                                      BlocProvider.of<TripDetailsBloc>(context).add(JoinTrip(trip));
                                    }
                                    else{
                                      BlocProvider.of<TripDetailsBloc>(context).add(InitTrip(trip.id));
                                    }
                                  }, Colors.green),
                                  builtParticipantList(trip, context),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if(state is ParticipantTrip){
                        Trip trip = state.trip;
                        return Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  _buildCoverImage(screenSize),
                                  _buildItemsContainer(trip, context),
                                  _buildButton(Icons.exit_to_app, "Zrezygnuj", context, () {
                                    if(DateTime.parse(trip.departureDateTime).isAfter(DateTime.now())){
                                      BlocProvider.of<TripDetailsBloc>(context).add(LeaveTrip(trip));
                                    }
                                    else{
                                      BlocProvider.of<TripDetailsBloc>(context).add(InitTrip(trip.id));
                                    }
                                  }, Colors.red),
                                  builtParticipantList(trip, context),
                                  SizedBox(height: 70.0,)
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if(state is LoadingTrip){
                        Trip trip = state.trip;
                        return Stack(
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    _buildCoverImage(screenSize),
                                    _buildItemsContainer(trip, context),
                                    builtParticipantList(trip, context),
                                  ],
                                ),
                              ),
                            ],
                          );
                      } else if(state is CreatorTrip){
                        Trip trip = state.trip;
                        return Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  _buildCoverImage(screenSize),
                                  _buildItemsContainer(trip, context),
                                  _buildButton(Icons.cancel, "Odwołaj wyjazd", context, ()  {
                                    if(DateTime.parse(trip.departureDateTime).isAfter(DateTime.now())){
                                      BlocProvider.of<TripDetailsBloc>(context).add(CancelTrip(trip.id));
                                    }
                                    else{
                                      BlocProvider.of<TripDetailsBloc>(context).add(InitTrip(trip.id));
                                    }
                                  }, Colors.orange),
                                  builtParticipantList(trip, context),
                                  builtParticipantRequestList(trip, context),
                                  SizedBox(height: 70.0,)
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if(state is AwaitingTrip){
                        Trip trip = state.trip;
                        return Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  _buildCoverImage(screenSize),
                                  _buildItemsContainer(trip, context),
                                  _buildButton(Icons.access_time, "Oczekiwanie na akceptacje", context, () => {}, Colors.grey),
                                  builtParticipantList(trip, context),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if(state is OldTrip) {
                        Trip trip = state.trip;
                        return Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  _buildCoverImage(screenSize),
                                  _buildItemsContainer(trip, context),
                                  builtParticipantList(trip, context),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if(state is NotEnoughPlaceTrip){
                        Trip trip = state.trip;
                        return Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: <Widget>[
                                  _buildCoverImage(screenSize),
                                  _buildItemsContainer(trip, context),
                                  _buildButton(Icons.do_not_disturb, "Brak wolnych miejsc", context, () => {}, Colors.black),
                                  builtParticipantList(trip, context),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Ups, wygląda na to, że wyjazd został usunięty, lub nastąpił niespotykany problem.")
                                ],
                              ),
                            ),
                        );
                      }

                })
              ),
              floatingActionButton:  BlocBuilder<TripDetailsBloc, TripDetailsState>(
                builder: (newcontext, state) {
                  if(state is ParticipantTrip || state is CreatorFullTrip || state is CreatorTrip){
                    return floatingButton(context);
                  } else return Container();
              }),
          ));
  }


}