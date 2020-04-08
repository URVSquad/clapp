import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen() : super();

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      //Here
      body:
        ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context, int index) {

          }
        ),
    );
  }
}