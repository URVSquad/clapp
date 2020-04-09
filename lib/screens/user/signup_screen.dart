import 'package:betogether/models/user.dart';
import 'package:betogether/services/cognito_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:betogether/services/pools_vars.dart' as global;
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


  void submit(BuildContext context) async {
    if (_formKey.currentState.validate()){
      _formKey.currentState.save();

      String message;
      bool signUpSuccess = false;
      try {
        _user = await _userService.signUp(_user.username, _user.password, _user.name, _user.email);
        signUpSuccess = true;
        message = 'User sign up successful!';
      } on CognitoClientException catch (e) {
        print(e);
        if (e.code == 'UsernameExistsException' ||
            e.code == 'InvalidParameterException' ||
            e.code == 'ResourceNotFoundException') {
          message = e.message;
        } else {
          message = 'Unknown client error occurred';
        }
      } catch (e) {
        message = 'Unknown error occurred';
      }

      final snackBar = new SnackBar(
        content: new Text(message),
        action: new SnackBarAction(
          label: 'OK',
          onPressed: () {
            if (signUpSuccess) {
              Navigator.pop(context);
              if (!_user.confirmed) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) =>
                      new ConfirmationScreen()),
                );
              }
            }
          },
        ),
        duration: new Duration(seconds: 30),
      );

      Scaffold.of(context).showSnackBar(snackBar);
    }

  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Sign Up'),
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
                        validator: validateName,
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
                        validator: validateUsername,
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
                        validator: validateEmail,
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
                        validator: validatePassword,
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
                    padding: new EdgeInsets.all(20.0),
                    width: screenSize.width,
                    child: new RaisedButton(
                      child: new Text(
                        'Registrarme',
                      ),
                      onPressed: () {
                        submit(context);
                      },
                    ),
                    margin: new EdgeInsets.only(
                      top: 10.0,
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

  String validateName(String text){
    if(text.isEmpty){
      return 'Tienes que introducir tu nombre';
    }
    return null;
  }

  String validateEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    print(regex.allMatches(email));
    if (!regex.hasMatch(email))
      return 'Parece que esto no es un correo electrónico';
    else
      return null;
  }

  String validateUsername(String username){
    Pattern pattern = r'^([\w]+)$';
    RegExp regex = new RegExp(pattern);
    print(regex.allMatches(username));
    if (!regex.hasMatch(username))
      return 'El nombre de usuario solo puede contener letras y\nnúmeros';
    else
      return null;
  }

  String validatePassword(String password){
    if (password != null && password.length < 8){
      return 'La contraseña debe tener almenos 8 carácteres';
    }
    return null;
  }

  String matchPassword(String password){
    String result = validatePassword(password);
    if (result != null){
      return result;
    }
    else if(password == _pass.text){
      return null;
    }
    return 'Las contraseñas no coinciden';
  }
}
