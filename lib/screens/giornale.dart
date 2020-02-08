import 'dart:ui';
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GiornaleScreen extends StatefulWidget {
  GiornaleScreen({Key key}) : super(key: key);

  @override
  _GiornaleScreenState createState() => _GiornaleScreenState();
}

class _GiornaleScreenState extends State<GiornaleScreen> {

  Future getData(String url) async {
    try {
      http.Response response = await http.get(url);
      return response.body;
    } catch (e) {
      throw e;
    }
    
    
  }

  _launch(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {

    final GiornaleScreenArgs args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF44336),
        title: Text(args.title),
      ),
      body: FutureBuilder(
        future: getData(args.url),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            return MarkdownBody(
              data: Utf8Decoder(allowMalformed: true).convert(snapshot.data.toString().codeUnits),
              onTapLink: (url) => _launch(url),
            );
          } else if(snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.error_outline, size: 80,),
                  SizedBox(height: 10),
                  Text("Si è verificato un'errore\nRiprova più tardi", textAlign: TextAlign.center,),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        }
      ),
    );
  }
}

class GiornaleScreenArgs {
  final String title;
  final String url;

  GiornaleScreenArgs({@required this.url, @required this.title});

}