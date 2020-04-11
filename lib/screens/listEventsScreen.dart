import 'package:betogether/models/activity.dart';
import 'package:betogether/models/event.dart';
import 'package:betogether/models/listActivities.dart';
import 'package:betogether/models/listEvents.dart';
import 'package:betogether/screens/single_views/activity_screen.dart';
import 'package:betogether/screens/single_views/event_screen.dart';
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

  Container cardContent(event) {
    return Container(
      margin: new EdgeInsets.fromLTRB(170.0, 16.0, 16.0, 16.0),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(height: 4.0),
            new Container(
              height: 60.0,
              child: Text(
                event.title,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            new Container(height: 10.0),
            new Container(
                width: 100,
                child: new Row(
                  children: <Widget>[
                    Icon(
                      Icons.update,
                      color: Colors.green,
                      size: 24.0,
                    ),
                    Text(
                      "",
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      Icons.favorite,
                      color: Colors.green,
                      size: 24.0,
                    ),
                    Text(
                      " " + event.votes.toString(),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                      ),
                    )
                  ],
                )),
            new Container(
                margin: new EdgeInsets.fromLTRB(180, 0, 0, 0),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        color: Colors.green,
                        size: 24.0,
                      ),
                      Text(
                        " hola" + event.votes.toString(),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                )),
          ]),
    );
  }

  final image = new Container(
      margin: new EdgeInsets.fromLTRB(10, 12.5, 0, 10),
      height: 100,
      width: 140,
      child: FittedBox(
        child: Image.asset('assets/img/yoga.jpg'),
        fit: BoxFit.cover,
      ));

  final card = Container(
    height: 124.0,
    decoration: new BoxDecoration(
      color: new Color(0xfff5f5f5),
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          blurRadius: 1.0, // has the effect of softening the shadow
          spreadRadius: 1.0, // has the effect of extending the shadow
          offset: Offset(
            2.0, // horizontal, move right 10
            2.0, // vertical, move down 10
          ),
          color: Colors.grey,
        )
      ],
    ),
  );

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
        body: new ListView(
          children: <Widget>[
            Container(
              height: 50.0,
              margin: new EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                claim,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              itemCount: list.getLength(),
              itemBuilder: (BuildContext context, int index) {
                //vars
                Event event = list.getEvent(index);
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EventScreen(
                                  event: event,
                                )),
                      );
                    },
                    child: new Stack(
                      children: <Widget>[card, image, cardContent(event)],
                    ));
              },
            ),
          ],
        ));
  }
}
