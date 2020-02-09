import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                    child: Image.asset("assets/images/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 45.0),
                  new CircularProgressIndicator(
                    value: null,
                  ),
                  SizedBox(height: 45.0),
                  Text('Ładowanie danych',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0))
                ],
              ),
            ),
          ),
        )
    );
  }
}