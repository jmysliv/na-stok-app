import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na_stok_flutter/bloc_/login/login.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:na_stok_flutter/bloc_/authentication/authentication.dart';
import 'package:na_stok_flutter/screens/register_screen.dart';

class LoginScreen extends StatelessWidget{
  final UserRepository _userRepository;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
            if(state.isLoading && state.isFailure){
              BlocProvider.of<AuthenticationBloc>(context).add(ErrorOccurred(errorMessage: 'Wychodzi na to, że nie masz połączenia z internetem, lub nastąpiły chwilowe problemy z serwerem. Sprawdź swoję połaczenie i uruchom aplikacje ponownie.'));
            }
            else if (state.isFailure) {
              Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Podane dane są nieprawidłowe'), Icon(Icons.error)],
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
            else if (state.isSuccess) {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
            }
            else if(state.isLoading){
              Scaffold.of(context)
                ..removeCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Logowanie, prosze czekać'), CircularProgressIndicator()],
                    ),
                    backgroundColor: Colors.black,
                    duration: Duration(seconds: 10),
                  ));
            }
          },
        child: Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: new SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 155.0,
                            child: Image.asset(
                              "assets/images/logo.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 45.0),
                          TextFormField(
                            controller: _emailController,
                            obscureText: false,
                            style: TextStyle(
                                fontFamily: 'Montserrat', fontSize: 20.0),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                hintText: "Email",
                                border:
                                OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Pole nie może być puste";
                              }
                              if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return "Niepoprawny format email";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 25.0),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            style: TextStyle(
                                fontFamily: 'Montserrat', fontSize: 20.0),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(
                                    20.0, 15.0, 20.0, 15.0),
                                hintText: "Hasło",
                                border:
                                OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Pole nie może być puste";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 35.0),
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.blue[900],
                            child: MaterialButton(
                              minWidth: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  BlocProvider.of<LoginBloc>(context).add(
                                      LoginButtonPressed(
                                          email: this._emailController.text,
                                          password: this._passwordController
                                              .text));
                                }
                              },
                              child: Text("Zaloguj",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 20.0)
                                      .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.blue[900],
                            child: MaterialButton(
                              minWidth: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              padding: EdgeInsets.fromLTRB(
                                  20.0, 15.0, 20.0, 15.0),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) {
                                      return RegisterScreen(
                                          userRepository: _userRepository);
                                    }));
                              },
                              child: Text("Załóż konto",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 20.0)
                                      .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
      ),
    );
  }
}
