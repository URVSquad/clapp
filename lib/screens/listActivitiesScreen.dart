import 'package:betogether/models/activity.dart';
import 'package:betogether/models/listActivities.dart';
import 'package:betogether/screens/single_views/activity_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListActivitiesScreen extends StatefulWidget {
  final ListActivities list;

  ListActivitiesScreen(this.list) : super();

  @override
  _ListActivitiesScreenState createState() =>
      _ListActivitiesScreenState(this.list);
}

class _ListActivitiesScreenState extends State<ListActivitiesScreen> {
  final ListActivities list;
  _ListActivitiesScreenState(this.list) : super();

  @override
  void initState() {
    super.initState();
  }

  final image = new Container(
      margin: new EdgeInsets.fromLTRB(10, 12.5, 0, 10),
      height: 100,
      width: 140,
      child: FittedBox(
        child: Image.asset('assets/img/yoga.jpg'),
        fit: BoxFit.cover,
      ));

  Container cardContent(activity){
    return Container(
      margin: new EdgeInsets.fromLTRB(170.0, 16.0, 16.0, 16.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(activity.title),
          new Container(height: 10.0),
          new Text("hola"),
          new Container(
              margin: new EdgeInsets.symmetric(vertical: 8.0),
              height: 2.0,
              width: 18.0,
              color: new Color(0xff00c6ff)),
        ],
      ),
    );
  }

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
          title: Text(
            'Explorar',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
        body: new ListView(
          children: <Widget>[
            Text("Claim marina raro"),
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
                Activity activity = list.getActivity(index);
                return GestureDetector(
                  onTap: () {
                    print("Activty clicked");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ActivityScreen(activity: activity,)),
                    );
                  },
                  child: new Stack(
                    children: <Widget>[card, image, cardContent(activity)],
                  ));
              },
            ),
          ],
        ));
  }
}
