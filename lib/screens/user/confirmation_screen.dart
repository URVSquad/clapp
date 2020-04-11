
import 'package:betogether/models/user.dart';
import 'package:betogether/screens/modals/flushbar_modal.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:betogether/services/pools_vars.dart' as global;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../../main.dart';
import 'login_screen.dart';

class ConfirmationScreen extends StatefulWidget {
  ConfirmationScreen({Key key, this.email, this.flushbar}) : super(key: key);

  final String email;
  Flushbar flushbar;

  @override
  _ConfirmationScreenState createState() => new _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String confirmationCode;
  User _user = new User();
  final _userService = new UserService(global.userPool);
  Flushbar flushbar;
  RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  bool accountConfirmed;
  @override
  void initState() {
    super.initState();
    if(widget.flushbar != null){
      WidgetsBinding.instance.addPostFrameCallback((_) => {widget.flushbar..show(context)});
    }
  }

  Future<String> _send_request() async{
    _formKey.currentState.save();
    String message;
    try {
      accountConfirmed =
          await _userService.confirmAccount(_user.email, confirmationCode);
      message = 'Cuenta verificada. Ya puedes iniciar sesión con tus credenciales';
    } on CognitoClientException catch (e) {
      if (e.code == 'InvalidParameterException' ||
          e.code == 'CodeMismatchException' ||
          e.code == 'NotAuthorizedException' ||
          e.code == 'UserNotFoundException' ||
          e.code == 'ResourceNotFoundException') {
        //TODO:This should be handled better
        message = 'Código de verificación o usuario incorrecto';
      } else {
        message = 'Error desconocido, disculpa las molestias';
      }
    } catch (e) {
      message = 'Error desconocido, disculpa las molestias';
    }
    return message;
  }

  _submit(BuildContext context) async {
    if (_formKey.currentState.validate()){

      String message = await _send_request();
      Flushbar flusbar = Modal().flushbar(message);

      if (accountConfirmed) {
        _btnController.success();
        Future.delayed(const Duration(milliseconds: 500), () {
          _btnController.reset();
          Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                new LoginScreen(email: _user.email, flushbar:flusbar)),
          );
        });
      }
      else{
        _btnController.error();
        Future.delayed(const Duration(milliseconds: 500), () {
          _btnController.reset();
          flusbar.show(context);
        });
    }
    }
    else{
      Flushbar flusbar = Modal().flushbar('Alguno de los campos introducidos presenta algun error.', type: 'error');
      _btnController.error();
      Future.delayed(const Duration(milliseconds: 500), () {
        _btnController.reset();
        flusbar.show(context);
      });
    }
  }

  _resendConfirmation(BuildContext context) async {
    _formKey.currentState.save();
    bool code_sent = false;
    if(_user.email != ''){
      String message;
      try {
        await _userService.resendConfirmationCode(_user.email);
        message = 'Código de verificación enviado a ${_user.email}!';
        code_sent = true;
      } on CognitoClientException catch (e) {
        if (e.code == 'LimitExceededException' ||
            e.code == 'InvalidParameterException' ||
            e.code == 'ResourceNotFoundException') {
          message = 'Máximo número de verificaciones enviados.';
        } else {
          message = 'Error desconocido, disculpa las molestias';
        }
      } catch (e) {
        message = 'Error desconocido, disculpa las molestias';
      }

      if(code_sent){
           Flushbar flushbar = Modal().flushbar(message);
           flushbar.show(context);
      }
      else{
        Flushbar flushbar = Modal().flushbar(message);
        flushbar.show(context);
      }

    }
    else{
      Modal().flushbar('Debes introducir un usuario o correo electrónico', type: 'error').show(context);
      Future.delayed(const Duration(milliseconds: 500), () {
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Verificar cuenta'),
      ),
      body: new Builder(
          builder: (BuildContext context) => new Container(
            child: new Form(
              key: _formKey,
              child: new ListView(
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top:20, left: 20, right: 20, bottom: 10),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text('¡Sólo un paso más!', style: title,),
                        new Text('Revisa tu correo electrónico, allí encontrarás el código que necesitas. 👀', style: subtitle,)
                      ],
                    ),
                  ),
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
                            labelText: 'Nombre de usuario o correo'),
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
                        decoration: new InputDecoration(
                            labelText: 'Código de verificación'),
                        validator: (String text){
                          if(text.length != 6){
                            return 'El código de verificación debe tener 6 dígitos';
                          }
                          return null;
                        },
                        onSaved: (String code) {
                          confirmationCode = code;
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
                        _submit(context);
                      },
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 20),
                    child: new Center(
                      child: new GestureDetector(

                        onTap: () { _resendConfirmation(context);},
                        child: new Text("Reenviar código de verificación", style: new TextStyle(color: primaryColorDark, decoration: TextDecoration.underline),),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
