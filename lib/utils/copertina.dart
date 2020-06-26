import 'package:flutter/material.dart';

class Copertina extends StatelessWidget {

  final String title;
  final String autore;
  final String imageUrl;
  final String date;
  final bool read;
  //final Map tags;
  Copertina({@required this.title, @required this.autore, @required this.imageUrl, @required this.date, this.read});

  @override
  Widget build(BuildContext context) {
    //dark = (MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: Color(0x22000000),
              height: 140,
              width: 90,
              child: Image.network(imageUrl, fit: BoxFit.cover,),
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title, style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.87) , fontSize: 21, fontFamily: "OpenSans-Bold", height: 1),),
              SizedBox(height: 5,),
              Text("Autore: $autore", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6), fontFamily: "OpenSans-Light", height: 1.2),),
              /*(tags != null) ? Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Text("Tags:", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6), fontFamily: "OpenSans-Light", height: 1.2),),
                  Text("#satira", style: TextStyle(color: Color.fromRGBO(244, 67, 54, 0.4), fontFamily: "OpenSans-SemiBold", height: 1.2),)
                ],
              ) : null,*/
              Text("Pubblicato il: $date", style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.6), fontFamily: "OpenSans-Light", height: 1.2),),
            ]//.where((element) => element != null).toList(),
          ),
        ),
        (read) ? Icon(Icons.new_releases) : Container(),
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