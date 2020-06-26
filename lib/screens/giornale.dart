import 'dart:ui';
import 'dart:convert';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flare_flutter/flare_actor.dart';

class GiornaleScreen extends StatefulWidget {
  GiornaleScreen({Key key}) : super(key: key);

  @override
  _GiornaleScreenState createState() => _GiornaleScreenState();
}

class _GiornaleScreenState extends State<GiornaleScreen> {
  
  var charapters;
  final PageController pageViewController = PageController();

  Future getData(String url) async {
    try {
      http.Response response = await http.get(url);
      return response.body;
    } catch (e) {
      throw e;
    }
  }

  Future getJSONData(String url) async {
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
            title: Text(args.title),
          ),
          body:
              FutureBuilder(
                future: getJSONData('http://igioele.pangio.lan:3000/api/articles/${args.id}'),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    var data = snapshot.data;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 38.0),
                        child: MarkdownBody(
                          data: Utf8Decoder(allowMalformed: true).convert(data.toString().codeUnits),
                          onTapLink: (url) => _launch(url),
                          styleSheet: MarkdownStyleSheet(
                            textAlign: WrapAlignment.spaceEvenly,
                            h1: TextStyle(fontFamily: "OpenSans-Bold", color: Color.fromRGBO(255, 255, 255, 0.87), fontSize: 25, height: 2),
                            h2: TextStyle(fontFamily: "OpenSans-SemiBold", color: Color.fromRGBO(255, 255, 255, 0.87), fontSize: 23, height: 2),
                            p: TextStyle(fontFamily: "OpenSans-Regular", color: Color.fromRGBO(255, 255, 255, 0.87), height: 1.15, fontSize: 16)
                          ),
                        ),
                      ),
                    );
                  } else if(snapshot.hasError) {
                    print(snapshot.error);
                    return Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text("😩", style: TextStyle(fontSize: 50), textAlign: TextAlign.center,),
                            ),
                            Text("Si è verificato un'errore,\ncontrolla la connessione ad Internet", textAlign: TextAlign.center,)
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator(),);
                    }
                }
              )
    );
  }
}

class GiornaleScreenArgs {
  final int id;
  final String title;

  GiornaleScreenArgs({@required this.id, @required this.title});

}