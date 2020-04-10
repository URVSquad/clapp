import 'package:betogether/screens/listActivitiesScreen.dart';
import 'package:betogether/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  ListScreen() : super();

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen>
    with SingleTickerProviderStateMixin {
  final tabList = ['Actividades', 'Eventos'];
  TabController _tabController;
  static const double radius = 15.0;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabList.length);
    super.initState();
  }

  GestureDetector event(String title, String asset) {
    return GestureDetector(
        onTap: () {
          print("Event category clicked");
        },
        child: Container(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(radius),
                topRight: const Radius.circular(radius),
                bottomLeft: const Radius.circular(radius),
                bottomRight: const Radius.circular(radius)),
            image: DecorationImage(
              image: AssetImage(asset),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  GestureDetector category(String title, String asset) {
    return GestureDetector(
        onTap: () {
          APIService api = new APIService();
          api.getActivities();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListActivitiesScreen()),
          );
        },
        child: Container(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30),
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(radius),
                topRight: const Radius.circular(radius),
                bottomLeft: const Radius.circular(radius),
                bottomRight: const Radius.circular(radius)),
            image: DecorationImage(
              image: AssetImage(asset),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  Widget events() {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: 1,
      childAspectRatio: 3,
      children: <Widget>[
        event("Top diario", "assets/img/deportes.jpg"),
        event("Top semanal", "assets/img/deportes.jpg"),
        event("Ejercicio", "assets/img/deportes.jpg"),
        event("Cocinitas", "assets/img/deportes.jpg"),
        event("Eventos audiovisuales", "assets/img/deportes.jpg"),
        event("Libros", "assets/img/deportes.jpg"),
        event("Juegos", "assets/img/deportes.jpg"),
        event("Peques", "assets/img/deportes.jpg"),
      ],
    );
  }

  Widget categories() {
    return GridView.count(
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      children: <Widget>[
        category("Podcast", "assets/img/deportes.jpg"),
        category("Ejercicio", "assets/img/deportes.jpg"),
        category("Recetas", "assets/img/deportes.jpg"),
        category("Audiovisual", "assets/img/deportes.jpg"),
        category("Libros", "assets/img/deportes.jpg"),
        category("Gaming", "assets/img/deportes.jpg"),
        category("Juegos", "assets/img/deportes.jpg"),
        category("Peques", "assets/img/deportes.jpg"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explorar',
          style: TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: tabList.map((item) {
            return Tab(text: item);
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [categories(), events()],
      ),
    );
  }
}
