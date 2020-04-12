import 'package:betogether/models/activity.dart';
import 'package:betogether/models/listActivities.dart';
import 'package:betogether/screens/single_views/activity_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
  }

  Container cardContent(activity) {
    return Container(
      margin: new EdgeInsets.fromLTRB(170.0, 16.0, 16.0, 16.0),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(height: 4.0),
            new Container(
              height: 60.0,
              child: Text(
                activity.title,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            new Container(height: 10.0),
            new Container(
                margin: new EdgeInsets.fromLTRB(120, 0, 0, 0),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        color: Color(0xffb71c1c),
                        size: 24.0,
                      ),
                      Text(
                        " " + activity.votes.toString(),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xffb71c1c),
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ))
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

  Container getCard(color){
    return Container(
      height: 124.0,
      decoration: new BoxDecoration(
          color: new Color(int.parse(color)),
          //FIXME: This should be with the class color
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
      boxShadow: [
        BoxShadow(
          blurRadius: 4.0, // has the effect of softening the shadow
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
        body: new ListView(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                claim,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.white,
              ),
              padding: EdgeInsets.all(15),
              itemCount: list.getLength(),
              itemBuilder: (BuildContext context, int index) {
                //vars
                Activity activity = list.getActivity(index);
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActivityScreen(
                                  activity: activity,
                                )),
                      );
                    },
                    child: new Stack(
                      children: <Widget>[getCard(color), image, cardContent(activity)],
                    ));
              },
            ),
          ],
        ));
  }
}
