import 'package:flutter/material.dart';
import 'package:na_stok_flutter/models/user_model.dart';

class UserProfileScreen extends StatelessWidget{
  final User user;
  final String favouriteSlope;
  final int tripsNumber;
  final int tripCreatorNumber;

  UserProfileScreen({Key key, @required this.user, this.favouriteSlope, this.tripCreatorNumber, this.tripsNumber})
      :super(key: key);

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/drawer.jfif'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Text(
          user.name,
          style: _nameTextStyle,
        ));
  }

  Widget _buildEmail(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        user.email,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 10.0,
      fontWeight: FontWeight.w200,
    );
    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              count,
              style: _statCountTextStyle,
            ),
            Text(
              label,
              style: _statLabelTextStyle,
            ),
          ],
        )
    );
  }

  Widget _buildStatContainer() {
    return Container(
        height: 120.0,
        margin: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: Color(0xFFEFF4F7),
        ),
        child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildStatItem("Liczba organizowanych wyjazdów", "$tripCreatorNumber"),
                    ),
                    Container(height: 54, child: VerticalDivider(color: Colors.black54, thickness: 1.0, indent: 8.0, endIndent: 1.0,)),
                    Expanded(
                      flex: 1,
                      child: _buildStatItem("Liczba wyjazdów", "$tripsNumber"),
                    )
                  ]
              ),
              Divider(color: Colors.black54, thickness: 1.0, indent: 8.0, endIndent: 8.0,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildStatItem("Ulubiony stok", "$favouriteSlope"),
                  ]
              )
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text( 'Profil' ),
      ),
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: screenSize.height / 2.6),
                _buildName(),
                _buildEmail(context),
                _buildStatContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

}