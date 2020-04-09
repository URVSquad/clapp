import 'package:flutter/material.dart';
import 'screens/interfaceScreen.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BeTogether',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            elevation: 0,
            textTheme: TextTheme(
              title: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),

            ),
          ),

          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            textTheme: ButtonTextTheme.accent,
          ),

          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
          ),
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.white,
          accentColor: Colors.lightGreen,
          scaffoldBackgroundColor: Colors.white,

          // Define the default font family.
          fontFamily: 'Cupertino',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        home: InterfacePage(title: 'BeTogether',)
    );
  }
}
