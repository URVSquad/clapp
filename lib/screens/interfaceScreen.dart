

import 'package:flutter/material.dart';
import 'addScreen.dart';
import 'homeScreen.dart';
import 'listScreen.dart';
import 'profileScreen.dart';

class InterfacePage extends StatefulWidget {
  InterfacePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _InterfacePageState createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: DefaultTabController(
        length: 4,
        child: new Scaffold(
          appBar: AppBar(
            title: Text("BeTogether",
                style: TextStyle(color: Colors.orangeAccent),
                textDirection: TextDirection.ltr),
            centerTitle: true,
            backgroundColor: Colors.blueGrey,
          ),
          body: TabBarView(
            children: [
              new HomeScreen(),
              new ListScreen(),
              new AddScreen(),
              new ProfileScreen()
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.list),
              ),
              Tab(
                icon: new Icon(Icons.add),
              ),
              Tab(
                icon: new Icon(Icons.person),
              )
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.orangeAccent,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
          ),
          backgroundColor: Colors.blueGrey,
        ),
      ),
    );
  }
}
