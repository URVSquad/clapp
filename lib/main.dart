import 'package:flutter/material.dart';
import 'screens/interfaceScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeTogether',
      home: InterfacePage(title: 'BeTogether',)
    );
  }
}
