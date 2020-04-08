
import 'package:betogether/screens/user/profileScreen.dart';
import 'package:betogether/screens/user/signup_screen.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:amazon_cognito_identity_dart_2/src/cognito_client_exceptions.dart';
import 'package:betogether/services/pools_vars.dart' as global;

import 'login_screen.dart';

class SignupLoginScreen extends StatefulWidget {

  @override
  _SignupLoginScreenState createState() => new _SignupLoginScreenState();
}

class _SignupLoginScreenState extends State<SignupLoginScreen> {
  final _userService = new UserService(global.userPool);

  bool _isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new FutureBuilder(
        future: _getValues(),
        builder: (context, AsyncSnapshot<UserService> snapshot) {
          if (snapshot.hasData) {
            if (_isAuthenticated){
              return ProfileScreen();
            }
            else {
              return new Scaffold(
                body: new Center(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        padding:
                        new EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                        width: screenSize.width,
                        child: new RaisedButton(
                          child: new Text(
                            'Sign Up',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SignUpScreen()),
                            );
                          },
                          color: Colors.blue,
                        ),
                      ),
                      new Container(
                        padding:
                        new EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                        width: screenSize.width,
                        child: new RaisedButton(
                          child: new Text(
                            'Login',
                            style: new TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new LoginScreen()),
                            );
                          },
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

          }
          return Center(
            child: new CircularProgressIndicator(),
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
