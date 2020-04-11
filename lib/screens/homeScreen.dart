import 'package:betogether/main.dart';
import 'package:betogether/models/activity.dart';
import 'package:betogether/services/api_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen() : super();


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Center(
          child: new Text('This is the homescreen'),
        )
    );
  }


}