import 'package:betogether/main.dart';
import 'package:betogether/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityScreen extends StatefulWidget {
  final Activity activity;
  ActivityScreen({Key key, this.activity}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState(activity);
}

class _ActivityScreenState extends State<ActivityScreen> {

  final Activity activity;


  _ActivityScreenState(this.activity) : super();

  _launchURL() async {
    String url = activity.url;
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
            content: Text("Problamente la actividad no disponga de URL."),
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
                        child: getImage(activity.image)
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
                          onPressed: () => {},
                          child: new Column(
                            children: <Widget>[
                              new Icon(Icons.favorite_border),
                              new Text('Favorito')
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
                new Text(activity.title, style: title,),
                new Container(
                  margin: EdgeInsets.only(top: 15),
                ),
                new Text(activity.description)
              ],
            ),
          ),
        )
    );
  }
}