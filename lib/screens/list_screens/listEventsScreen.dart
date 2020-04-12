import 'package:betogether/models/listEvents.dart';
import 'package:betogether/screens/list_screens/listEventsModule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListEventsScreen extends StatefulWidget {
  final ListEvents list;
  final String title;
  final String claim;
  final String color;

  ListEventsScreen(this.list, this.title, this.claim, this.color) : super();

  @override
  _ListEventsScreenState createState() =>
      _ListEventsScreenState(this.list, this.title, this.claim, this.color);
}

class _ListEventsScreenState extends State<ListEventsScreen> {
  final ListEvents list;
  final String title;
  final String claim;
  final String color;

  _ListEventsScreenState(this.list, this.title, this.claim, this.color)
      : super();

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
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        body: ListEventsModule(list, claim, color));
  }
}
