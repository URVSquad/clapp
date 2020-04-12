import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:betogether/main.dart';
import 'package:betogether/models/listActivities.dart';
import 'package:betogether/models/listEvents.dart';
import 'package:betogether/models/user.dart';
import 'package:amazon_cognito_identity_dart_2/src/cognito_client_exceptions.dart';
import 'package:betogether/screens/listEventsScreen.dart';
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
import '../listActivitiesScreen.dart';
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
        print(user.sub);
        APIService api = new APIService();
        Future<ListEvents> futureEventsList = api.getEvents(); //user.sub
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

  GestureDetector event(String title, String color, String claim) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _loading = true;
          });
          Future<User> user = _userService.getCurrentUser();
          user.then((user) async  {
            APIService api = new APIService();
            Future<ListEvents> futureList = api.getEventsByUser(user.sub);
            futureList.then((list) async {
              setState(() {
                _loading = false;
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ListEventsScreen(list, title, claim, color)),
              );
            });
          });
        },
        child: Container(
          child: Card(
            elevation: 5,
            color: Color(int.parse(color)),
            child: Center(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
          ),
        ));
  }

  GestureDetector category(
      String title, String emoji, String color, String claim) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _loading = true;
          });
          APIService api = new APIService();
          Future<ListActivities> futureList = api.getActivities();
          futureList.then((list) async {
            setState(() {
              _loading = false;
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ListActivitiesScreen(list, title, claim, color)),
            );
          });
        },
        child: Container(
          child: Card(
            color: Color(int.parse(color)),
            elevation: 5,
            child: Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    emoji,
                    style: TextStyle(fontSize: 30),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget events() {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: 1,
      childAspectRatio: 3,
      children: <Widget>[
        event("Top semanal", "0xffffecb3", "¿Ready para petarlo?"),
        event("Ejercicio", "0xffffecb3", "💪 ¡no te muevas solo!"),
        event("Cultura", "0xffffecb3", "Self love club 📚"),
        event("Peques", "0xffffecb3", "Planazos a pequeña escala. 👻"),
        event("Party time", "0xffffecb3",
            "¡La vida hay que celebrarla! desde casa. 🏡"),
        event("Otros", "0xffffecb3", "Planazos de otro mundo 🚀  "),
      ],
    );
  }

  Widget categories() {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      children: <Widget>[
        category(
            "TOP semanal", "🔝", "0xfffff3e0", "Lo mejor para ti, claro ⚡️📆"),
        category("Podcast", "🎤", "0xfffbfbe9e7", "Bla Bla Bla 💬"),
        category(
            "Ejercicio", "🤸‍️", "0xffefebe9", "Mente sana en body sudado 💦"),
        category("Recetas", "🍪", "0xffe8eaf6",
            "El equilibro está en recetas saludables y un cocktail para celebrar lo que te cuidas. 🍹"),
        category("Audiovisual", "📽", "0xffede7f6",
            "Junto a la ducha, el mejor momento del día.\nDisfrútalo, te lo mereces. 🎬"),
        category("Libros", "📚", "0xffe0f2f1", " Libro’s club 📚💭"),
        category("Juegos", "👾", "0xffeffebee",
            "💡 ¡Es la hora de jugar! cuidado con los tramposos 👾"),
        category("Peques", "🐥", "0xfff9fbe7",
            "Entretener a los peques es un súper poder 🐣"),
      ],
    );
  }

  Widget userprofile() {
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

  Widget test_categories(){
    if (listActivities.list == null){
      return new Text('No hay data');
    }
    else{
      return ListActivitiesScreen(listActivities, 'hola', 'CLAIM', '0xffe0f2f1');
    }

  }


  Widget user(){
    if (_user.name == null){
      return new Text('');
    }
    else{
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
            children: [user(),test_categories(),test_categories()],
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
