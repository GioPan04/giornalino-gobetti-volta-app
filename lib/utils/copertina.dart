import 'package:flutter/material.dart';

class Copertina extends StatelessWidget {

  final String title;
  final String autore;
  final String imageUrl;
  final String date;
  bool dark;
  Copertina({@required this.title, @required this.autore, @required this.imageUrl, @required this.date});

  @override
  Widget build(BuildContext context) {
    dark = (MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Container(
            color: Color(0x22000000),
            height: 140,
            width: 90,
            child: Image.network(imageUrl, fit: BoxFit.cover,),
          ),
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(title,overflow: TextOverflow.visible, style: TextStyle(color: (!dark) ? Color.fromRGBO(0, 0, 0, 0.87) : Color.fromRGBO(255, 255, 255, 0.87) , fontSize: 21, fontFamily: "OpenSans-Bold", height: 1),),
              SizedBox(height: 5,),
              Text("Autore: $autore", style: TextStyle(color: (!dark) ? Color.fromRGBO(0, 0, 0, 0.6) : Color.fromRGBO(255, 255, 255, 0.6), fontFamily: "OpenSans-Light", height: 1.2),),
              Text("Pubblicato il: $date", style: TextStyle(color: (!dark) ? Color.fromRGBO(0, 0, 0, 0.6) : Color.fromRGBO(255, 255, 255, 0.6), fontFamily: "OpenSans-Light", height: 1.2),),
            ],
          ),
        ),
        //IconButton(icon: Icon(Icons.more_vert, color: Color.fromRGBO(0, 0, 0, 0.6),), onPressed: () {}),
      ],
    );
  }
}

class CopertinaLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Container(
            color: Colors.grey,
            height: 140,
            width: 90,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(color: Colors.grey, width: 200, height: 23,),
            SizedBox(height: 4),
            Container(color: Colors.grey, width: 150, height: 20,),
          ],
        ),
      ],
    );
  }
}