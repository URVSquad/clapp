import 'package:betogether/main.dart';
import 'package:betogether/models/activity.dart';
import 'package:betogether/models/event.dart';
import 'package:betogether/services/api_service.dart';
import 'package:flutter/material.dart';


class EventScreen extends StatefulWidget {
  final Event event;
  EventScreen({Key key, this.event}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Text("event")
    );
  }
}