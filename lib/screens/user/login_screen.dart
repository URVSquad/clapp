

import 'dart:io';

import 'package:betogether/main.dart';
import 'package:betogether/models/user.dart';
import 'package:betogether/screens/homeScreen.dart';
import 'package:betogether/screens/interfaceScreen.dart';
import 'package:betogether/screens/modals/flushbar_modal.dart';
import 'package:betogether/screens/user/profileScreen.dart';

import 'package:betogether/services/cognito_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:betogether/services/pools_vars.dart' as global;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'confirmation_screen.dart';
import '../validators.dart' as validator;

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.email, this.flushbar}) : super(key: key);

  final String email;
  Flushbar flushbar;

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _userService = new UserService(global.userPool);
  User _user = new User();
  RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();


  @override
  void initState() {
    super.initState();
    if(widget.flushbar != null){
      WidgetsBinding.instance.addPostFrameCallback((_) => {widget.flushbar.show(context)});
    }
  }

  Future<String> _do_request() async{
    String message;
    try {
      _user = await _userService.login(_user.email, _user.password);
      message = 'Sesión iniciada correctamente. Bienvenidx ${_user.name}';
      if (!_user.confirmed) {
        message = 'Es necesiario verificar la cuenta antes de iniciar sesión.';
      }
    } on CognitoClientException catch (e) {
      if (e.code == 'InvalidParameterException' ||
          e.code == 'NotAuthorizedException' ||
          e.code == 'UserNotFoundException' ||
          e.code == 'ResourceNotFoundException') {
        message = 'Usuario o contraseña incorrecta';
      } else {
        message = 'Error desconocido, disculpa las molestias';
      }
    } catch (e) {
      message = 'Error desconocido, disculpa las molestias';
    }

    return message;
  }

  submit(BuildContext context) async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      String message = await _do_request();

      if (_user.hasAccess) {
        Flushbar flusbar = Modal().flushbar(message);
        if(!_user.confirmed){
          _btnController.success();
          Future.delayed(const Duration(milliseconds: 500), () {
            _btnController.reset();
            Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                  new ConfirmationScreen(email: _user.email, flushbar:flusbar)),
            );
          });
        }
        else{
          _btnController.success();
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                    new InterfacePage(flushbar: flusbar,)),
              );
            });
          });

        }
      }
      else {
        _btnController.error();
        Modal().flushbar('Usuario o contraseña incorrectos', type: 'error').show(context);
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _btnController.reset();

          });
        });
        //TOD: Show error
      }
    }
    else{
      _btnController.error();
      Modal().flushbar('Alguno de los campos introducidos presenta algun error.', type: 'error').show(context);
      Future.delayed(const Duration(milliseconds: 500), () {
        _btnController.reset();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Iniciar sesión'),
      ),
      body: new Builder(
        builder: (BuildContext context) {
          return new Container(
            child: new ListView(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 30),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      new Text('¡Es lo más tenerte\nen Clapp!', style: title),
                      new Text('¿Ready para petarlo? 🚀', style: subtitle,)
                    ],
                  ),
                ),
                new Container(
                  child: new Form(
                    key: _formKey,
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          height: 85,
                          child: new ListTile(
                            leading: new Container(
                              padding: EdgeInsets.only(top:5),
                              child: const Icon(Icons.person, size: 30, color: Colors.black, ),
                            ),
                            title: new TextFormField(
                              initialValue: widget.email,
                              decoration: new InputDecoration(
                                  labelText: 'Correo electrónico'),
                              keyboardType: TextInputType.emailAddress,
                              validator: (String text){
                                if(text.isEmpty){
                                  return 'Este campo no puede estar vacio';
                                }
                                return null;
                              },
                              onSaved: (String email) {
                                _user.email = email;
                              },
                            ),
                          ),
                        ),
                        new Container(
                          height: 85,
                          child: new ListTile(
                            leading: new Container(
                              padding: EdgeInsets.only(top:5),
                              child: const Icon(Icons.lock, size: 30, color: Colors.black, ),
                            ),
                            title: new TextFormField(
                              decoration:
                              new InputDecoration(labelText: 'Contraseña'),
                              obscureText: true,
                              validator: (String text){
                                if(text.isEmpty){
                                  return 'Este campo no puede estar vacio';
                                }
                                return null;
                              },
                              onSaved: (String password) {
                                _user.password = password;
                              },
                            ),
                          ),
                        ),
                        new Container(
                          margin: EdgeInsets.only(top: 10),
                          child: new RoundedLoadingButton(
                            height: 40,
                            color: primaryColor,
                            child: Text('Acceder'),
                            controller: _btnController,
                            onPressed: () {
                              submit(context);
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
                                      new ConfirmationScreen(email: _user.email)),
                                );
                              },
                              child: new Text("Quiero verificar mi cuenta", style: new TextStyle(color: primaryColorDark, decoration: TextDecoration.underline),),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          );
        },
      ),
    );
  }
}
