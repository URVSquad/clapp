import 'package:betogether/models/activity.dart';
import 'package:betogether/models/listActivities.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explorar',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) => Divider(height: 20,color: Colors.white,),
        padding: EdgeInsets.all(20),
        itemCount: list.getLength(),
        itemBuilder: (BuildContext context, int index) {
          //vars
          const double radius = 10;
          const String asset = "assets/img/deportes.jpg";
          Activity activity = list.getActivity(index);

          return GestureDetector(
              onTap: () {
                print("Activty clicked");
              },
              child: Container(
                height: 100,
                child: Center(
                  child: Text(
                    activity.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 30),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(radius),
                      topRight: const Radius.circular(radius),
                      bottomLeft: const Radius.circular(radius),
                      bottomRight: const Radius.circular(radius)),
                ),
                ),
              );
        },
      ),
    );
  }
}
