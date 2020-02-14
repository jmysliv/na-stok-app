import 'dart:async';
import 'package:flutter/services.dart';
import 'package:na_stok_flutter/authentication/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:na_stok_flutter/models/slope_model.dart';
import 'package:na_stok_flutter/models/trips_model.dart';
import 'package:na_stok_flutter/repositories/trip_repository.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:geolocator/geolocator.dart';

class AddTripScreen extends StatefulWidget {
  final TripRepository tripRepository;
  final UserRepository userRepository;
  final Slope slope;

  AddTripScreen(this.userRepository, this.tripRepository, this.slope);

  @override
  AddState createState() => AddState(userRepository, tripRepository, slope);
}

class AddState extends State<AddTripScreen>{
  final TripRepository tripRepository;
  final UserRepository userRepository;
  final Slope slope;
  String currentDate;
  String currentTime;
  int maxParticipants;
  int price;
  String address;
  TextEditingController _addressController = TextEditingController();
  final _keyScaffold = GlobalKey<ScaffoldState>();



  AddState(this.userRepository, this.tripRepository, this.slope);

  @override
  void initState() {
    super.initState();
    currentTime = "Ustaw czas wyjazdu";
    currentDate = "Ustaw datę wyjazdu";
    maxParticipants = 1;
    price = 0;
    address = "Ustal miejsce skąd wyruszysz";
  }

