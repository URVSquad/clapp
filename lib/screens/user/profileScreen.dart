import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:betogether/models/user.dart';
import 'package:amazon_cognito_identity_dart_2/src/cognito_client_exceptions.dart';
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

        // get session credentials
        final credentials = await _userService.getCredentials();
      }
      return _userService;
    } on CognitoClientException catch (e) {
      if (e.code == 'NotAuthorizedException') {
        await _userService.signOut();
        Navigator.pop(context);
      }
      throw e;
    }
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
                title: new Text('Secure Counter'),
              ),
              body: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      'Welcome ${_user.name}!',
                      style: Theme.of(context).textTheme.display1,
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