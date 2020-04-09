import 'package:flutter/material.dart';
import 'screens/interfaceScreen.dart';

void main() {

  runApp(MyApp());
}

const primaryColor = Color(0xffc5e1a5);
const primaryColorLight = Color(0xfff8ffd7);
const primaryColorDark = Color(0xff94af76);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'BeTogether',
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: primaryColor,
          primaryColorLight: primaryColorLight,
          primaryColorDark: primaryColorDark,
          accentColor: primaryColorDark,
          scaffoldBackgroundColor: Colors.white,
          // Define the default font family.
          fontFamily: 'Cupertino',

          appBarTheme: AppBarTheme(
            elevation: 0,
            textTheme: TextTheme(
              title: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),

            ),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),

          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: primaryColorDark,
          ),
          iconTheme: IconThemeData(
            color: Colors.black
          ),
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
