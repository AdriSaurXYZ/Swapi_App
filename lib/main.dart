import 'package:flutter/material.dart';
import 'package:movies_app/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SWAPI App',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: HomeScreen(),
    );
  }
}