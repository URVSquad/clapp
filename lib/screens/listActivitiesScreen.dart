import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListActivitiesScreen extends StatefulWidget {
  ListActivitiesScreen() : super();

  @override
  _ListActivitiesScreenState createState() => _ListActivitiesScreenState();
}

class _ListActivitiesScreenState extends State<ListActivitiesScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
      title: Text(
        'Explorar',
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
    ));
  }
}
