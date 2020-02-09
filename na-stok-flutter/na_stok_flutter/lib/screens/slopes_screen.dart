import 'package:flutter/material.dart';
import 'package:na_stok_flutter/Widgets/drawer.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:percent_indicator/percent_indicator.dart';


class SlopesScreen extends StatelessWidget {
  final UserRepository userRepository;
  final List<Slope> slopes;
  final int maxSnow;

  SlopesScreen({Key key, @required this.userRepository, @required this.slopes, @required this.maxSnow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          drawer: HomeDrawer(),
          appBar: AppBar(
            title: Text('Stoki'),
          ),
          body: Container(
                child: Center(
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
                                              percent: (slope.conditionMin != null) ? slope.conditionMin/maxSnow : slope.conditionEqual/maxSnow,
                                              center: Text("${(slope.conditionMin != null) ? slope.conditionMin : slope.conditionEqual}cm śniegu", style: TextStyle(fontSize: 14.0),),
                                              linearStrokeCap: LinearStrokeCap.butt,
                                              progressColor: (slope.conditionMin != null) ? ((slope.conditionMin/maxSnow > 0.4) ? Colors.green : Colors.red): ((slope.conditionEqual/maxSnow > 0.4) ? Colors.green : Colors.red),
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
                                  onTap: () {},
                                ),
                              ),
                            );
                          }))
                )
      );
  }
}