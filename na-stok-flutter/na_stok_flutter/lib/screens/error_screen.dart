import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            child: SingleChildScrollView(
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
                    Text('Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.',
                        style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0))
                  ],
                ),
              ),
          ),
        )
        )
    );
  }
}