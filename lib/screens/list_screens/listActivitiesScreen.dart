import 'package:betogether/models/listActivities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:betogether/screens/list_screens/listActivitiesModule.dart';

class ListActivitiesScreen extends StatefulWidget {
  final ListActivities list;
  final String title;
  final String claim;
  final String color;

  ListActivitiesScreen(this.list, this.title, this.claim, this.color) : super();

  @override
  _ListActivitiesScreenState createState() =>
      _ListActivitiesScreenState(this.list, this.title, this.claim, this.color);
}

class _ListActivitiesScreenState extends State<ListActivitiesScreen> {
  final ListActivities list;
  final String title;
  final String claim;
  final String color;

  _ListActivitiesScreenState(this.list, this.title, this.claim, this.color)
      : super();

  ListActivitiesModule listActivitiesModule;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(int.parse(color)),
          title: Text(
            title,
          ),
        ),
        body: ListActivitiesModule(list, claim, color));
  }
}
