import 'package:betogether/models/user.dart';
import 'package:betogether/screens/modals/flushbar_modal.dart';
import 'package:betogether/services/api_service.dart';
import 'package:betogether/services/pools_vars.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:betogether/services/cognito_service.dart';
import '../../main.dart';
import '../interfaceScreen.dart';
import 'newItemScreen.dart';

class AddScreen extends StatefulWidget {
  AddScreen() : super();

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom:60, left: 40, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      new Text('Que tipo de recurso quieres compartir?', style: title),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                  width: screenSize.width,
                  child: RaisedButton(
                    child: Text('Actividad', style: TextStyle(fontSize: 20)),
                    onPressed: () async {
                      UserService _userService = new UserService(userPool);
                      if(await _userService.checkAuthenticated()) {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new NewItemScreen(false)),
                        );
                      }else{
                        Modal().flushbar('Necesitas una cuenta para poder añadir un recurso!').show(context);
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
                  width: screenSize.width,
                  child: RaisedButton(
                    child: Text('Evento', style: TextStyle(fontSize: 20)),
                    onPressed: () async {
                      UserService _userService = new UserService(userPool);
                      if(await _userService.checkAuthenticated()) {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new NewItemScreen(false)),
                        );
                      }else{
                        Modal().flushbar('Neceistas una cuenta para poder añadir un recurso!').show(context);
                      }
                    },
                  ),
                ),
        ])));
  }
}
