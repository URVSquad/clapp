import 'package:betogether/main.dart';
import 'package:betogether/models/activity.dart';
import 'package:betogether/models/event.dart';
import 'package:betogether/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EventScreen extends StatefulWidget {
  final Event event;
  EventScreen({Key key, this.event}) : super(key: key);

  @override
  _EventScreenState createState() => _EventScreenState(event);
}

class _EventScreenState extends State<EventScreen> {
  final Event event;
  Color _color = Colors.black;

  _EventScreenState(this.event) : super();

  String printDate(DateTime date) {
    String print = date.month.toString() +
        "/" +
        date.day.toString() +
        " " +
        date.hour.toString().padLeft(2, '0') +
        ":" +
        date.minute.toString().padLeft(2, '0');
    return print;
  }

  _launchURL() async {
    String url = event.url;
    if(url!=null){
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else{
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("URL no encontrada"),
            content: Text("Problamente el evento no disponga de URL."),
          )
      );
    }
  }

  Image getImage(String image) {
    if (image == null) {
      return Image.asset("assets/img/imageNotFound.jpg");
    } else {
      return Image.network(
        image,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                snap: false,
                actionsIconTheme: IconThemeData(opacity: 0.0),
                flexibleSpace: Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: getImage(event.image)
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: new EdgeInsets.only(top: 30, left: 10, right: 10),
                sliver: new SliverList(
                  delegate: new SliverChildListDelegate([
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: (_launchURL),
                          child: new Column(
                            children: <Widget>[
                              new Icon(Icons.link),
                              new Text('Enlace actividad')
                            ],
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                              APIService api = new APIService();
                              setState(() {
                              _color = Colors.red;
                              });
                              api.likeItem(event.id);
                          },
                          child: new Column(
                            children: <Widget>[
                              new Icon(
                                  Icons.favorite,
                                  color: _color,
                              ),
                              new Text('Me gusta')
                            ],
                          ),
                        ),
                        FlatButton(
                          onPressed: () => {},
                          child: new Column(
                            children: <Widget>[
                              new Icon(Icons.share),
                              new Text('Compartir')
                            ],
                          ),
                        ),

                      ],
                    ),
                  ]),
                ),
              ),
            ];
          },
          body: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(top: 40),
                ),
                new Row(
                  children: <Widget>[
                    Text("Inicio: ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),),
                    Text(printDate(event.start),
                      style: TextStyle(
                          fontSize: 20
                      ),),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    Text("Final: ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                    Text(printDate(event.end),
                      style: TextStyle(
                          fontSize: 20
                      ),),
                  ],
                ),
                new Container(
                  margin: EdgeInsets.only(top: 15),
                ),
                new Text(event.title, style: title,),
                new Container(
                  margin: EdgeInsets.only(top: 15),
                ),
                new Text(event.description)
              ],
            ),
          ),
        )
    );
  }
}