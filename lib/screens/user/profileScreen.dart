import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:betogether/models/user.dart';
import 'package:amazon_cognito_identity_dart_2/src/cognito_client_exceptions.dart';
import 'package:betogether/screens/user/signup_screen.dart';
import 'package:betogether/screens/user/singup_login_screen.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:betogether/services/pools_vars.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _userService = new UserService(global.userPool);
  AwsSigV4Client _awsSigV4Client;
  User _user = new User();
  bool _isAuthenticated = false;
  
  Future<UserService> _getValues(BuildContext context) async {
    try {
      await _userService.init();
      _isAuthenticated = await _userService.checkAuthenticated();
      if (_isAuthenticated) {
        // get user attributes from cognito
        _user = await _userService.getCurrentUser();

      }
      return _userService;
    } on CognitoClientException catch (e) {
      if (e.code == 'NotAuthorizedException') {
        print("HEREEE ProfileScreenState");
        await _userService.signOut();
        setState(() {

        });
      }
      throw e;
    }
  }

  logout(BuildContext context) async {
    String message;
    bool signOutSuccess = false;
    try {
      print("LOGOUT BY PRESSING BUTTON");
      await _userService.signOut();
      message = 'User sucessfully logged out!';
      signOutSuccess = true;
    } on CognitoClientException catch (e) {
      if (e.code == 'InvalidParameterException' ||
          e.code == 'NotAuthorizedException' ||
          e.code == 'UserNotFoundException' ||
          e.code == 'ResourceNotFoundException') {
        message = e.message;
      } else {
        message = 'An unknown client error occured';
      }
    } catch (e) {
      message = 'An unknown error occurred';
    }
    final snackBar = new SnackBar(
      content: new Text(message),
      action: new SnackBarAction(
        label: 'OK',
        onPressed: () async {
          if (signOutSuccess) {
              Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new LoginScreen()),
              );
          }
        },
      ),
      duration: new Duration(seconds: 30),
    );

    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: _getValues(context),
        builder: (context, AsyncSnapshot<UserService> snapshot) {
          if (snapshot.hasData) {
            if (!_isAuthenticated) {
              return new LoginScreen();
            }

            return new Scaffold(
              appBar: new AppBar(
                title: new Text('Mi perfil'),
              ),
              body: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'Bienvenido ${_user.name}!',
                      style: Theme.of(context).textTheme.display1,
                    ),
                    new RaisedButton(
                      child: new Text(
                        'Cerrar sesión',
                        style: new TextStyle(color: Colors.white),
                      ),
                      onPressed: () => logout(context),
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(
            child: new CircularProgressIndicator(),
          );
        });
  }
}