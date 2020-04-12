import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:betogether/main.dart';
import 'package:betogether/models/listActivities.dart';
import 'package:betogether/models/listEvents.dart';
import 'package:betogether/models/user.dart';
import 'package:amazon_cognito_identity_dart_2/src/cognito_client_exceptions.dart';
import 'package:betogether/screens/list_screens/listActivitiesModule.dart';
import 'package:betogether/screens/list_screens/listActivitiesScreen.dart';
import 'package:betogether/screens/list_screens/listEventsModule.dart';
import 'package:betogether/screens/modals/flushbar_modal.dart';
import 'package:betogether/screens/user/signup_screen.dart';
import 'package:betogether/screens/user/singup_login_screen.dart';
import 'package:betogether/services/api_service.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:betogether/services/pools_vars.dart' as global;
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../interfaceScreen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen() : super();

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final tabList = ['Perfil', 'Actividades', 'Eventos'];
  TabController _tabController;

  bool _loading = true;
  final _userService = new UserService(global.userPool);
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
      message = 'Se ha cerrado la sesión del usuario';
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
        },
      ),
      duration: new Duration(seconds: 5),
    );

    //Scaffold.of(context).showSnackBar(snackBar);
    if (signOutSuccess) {
      Flushbar flushbar = Modal().flushbar(message);
      Navigator.pushReplacement(
        context,
        new MaterialPageRoute(
            builder: (context) =>
            new InterfacePage(flushbar:flushbar,)),
      );

    }
  }

  ListActivities listActivities = new ListActivities();
  ListEvents listEvents = new ListEvents();
  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabList.length);
    super.initState();
    print('fsdfd');
    Future<bool> session_valid = _userService.init();
    session_valid.then((session_valid) async {
      Future<User> user = _userService.getCurrentUser();
      user.then((user) async  {
        _user = user;
        //print(user.is_enterprise);
        APIService api = new APIService();
        Future<ListEvents> futureEventsList = api.getEventsByUser(user.sub); //user.sub
        futureEventsList.then((list) async {
          setState(() {
            listEvents = list;
          });
        });

        Future<ListActivities> futureAcitivtiesList = api.getActivitiesByUser(user.sub); //user.sub
        futureAcitivtiesList.then((list) async {
          setState(() {
            listActivities = list;
          });
        });

        setState(() {
          _loading = false;
        });

      });
    });

  }


  Widget userprofile() {
    if(_user.is_enterprise == null){
      return Text('');
    }
    else if (_user.is_enterprise){
      return enterprise();
    }
    else{
      return user();
    }

  }

  Widget user(){
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("Bienvenidx ${_user.name}", style: title,),
          new Container(
            margin: EdgeInsets.all(10),
          ),
          new RaisedButton(
            child: new Text(
              'Cerrar sesión',
            ),
            onPressed: () => logout(context),
          ),
        ],
      ),
    );
  }
  Widget enterprise(){
    return Container(
      margin: EdgeInsets.all(20),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text(_user.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
          new Container(
            width: double.infinity,
            child: new RaisedButton(

              onPressed: () => {},
              color: primaryColorDark,
              child: Text('Visitar página web'),
            ),
          ),
          new Container(
            margin: EdgeInsets.all(10),
          ),
          new Text(_user.description),
          new Container(
            margin: EdgeInsets.all(10),
          ),
          new Container(
            width: double.infinity,
            child: new RaisedButton(
              child: new Text(
                'Cerrar sesión',
              ),
              onPressed: () => logout(context),
            ),
          )

        ],
      ),
    );
  }

  Widget test_activties(){
    if (listActivities.list == null || listActivities.getLength() == 0){
      return no_data();
    }
    else{
      return ListActivitiesModule(listActivities, 'Estas son tu actividades publicadas', '0xfffafafa');
    }
  }

  Widget test_events(){
    if (listEvents.list == null || listEvents.getLength() == 0){
      return no_data();
    }
    else{
      return ListEventsModule(listEvents, 'Estos son tus eventos publicados', '0xfffafafa');
    }
  }

  Widget no_data(){
    return new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text('Parece que no has publicado nada aquí aún', style: TextStyle(fontWeight: FontWeight.bold),),
            new Text('')
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _loading,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Mi Perfil',
            ),
            centerTitle: true,
            bottom: TabBar(
              controller: _tabController,
              tabs: tabList.map((item) {
                return Tab(text: item);
              }).toList(),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [userprofile(),test_activties(),test_events()],
          ),
        ));
  }
}

/*

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
    message = 'Se ha cerrado la sesión del usuario';
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
      },
    ),
    duration: new Duration(seconds: 5),
  );

  //Scaffold.of(context).showSnackBar(snackBar);
  if (signOutSuccess) {
    Flushbar flushbar = Modal().flushbar(message);
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(
          builder: (context) =>
          new InterfacePage(flushbar:flushbar,)),
    );

  }
}

Widget user(){
  return Container(
    margin: EdgeInsets.all(20),
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        new Text(_user.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
        new Container(
          width: double.infinity,
          child: new RaisedButton(

            onPressed: () => {},
            color: primaryColorDark,
            child: Text('Visitar página web'),
          ),
        ),
        new Text(_user.description),
        new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new RaisedButton(
              child: new Text(
                'Cerrar sesión',
              ),
              onPressed: () => logout(context),
            ),
          ],
        )

      ],
    ),
  );
}

*/
