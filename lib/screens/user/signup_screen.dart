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
import '../validators.dart' as validator;
import 'confirmation_screen.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => new _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String confirmationCode;
  User _user = new User();
  final _userService = new UserService(global.userPool);
  final TextEditingController _pass = TextEditingController();
  RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();


  void submit(BuildContext context) async {
    print('HERE');
    if (_formKey.currentState.validate()){
      print('Validated');
      _formKey.currentState.save();

      String message;
      bool signUpSuccess = false;
      try {
        _user = await _userService.signUp(_user.username, _user.password, _user.name, _user.email);
        signUpSuccess = true;
        message = 'Cuenta creada correctamente. Verifica tu cuenta para empezar a usarla.';
      } on CognitoClientException catch (e) {
        print(e);
        if (e.code == 'UsernameExistsException' ||
            e.code == 'InvalidParameterException' ||
            e.code == 'ResourceNotFoundException') {
          message = 'Este nombre de usuario ya existe';
        } else {
          message = 'Error desconocido, disculpa las molestias';
        }
      } catch (e) {
        message = 'Error desconocido, disculpa las molestias';
      }
      if (signUpSuccess) {
        Flushbar flusbar = Modal().flushbar(message);
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
        Flushbar flusbar = Modal().flushbar(message, type: 'error');
        _btnController.error();
        Future.delayed(const Duration(milliseconds: 500), () {
          _btnController.reset();
          flusbar.show(context);
        });
      }
    }
    else{
      Flushbar flusbar = Modal().flushbar('Alguno de los campos es incorrecto', type: 'error');
      _btnController.error();
      Future.delayed(const Duration(milliseconds: 500), () {
        _btnController.reset();
        flusbar.show(context);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Crea tu cuenta'),
      ),
      body: new Builder(
        builder: (BuildContext context) {
          return new Container(
            child: new Form(
              key: _formKey,
              child: new ListView(
                children: <Widget>[
                  new Container(
                    height: 85,
                    child: new ListTile(

                      leading: new Container(
                        padding: EdgeInsets.only(top:5),
                        child: const Icon(Icons.account_box, size: 30, color: Colors.black, ),
                      ),

                      title: new TextFormField(
                        decoration: new InputDecoration(labelText: 'Nombre'),
                        validator: validator.validateName,
                        onSaved: (String name) {
                          _user.name = name;
                        },
                      ),
                    ),
                  ),
                  new Container(
                    height: 85,
                    child: new ListTile(
                      leading: new Container(
                        padding: EdgeInsets.only(top:5),
                        child: const Icon(Icons.alternate_email, size: 30, color: Colors.black, ),
                      ),

                      title: new TextFormField(
                        decoration: new InputDecoration(labelText: 'Nombre de usuario'),
                        keyboardType: TextInputType.text,
                        validator: validator.validateUsername,
                        onSaved: (String username) {
                          _user.username = username;
                        },
                      ),
                    ),
                  ),
                  new Container(
                    height: 85,
                    child: new ListTile(
                      leading: new Container(
                        padding: EdgeInsets.only(top:5),
                        child: const Icon(Icons.email, size: 30, color: Colors.black, ),
                      ),

                      title: new TextFormField(
                        decoration: new InputDecoration(
                            hintText: 'correo@correo.com', labelText: 'Correo electrónico'),
                        keyboardType: TextInputType.emailAddress,
                        validator: validator.validateEmail,
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
                          labelText: 'Contraseña',
                        ),
                        obscureText: true,
                        controller: _pass,
                        validator: validator.validatePassword,
                        onSaved: (String password) {
                          _user.password = password;
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
                          labelText: 'Repite la contraseña',
                        ),
                        validator: matchPassword,
                        obscureText: true,
                        onSaved: (String password) {
                          _user.repeatedPassword = password;
                        },
                      ),
                    ),
                  ),

                  new Container(
                    margin: EdgeInsets.only(top: 10),
                    child: new RoundedLoadingButton(
                      height: 40,
                      color: primaryColor,
                      child: Text('Registrare'),
                      controller: _btnController,
                      onPressed: () {
                        submit(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String matchPassword(String password){
    String result = validator.validatePassword(password);
    if (result != null){
      return result;
    }
    else if(password == _pass.text){
      return null;
    }
    return 'Las contraseñas no coinciden';
  }
}
