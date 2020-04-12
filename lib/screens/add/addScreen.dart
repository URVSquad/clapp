import 'package:flutter/material.dart';

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
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
            width: screenSize.width,
            child: RaisedButton(
              child: Text('Actividad', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new NewItemScreen(false)),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
            width: screenSize.width,
            child: RaisedButton(
              child: Text('Evento', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new NewItemScreen(true)),
                );
              },
            ),
          ),
        ])));
  }
}