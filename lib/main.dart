import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/interfaceScreen.dart';

void main() {

  runApp(MyApp());
}

const primaryColor = Color(0xffc5e1a5);
const primaryColorLight = Color(0xfff8ffd7);
const primaryColorDark = Color(0xff94af76);

const title = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
const subtitle = TextStyle(fontSize: 20);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
          inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(
                color: Colors.black,
              ),
          ),
        ),
        home: InterfacePage(title: 'BeTogether',),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('es'),
        ],
    );
  }
}
