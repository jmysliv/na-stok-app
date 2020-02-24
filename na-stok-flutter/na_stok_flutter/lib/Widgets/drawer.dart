import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na_stok_flutter/bloc_/home/home.dart';
import 'package:na_stok_flutter/bloc_/authentication/authentication.dart';

class HomeDrawer extends StatelessWidget{

  HomeDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
        DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image:  AssetImage('assets/images/drawer.jfif'))),
        ),
        ListTile(
          title: Row(
          children: <Widget>[
            Icon(Icons.landscape),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Stoki'),
              )
          ],
          ),
          onTap: () {
            BlocProvider.of<HomeBloc>(context).add(ShowSlopes());
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Row(
            children: <Widget>[
            Icon(Icons.drive_eta),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Wyjazdy'),
            )
            ],
            ),
          onTap: () {
            BlocProvider.of<HomeBloc>(context).add(ShowTrips());
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Row(
            children: <Widget>[
            Icon(Icons.time_to_leave),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Moje Wyjazdy'),
              )
            ],
          ),
        onTap: () {
          BlocProvider.of<HomeBloc>(context).add(ShowMyTrips());
          Navigator.pop(context);
        },
       ),
        ListTile(
          title: Row(
          children: <Widget>[
            Icon(Icons.perm_identity),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Mój Profil'),
            )
          ],
        ),
        onTap: () {
          BlocProvider.of<HomeBloc>(context).add(ShowMyProfile());
          Navigator.pop(context);
        },
        ),
        ListTile(
          title: Row(
            children: <Widget>[
              Icon(Icons.exit_to_app),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text('Wyloguj się'),
              )
            ],
          ),
          onTap: () {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            Navigator.pop(context);
          },
        ),
      ],
      ),
      );
  }
}