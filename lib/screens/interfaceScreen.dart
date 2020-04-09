import 'package:betogether/models/user.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:amazon_cognito_identity_dart_2/src/cognito_user_pool.dart';
import 'package:flutter/material.dart';
import 'addScreen.dart';
import 'homeScreen.dart';
import 'listScreen.dart';

//TODO: This are variables used for the authentication endpoint.
// It is porbably best to refactor this somewhere else. In the meantime
// it stays here.

// Setup AWS User Pool Id & Client Id settings here:
const _awsUserPoolId = 'eu-west-2_G1chdG3tq';
const _awsClientId = '19j1sl25biq0uu4opvp0tv7nkp';

// Setup endpoints here:
const _region = 'eu-west-2';
const _endpoint =
    'https://9gzf9ud1r6.execute-api.eu-west-2.amazonaws.com/dev';

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
    final userPool = new CognitoUserPool(_awsUserPoolId, _awsClientId);
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
          appBar: AppBar(
            title: Text("BeTogether",
                style: TextStyle(color: Colors.orangeAccent),
                textDirection: TextDirection.ltr),
            centerTitle: true,
            backgroundColor: Colors.blueGrey,
          ),
          body: TabBarView(
            children: [
              new HomeScreen(),
              new ListScreen(),
              new AddScreen(),
              open_profile_screen(context)
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

            labelColor: Colors.white,
            unselectedLabelColor: Colors.orangeAccent,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
          ),
          backgroundColor: Colors.blueGrey,
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
            return Text('View Profile');
          }
          else if(_user == null){
            return new Text('Signup/Login Scren');
          }
          else if(!_user.confirmed){
            return new Text("Confirm account");
          }
          else{
            return new Text("Shouldn't be here");
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
      _user = await _userService.getCurrentUser();
      return _userService;
    }
}
