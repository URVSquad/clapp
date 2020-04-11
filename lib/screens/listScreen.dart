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

  GestureDetector event(String title, int color) {
    return GestureDetector(
        onTap: () {
          print("Event category clicked");
        },
        child: Container(
          child: Card(
            elevation: 5,
            color: Color(color),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
          ),

        ));
  }

  GestureDetector category(String title, String emoji, String color, String claim) {
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
          child: Card(
            color:Color(int.parse(color)),
            elevation: 5,
            child: Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                      emoji,
                  style: TextStyle(fontSize: 30),)
                ],
              ),
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
        event("Top semanal", 0xfffff3e0),
        event("Ejercicio", 0xfffbfbe9e7),
        event("Cocinitas", 0xffefebe9),
        event("Cultura", 0xffe8eaf6),
        event("Otros", 0xffede7f6),
        event("Peques", 0xffeffebee),
        event("Fiesta", 0xfff9fbe7),

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
        category("TOP semanal", "🔝", "0xfffff3e0","Lo mejor para ti, claro ⚡️📆"),
        category("Podcast", "🎤", "0xfffbfbe9e7","Bla Bla Bla 💬"),
        category("Ejercicio", "🤸‍️", "0xffefebe9","Mente sana en body sudado 💦"),
        category("Recetas", "🍪", "0xffe8eaf6","El equilibro está en recetas saludables y un cocktail para celebrar lo que te cuidas. 🍹"),
        category("Audiovisual", "📽", "0xffede7f6","Junto a la ducha, el mejor momento del día.\nDisfrútalo, te lo mereces. 🎬"),
        category("Libros", "📚", "0xffe0f2f1"," Libro’s club 📚💭"),
        category("Juegos", "👾", "0xffeffebee","💡 ¡Es la hora de jugar! cuidado con los tramposos 👾"),
        category("Peques", "🐥", "0xfff9fbe7","Entretener a los peques es un súper poder 🐣"),
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
