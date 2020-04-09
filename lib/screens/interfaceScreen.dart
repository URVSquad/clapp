import 'package:betogether/models/user.dart';
import 'package:betogether/screens/user/confirmation_screen.dart';
import 'package:betogether/screens/user/profileScreen.dart';
import 'package:betogether/screens/user/signup_screen.dart';
import 'package:betogether/screens/user/singup_login_screen.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:amazon_cognito_identity_dart_2/src/cognito_user_pool.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'addScreen.dart';
import 'homeScreen.dart';
import 'listScreen.dart';
import 'package:betogether/services/pools_vars.dart' as global;


class InterfacePage extends StatefulWidget {
  InterfacePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _InterfacePageState createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage> {

  // User variables to share amongst all the screens
  UserService _userService;
  User _user;
  bool _isAuthenticated = false;

  @override
  void initState() {
    final userPool = new CognitoUserPool(global.awsUserPoolId, global.awsClientId);
    _userService = new UserService(userPool);
    _user = new User();
    _userService.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: DefaultTabController(
        length: 4,
        child: new Scaffold(
          body: TabBarView(
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
