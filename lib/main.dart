import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/level.dart';
import 'services/data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colors[2],
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => MyHomePage(),
        '/level': (context) => LevelPage(level: 1),
      },
    );
  }
}
