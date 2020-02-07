import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:na_stok_flutter/register/register.dart';
import 'package:na_stok_flutter/repositories/user_repository.dart';
import 'package:na_stok_flutter/authentication/authentication.dart';

class RegisterScreen extends StatelessWidget {
  final UserRepository _userRepository;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RegisterScreen({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Załóż konto')),
      body: Center(
        child: BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(userRepository: _userRepository),
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state.isSuccess) {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
                Navigator.of(context).pop();
              }
              if (state.isFailure) {
                Scaffold.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Registration Failure'),
                          Icon(Icons.error),
                        ],
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                return Center(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(36.0),
                      child: new SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                            SizedBox(height: 45.0),
                              TextFormField(
                                controller: _nameController,
                                onChanged: (text){
                                  BlocProvider.of<RegisterBloc>(context).add(nameTouched());
                                },
                                autovalidate: true,
                                obscureText: false,
                                style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                    hintText: "Imie",
                                    border:
                                    OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                                validator: (value){
                                  if(state.nameTouched == false) return null;
                                  if(value.isEmpty) {
                                    return "Pole nie może być puste";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 25.0),
                            TextFormField(
                              controller: _emailController,
                              onChanged: (text){
                                BlocProvider.of<RegisterBloc>(context).add(emailTouched());
                              },
                              autovalidate: true,
                              obscureText: false,
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Email",
                                border:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                              validator: (value){
                                if(state.emailTouched == false) return null;
                                if(value.isEmpty) {
                                  return "Pole nie może być puste";
                                }
                                if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                                  return "Niepoprawny format email";
                                }
                                  return null;
                                },
                            ),
                            SizedBox(height: 25.0),
                            TextFormField(
                              controller: _passwordController,
                              onChanged: (text){
                                BlocProvider.of<RegisterBloc>(context).add(passwordTouched());
                              },
                              obscureText: true,
                              autovalidate: true,
                              style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Hasło",
                                border:
                                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                              validator: (value){
                                if(state.passwordTouched == false) return null;
                              if(value.isEmpty) {
                                return "Pole nie może być puste";
                              }
                              if(!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(value)){
                                return "Hasło musi się składać z 8 liter, cyfr.";
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
                                minWidth: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                onPressed: () async {
                                  BlocProvider.of<RegisterBloc>(context).add(nameTouched());
                                  BlocProvider.of<RegisterBloc>(context).add(emailTouched());
                                  BlocProvider.of<RegisterBloc>(context).add(passwordTouched());
                                  if(state.emailTouched && state.passwordTouched && state.nameTouched &&_formKey.currentState.validate()){
                                    BlocProvider.of<RegisterBloc>(context).add(Submitted(email: this._emailController.text, password: this._passwordController.text, name: _nameController.text));
                                  }
                                },
                                child: Text("Stwórz konto",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0).copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                            ),
                            SizedBox(height: 15.0),
                            ]
                          ),
                        ),
                      ),
                    ),
                   ),
                  );}
                ),
            ),
          ),
        ),
      );
  }

}