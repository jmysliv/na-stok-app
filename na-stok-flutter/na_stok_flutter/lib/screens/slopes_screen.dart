import 'package:flutter/material.dart';
import 'package:na_stok_flutter/Widgets/drawer.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';

class SlopesScreen extends StatelessWidget {
  final UserRepository userRepository;
  final List<Slope> slopes;

  SlopesScreen({Key key, @required this.userRepository, @required this.slopes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          drawer: HomeDrawer(),
          appBar: AppBar(
            title: Text('Stoki'),
          ),
          body: Container(
                child: ListView(
                  children: <Widget>[
                   Center(
                       child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: slopes.length,
                          itemBuilder: (context, index) {
                            final slope = slopes[index];
                            return Card(
                              elevation: 8.0,
                              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                              child: Container(
                                decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                                child:ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(width: 1.0, color: Colors.white24))),
                                    child: Icon(Icons.autorenew, color: Colors.white),
                                  ),
                                  title: Text(
                                      slope.name,
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),


                                  subtitle: Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: LinearProgressIndicator(
                                                backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                                                value: 0.2,
                                                valueColor: AlwaysStoppedAnimation(Colors.green)),
                                          )),
                                      Expanded(
                                        flex: 4,
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 10.0),
                                            child: Text(slope.city,
                                                style: TextStyle(color: Colors.white))),
                                      )
                                    ],
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
                                  onTap: () {},
                                ),
                              ),
                            );
                          }))
                  ],
                )
            )
      );
  }
}