import 'package:animator/animator.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class FirstScreen extends StatefulWidget {
  FirstScreen({Key key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 60),
              child: Animator(
                builder: (anim) {
                  return Transform.rotate(child: Text("👋", style: TextStyle(fontSize: 70),), angle: anim.value,);
                },
                tween: Tween<double>(begin: 0, end: math.pi / 2),
                cycles: 2,
                curve: Curves.easeInOut,
                duration: Duration(seconds: 2),
              ),
            ),
          ),
          Align(alignment: Alignment.center,child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontFamily: "RobotoSlab", fontSize: 20),
                children: [
                  TextSpan(text: "Ciao e benvenuto su GV Reporter!", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23)),
                  TextSpan(text: "\nL'app ufficiale del giornalino scolastico dell'I.S.I.S. Gobetti Volta.", style: TextStyle(fontWeight: FontWeight.w300,)),
                ]
              ),
              textAlign: TextAlign.center,
              
            ),
          )),
          
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.only(bottom: 10, right: 10),
          child: Row(
            children: <Widget>[
              Spacer(),
              RaisedButton(
                child: Text("CONTUNUA", style: TextStyle(color: Color(0xFF000000)),),
                color: Color(0xFFFFFFFF),
                onPressed: () => Navigator.pop(context),
              )
            ]
          ),
        )
      ),
    );
  }
}