import 'package:betogether/models/listActivities.dart';
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

  GestureDetector category(String title, String color, String claim) {
    return GestureDetector(
        onTap: () {
          APIService api = new APIService();
          Future<ListActivities> futureList = api.getActivities();
          futureList.then((list) async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListActivitiesScreen(list, title, claim, color)),
            );
          });

        },
        child: Container(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 25),
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(radius),
                topRight: const Radius.circular(radius),
                bottomLeft: const Radius.circular(radius),
                bottomRight: const Radius.circular(radius)),
            color: Color(int.parse(color)),
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
        category("Podcast", "0xffffecb3","Bla Bla Bla 💬"),
        category("Ejercicio", "0xffb2dfdb","Mente sana en body sudado 💦"),
        category("Recetas", "0xffe1bee7","El equilibro está en recetas saludables y un cocktail para celebrar lo que te cuidas. 🍹"),
        category("Audiovisual", "0xffffccbc","Junto a la ducha, el mejor momento del día. Disfrutalo, te lo mereces. 🎬"),
        category("Libros", "0xffb2ebf2"," Libro’s club 📚💭"),
        category("Gaming", "0xfff0f4c3","🎮 Ready player one 🎮"),
        category("Juegos", "0xfff3e5f5","💡 ¡es la hora de jugar! cuidado con los tramposos 👾"),
        category("Peques", "0xffffcdd2","Entretener a los peques es un súper poder 🐣"),
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