  Widget createPicker(Function onPressed, BuildContext context, String text, IconData icon){
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)),
      onPressed: onPressed,
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        icon,
                        size: 18.0,
                        color: Colors.indigo,
                      ),
                      Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _keyScaffold,
      appBar: AppBar(
        title: Text('Zaplanuj wyjazd na stok'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.landscape,
                                      size: 18.0,
                                      color: Colors.indigo,
                                    ),
                                    Text(
                                      " ${slope.name}",
                                      style: TextStyle(
                                          color: Colors.indigo,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                  )),
                  color: Colors.white,
                ),
                SizedBox(
                  height: 20.0,
                ),
                createPicker(() {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                        currentDate = date.toIso8601String().substring(0, 10);
                        setState(() {
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                }, context, " $currentDate", Icons.date_range),
                SizedBox(
                  height: 20.0,
                ),
                createPicker(() {
                  DatePicker.showTimePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (time) {
                        currentTime = time.toIso8601String().substring(11, 19);
                        setState(() {});
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                  setState(() {});
                }, context, " $currentTime", Icons.access_time),
                SizedBox(
                  height: 20.0,
                ),
                createPicker(() {
                  showDialog<int>(
                      context: context,
                      builder: (BuildContext context) {
                        return NumberPickerDialog.integer(
                          minValue: 1,
                          maxValue: 50,
                          title: new Text("Wybierz maksymalną liczbę uczestników wyjazdu"),
                          initialIntegerValue: maxParticipants,
                        );
                      }
                  ).then((int value) {
                    if (value != null) {
                      setState(() => maxParticipants = value);
                    }
                  });
                  }, context, " $maxParticipants", Icons.people),
                SizedBox(
                  height: 20.0,
                ),
                createPicker(() {
                  showDialog<int>(
                      context: context,
                      builder: (BuildContext context) {
                        return NumberPickerDialog.integer(
                          minValue: 0,
                          maxValue: 1000,
                          title: new Text("Wybierz cenę, za którą weźmiesz inne osoby na wyjazd"),
                          initialIntegerValue: price,
                        );
                      }
                  ).then((int value) {
                    if (value != null) {
                      setState(() => price = value);
                    }
                  });
                }, context, " $price", Icons.attach_money),
                SizedBox(
                  height: 20.0,
                ),
                createPicker(() => showAddressPicker(context), context, " $address", Icons.place),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          if(currentTime == "Ustaw czas wyjazdu" || currentDate == "Ustaw datę wyjazdu") {
            _keyScaffold.currentState
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Ustal date i godzinę wyjazdu'), Icon(Icons.error)],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            return;
          }
          try{
            _keyScaffold.currentState..hideCurrentSnackBar()
              ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Ładowanie'), CircularProgressIndicator()],
                    ),
                    backgroundColor: Colors.black,
                  ));
            List<Placemark> placemark = await Geolocator().placemarkFromAddress(address).timeout(const Duration(seconds: 5), onTimeout: () => throw TimeoutException("Wprowadź poprawny adres"));
            Trip trip = Trip(placemark[0].position.longitude, placemark[0].position.latitude, slope.name, new List<String>(), price, maxParticipants, new List<String>(), DateTime.parse("${currentDate} ${currentTime}").add(Duration(hours: 1)).toIso8601String(), (await userRepository.getUser()).id, "id");
            tripRepository.insertTrip(trip).timeout(const Duration(seconds: 10), onTimeout: () => throw TimeoutException('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.')).then((value) {
              _keyScaffold.currentState..removeCurrentSnackBar()..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Dodano wyjazd'), Icon(Icons.check)],
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 1),
                    )).closed.then( (reason) =>  Navigator.of(context).pop());
            } );
          } catch(exception){
            if((exception is TimeoutException && exception.message == "Wprowadź poprawny adres") || exception is PlatformException){
              _keyScaffold.currentState..hideCurrentSnackBar()..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("Wprowadź poprawny adres"), Icon(Icons.error)],
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
            } else {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              if(exception is TimeoutException) BlocProvider.of<AuthenticationBloc>(context).add(ErrorOccurred(errorMessage: exception.message));
              else  BlocProvider.of<AuthenticationBloc>(context).add(ErrorOccurred(errorMessage: exception.toString()));
            }
          }

        },
      ),
    );
  }

  showAddressPicker(BuildContext context) async {
    return showDialog<String>(
        context: context,
        builder: (BuildContext newContext) {
          return AlertDialog(
            title: Text('Podaj miejsce skąd wyruszysz', style: TextStyle(fontSize: 18.0)),
            content: TextField(
              controller: _addressController,
              decoration: InputDecoration(hintText: "Adres"),
            ),
            actions: <Widget>[
              FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(newContext).pop();
                },
              ),
              FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(newContext).pop();
                  address = _addressController.text;
                  setState(() {});
                },
              ),
              FlatButton(
                child: new Text('Użyj obecnej lokalizacji'),
                onPressed: () async {
                  try{
                    _keyScaffold.currentState..hideCurrentSnackBar()
                      ..showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text('Ładowanie'), CircularProgressIndicator()],
                            ),
                            backgroundColor: Colors.black,
                          ));
                    Navigator.of(newContext).pop();
                    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).timeout(const Duration(seconds: 5), onTimeout: () => throw TimeoutException("Żeby aplikacja działała poprawnie, proszę włączyć lokalizację w swoim telefonie, zezwolić aplikacji na dostęp do niej i uruchomić ponownie."));
                    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude).timeout(const Duration(seconds: 5), onTimeout: () => throw TimeoutException("Żeby aplikacja działała poprawnie, proszę włączyć lokalizację w swoim telefonie, zezwolić aplikacji na dostęp do niej i uruchomić ponownie."));
                    Placemark placeMark  = placemark[0];
                    String street = placeMark.thoroughfare;
                    String number = placeMark.subThoroughfare;
                    String locality = placeMark.locality;
                    String subLocality = placeMark.subLocality;
                    String postalCode = placeMark.postalCode;
                    address = "$street $number, ${subLocality}, ${locality}, ${postalCode}";
                    _keyScaffold.currentState..hideCurrentSnackBar();
                    setState(() {});
                  }catch(exception){
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    if(exception is TimeoutException) BlocProvider.of<AuthenticationBloc>(context).add(ErrorOccurred(errorMessage: exception.message));
                    else  BlocProvider.of<AuthenticationBloc>(context).add(ErrorOccurred(errorMessage: exception.toString()));
                  }
                },
              )
            ],
          );
        });
  }
}

