import 'package:flutter/material.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:weather_icons/weather_icons.dart';

class SlopeDetailsScreen extends StatelessWidget {
  final Slope slope;
  final TripRepository tripRepository;
  final UserRepository userRepository;

  SlopeDetailsScreen(this.slope, this.userRepository, this.tripRepository);

  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/details.jpg'),
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
          slope.name,
          style: _nameTextStyle,
        ));
  }

  Widget _buildAddress(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        "${slope.city}, ${slope.address}",
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon((slope.status == "czynny") ? Icons.check : Icons.close, color: Colors.black54 , size: 24.0, ),
                            SizedBox(height: 8.0,),
                            Text((slope.status == "czynny") ? "CZYNNY" : "NIECZYNNY", style: TextStyle(
                              fontFamily: 'Roboto',
                              color: Colors.black,
                              fontSize: 10.0,
                              fontWeight: FontWeight.w200,
                            ),
                            ),
                          ],
                          )
                        )
                    ),
                    Container(height: 54,
                        child: VerticalDivider(color: Colors.black54,
                          thickness: 1.0,
                          indent: 8.0,
                          endIndent: 1.0,)),
                    Expanded(
                      flex: 1,
                      child: _buildStatItem(
                          "Opady śniegu w ciągu ostatnich 5 dni",
                          "${slope.snowFall}cm"),
                    )
                  ]
              ),
              Divider(color: Colors.black54,
                thickness: 1.0,
                indent: 8.0,
                endIndent: 8.0,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildStatItem("Pokrywa śnieżna",
                        "${(slope.conditionEqual != null) ? "${slope
                            .conditionEqual}cm" : "od ${slope
                            .conditionMin}cm do ${slope.conditionMax}cm"}"),
                  ]
              )
            ]
        )
    );
  }

  Widget _makeDay(BuildContext context, Weather weather){
    BoxedIcon icon;
    switch(weather.clouds) {
      case "Lekkie opady śniegu z deszczem":
        icon = BoxedIcon(WeatherIcons.day_rain_mix);
        break;
      case "Lekkie zachmurzenie":
        icon = BoxedIcon(WeatherIcons.day_cloudy);
        break;
      case "Częściowe zachmurzenie":
        icon = BoxedIcon(WeatherIcons.day_cloudy);
        break;
      case "Lekkie opady deszczu":
        icon = BoxedIcon(WeatherIcons.day_showers);
        break;
      case "Przelotne opady":
        icon = BoxedIcon(WeatherIcons.day_sleet);
        break;
      case "light snow showers":
        icon = BoxedIcon(WeatherIcons.day_snow);
        break;
      case "Deszcz":
        icon = BoxedIcon(WeatherIcons.rain);
        break;
      case "Opady śniegu":
        icon = BoxedIcon(WeatherIcons.snow);
        break;
      case "sleet showers":
        icon = BoxedIcon(WeatherIcons.showers);
        break;
      case "Przejrzyste niebo":
        icon = BoxedIcon(WeatherIcons.day_sunny_overcast);
        break;
      case "Deszcz ze śniegiem":
        icon = BoxedIcon(WeatherIcons.rain_mix);
        break;
      case "heavy snow":
        icon = BoxedIcon(WeatherIcons.snow);
        break;
      case "Pochmurno":
        icon = BoxedIcon(WeatherIcons.cloudy);
        break;
      case "Śnieg":
        icon = BoxedIcon(WeatherIcons.snow);
        break;
      case "heavy snow showers":
        icon = BoxedIcon(WeatherIcons.snow);
        break;
      default:
        icon = BoxedIcon(WeatherIcons.day_sunny);
        break;
    }
    return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(weather.day),
              Text(weather.dayName),
              icon,
              Text('${weather.temperature} C°', style: Theme.of(context).textTheme.title,),
            ],
          ),
        );
  }

  Widget buildWeatherContainer(BuildContext context, List<Weather> weathers){
    return Container(
        height: 100.0,
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
              child: _makeDay(context, weathers[0])
            ),
              Container(height: 54,
                  child: VerticalDivider(color: Colors.black54,
                    thickness: 1.0,
                    indent: 1.0,
                    endIndent: 1.0,)),
            Expanded(
                flex: 1,
                child: _makeDay(context, weathers[1])
            ),
              Container(height: 54,
                  child: VerticalDivider(color: Colors.black54,
                    thickness: 1.0,
                    indent: 1.0,
                    endIndent: 1.0,)),
            Expanded(
                flex: 1,
                child: _makeDay(context, weathers[2])
            )
          ])]
        ));
  }

  Widget _buildButtonColumn(IconData icon, String label, BuildContext context) {
    return MaterialButton(
        onPressed: (){ Navigator.pop(context);},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ));
  }

  Widget buildButtons(BuildContext context){
    return Container(
      height: 60.0,
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
                  child: _buildButtonColumn(Icons.near_me, 'NAWIGUJ', context),
                ),
                Container(height: 54,
                    child: VerticalDivider(color: Colors.black54,
                      thickness: 1.0,
                      indent: 1.0,
                      endIndent: 1.0,)),
                Expanded(
                  flex: 1,
                  child: _buildButtonColumn(Icons.add, 'ZAPLANUJ WYJAZD', context),
                ),
          ])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Stok ${slope.name}'),
      ),
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: screenSize.height / 20),
                _buildName(),
                _buildAddress(context),
                SizedBox(height: screenSize.height / 8.3,),
                _buildStatContainer(),
                buildWeatherContainer(context, slope.weatherList),
                buildButtons(context)
              ],
            ),
          ),
        ],
      ),
    );
  }
}