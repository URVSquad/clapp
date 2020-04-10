import 'package:amazon_cognito_identity_dart_2/src/cognito_user_pool.dart';
import 'package:betogether/screens/user/profileScreen.dart';
import 'package:betogether/screens/user/singup_login_screen.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:betogether/services/pools_vars.dart' as global;
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'add/addScreen.dart';
import 'homeScreen.dart';
import 'listScreen.dart';


class InterfacePage extends StatefulWidget {
  InterfacePage({Key key, this.title, this.flushbar}) : super(key: key);
  final String title;
  Flushbar flushbar;

  @override
  _InterfacePageState createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage> {

  // User variables to share amongst all the screens
  UserService _userService;
  bool _isAuthenticated = false;

  @override
  void initState() {
    final userPool = new CognitoUserPool(global.awsUserPoolId, global.awsClientId);
    _userService = new UserService(userPool);
    _userService.init();
    super.initState();
    if(widget.flushbar != null){
      WidgetsBinding.instance.addPostFrameCallback((_) => {widget.flushbar..show(context)});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: DefaultTabController(
        length: 4,
        child: new Scaffold(
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              new HomeScreen(),
              new ListScreen(),
              new AddScreen(),
              new SignupLoginScreen()
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.list),
              ),
              Tab(
                icon: new Icon(Icons.add),
              ),
              Tab(
                icon: new Icon(Icons.person),
              )
            ],
          ),
          backgroundColor: primaryColor,
        ),
      ),
    );
  }


  Widget open_profile_screen(BuildContext context){
    return new FutureBuilder(
      future: _getValues(),
      builder: (context, AsyncSnapshot<UserService> snapshot) {
        if (snapshot.hasData) {
          if (_isAuthenticated){
            return ProfileScreen();
          }
          else {
            return new SignupLoginScreen();
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
