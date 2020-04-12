
import 'dart:async';

import 'package:betogether/main.dart';
import 'package:betogether/screens/user/profileScreen.dart';
import 'package:betogether/screens/user/signup_enterprise_screen.dart';
import 'package:betogether/screens/user/signup_screen.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:amazon_cognito_identity_dart_2/src/cognito_client_exceptions.dart';
import 'package:betogether/services/pools_vars.dart' as global;

import 'login_screen.dart';

class SignupLoginScreen extends StatefulWidget {

  SignupLoginScreen({Key key, this.flushbar}) : super(key: key);

  Flushbar flushbar;

  @override
  _SignupLoginScreenState createState() => new _SignupLoginScreenState();
}

class _SignupLoginScreenState extends State<SignupLoginScreen> {
  final _userService = new UserService(global.userPool);
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    if(widget.flushbar != null){
      WidgetsBinding.instance.addPostFrameCallback((_) => {widget.flushbar.show(context)});
    }
  }
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new FutureBuilder(
        future: _getValues(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (_isAuthenticated){
              return ProfileScreen();
            }
            else {
              return new Scaffold(
                body: new Container(
                  margin: EdgeInsets.only(bottom:60, left: 40, right: 40),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(bottom: 100),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('Hey 👋', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, ),),
                            new Text('¡Estás apunto de ver tu perfil en Clapp!💬', style: TextStyle(fontSize: 25),),

                          ],
                        ),
                      ),
                      new Center(
                        child: new Container(
                          width: screenSize.width,
                          child: new RaisedButton(
                            color: primaryColorDark,
                            child: new Text(
                              'Regístrate',
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new SignUpScreen()),
                              );
                            },
                          ),
                        ),
                      ),
                      new Text('o si ya tienes una cuenta'),
                      new Container(
                        width: screenSize.width,
                        child: new RaisedButton(
                          child: new Text(
                            'Inicia sesión',
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new LoginScreen()),
                            );
                          },
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 20),
                        child: new Center(
                          child: new GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                    new SignUpEnterpriseScreen()),
                              );
                            },
                            child: new Text("Soy una empresa", style: new TextStyle(color: primaryColorDark, decoration: TextDecoration.underline),),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              );
            }

          }
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: new CircularProgressIndicator(
                backgroundColor: Colors.white,

              ),
            ),
          );
        }
    );

  }

  Future<UserService> _getValues() async {
    await _userService.init();
    _isAuthenticated = await _userService.checkAuthenticated();
    await _userService.getCurrentUser();
    return _userService;
  }
}
