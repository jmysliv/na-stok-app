import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/models/user_model.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:na_stok_flutter/home/home.dart';
import 'package:na_stok_flutter/screens/loading_screen.dart';
import 'package:na_stok_flutter/trip_details/trip_details.dart';
import 'package:na_stok_flutter/authentication/authentication.dart';

class TripDetailsScreen extends StatelessWidget{
  final UserRepository userRepository;
  final TripRepository tripRepository;
  final Slope slope;
  final String tripId;
  final _keyScaffold = GlobalKey<ScaffoldState>();

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

  Widget _buildItem(String label, String count, IconData icon) {
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
              Text(
                count,
                style: _statStyle,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          trailing: (label == "Stok:") ? Icon(Icons.arrow_forward_ios) : null,
          onTap: () {},
        ),
    );
  }

  Widget _buildItemsContainer(Trip trip) {
    return Container(
        margin: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: Color(0xFFEFF4F7),
        ),
        child: Column(
            children: <Widget>[
              _buildItem("Stok:", "${trip.slope}", Icons.landscape),
              Divider(color: Colors.black54,
                thickness: 1.0,
                indent: 8.0,
                endIndent: 8.0,),
              _buildItem("Kiedy:", "${DateFormat.yMd().add_Hm().format(DateTime.parse(trip.departureDateTime))}", Icons.event),
              Divider(color: Colors.black54,
                thickness: 1.0,
                indent: 8.0,
                endIndent: 8.0,),
              _buildItem("Z kąd:", "${trip.address}", Icons.place),
              Divider(color: Colors.black54,
                thickness: 1.0,
                indent: 8.0,
                endIndent: 8.0,),
              _buildItem("Wolne miejsca:", "${trip.calculateFreePlaces()}", Icons.people),
              Divider(color: Colors.black54,
                thickness: 1.0,
                indent: 8.0,
                endIndent: 8.0,),
              _buildItem("Cena:", "${trip.prize}", Icons.attach_money),
            ]
        )
    );
  }


  Widget _buildButton(IconData icon, String label, BuildContext context, Function onTap, Color color) {
    return MaterialButton(
        onPressed: onTap,
        color: color,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            Container(
              margin: const EdgeInsets.only(top: 8),
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
        ));
  }

  Widget builtParticipantList(Trip trip){
    return Column(
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
                trailing: Column(
                    children: <Widget> [
                      Icon(Icons.arrow_forward_ios, color: Colors.black, size: 30.0),
                    ]
                ),
                onTap: () {},
              );
              }
            )
      ]
    );
  }

  Widget builtParticipantRequestList(Trip trip){
    return Column(
        children: <Widget>[
          Text("Uczestnicy do zatwierdzenia:", textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0),),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: trip.participantUsers.length,
              itemBuilder: (context, index) {
                final User user = trip.participantUsers[index];
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
                  onDismissed: (direction){},
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
                    trailing: Column(
                        children: <Widget> [
                          Icon(Icons.arrow_forward_ios, color: Colors.black, size: 30.0),
                        ]
                    ),
                    onTap: () {},
                  ),
                );

              }
          )
        ]
    );
  }

  Widget floatingButton(){
    return FloatingActionButton(
    child: Icon(Icons.message),
    onPressed: (){}
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
          key: _keyScaffold,
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
          body:  BlocBuilder<TripDetailsBloc, TripDetailsState>(
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
                              _buildItemsContainer(trip),
                              _buildButton(Icons.cancel, "Odwołaj wyjazd", context, () => {}, Colors.orange),
                              builtParticipantList(trip),
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
                              _buildItemsContainer(trip),
                              _buildButton(Icons.add, "Dołącz", context, () => {}, Colors.green),
                              builtParticipantList(trip),
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
                              _buildItemsContainer(trip),
                              _buildButton(Icons.exit_to_app, "Zrezygnuj", context, () => {}, Colors.red),
                              builtParticipantList(trip),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if(state is LoadingTrip){
                    Trip trip = state.trip;
                    _keyScaffold.currentState..hideCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text('Ładowanie'), CircularProgressIndicator()],
                            ),
                            backgroundColor: Colors.black,
                          ));
                    return Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              _buildCoverImage(screenSize),
                              _buildItemsContainer(trip),
                              builtParticipantList(trip),
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
                              _buildItemsContainer(trip),
                              _buildButton(Icons.cancel, "Odwołaj wyjazd", context, () => {}, Colors.orange),
                              builtParticipantList(trip),
                              builtParticipantRequestList(trip),
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
                              _buildItemsContainer(trip),
                              _buildButton(Icons.access_time, "Oczekiwanie na akceptacje", context, () => {}, Colors.grey),
                              builtParticipantList(trip),
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
                              _buildItemsContainer(trip),
                              builtParticipantList(trip),
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
                              _buildItemsContainer(trip),
                              _buildButton(Icons.do_not_disturb, "Brak wolnych miejsc", context, () => {}, Colors.black),
                              builtParticipantList(trip),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container(
                      child: Center(
                          child: Column(
                            children: <Widget>[
                              Text("Ups, wygląda na to, że wyjazd został usunięty, lub nastąpił niespotykany problem.")
                            ],
                          ),
                        ),
                    );
                  }

            }),
          floatingActionButton:  BlocBuilder<TripDetailsBloc, TripDetailsState>(
            builder: (context, state) {
              if(state is ParticipantTrip || state is CreatorFullTrip || state is CreatorTrip){
                return floatingButton();
              } else return Container();
          })
      ));
  }


}