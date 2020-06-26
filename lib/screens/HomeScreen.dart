//Import Flutter & Dart stuff
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
        title: Text("Gobetti Volta Reporter"),
      ),
    );
  }
}