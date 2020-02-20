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

  Future getJSONData(String url) async {
    try {
      http.Response response = await http.get(url);
      return jsonDecode(response.body);
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

  void showCharapters(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog();
      }
    );
  }

  bool dark;

  @override
  Widget build(BuildContext context) {
    final GiornaleScreenArgs args = ModalRoute.of(context).settings.arguments;
    dark = (MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF44336),
        title: Text(args.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.book), onPressed: () {}),
        ],
      ),
      body: FutureBuilder(
        future: getJSONData("https://ggv.pangio.it/data/1582135700/index.json"),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            var data = snapshot.data;
            var pages = data["pages"];
            if (data['numPages'] > 1){
              return PageView.builder(
                itemCount: pages.length,
                itemBuilder: (context, i) {
                  return FutureBuilder(
                    future: getData(pages[i]['pageUrl']),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        var page = snapshot.data;
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: MarkdownBody(
                              data: Utf8Decoder(allowMalformed: true).convert(page.toString().codeUnits),
                              onTapLink: (url) => _launch(url),
                              styleSheet: MarkdownStyleSheet(
                                h1: TextStyle(fontFamily: "OpenSans-Bold", color: (!dark) ? Color.fromRGBO(0, 0, 0, 0.87) : Color.fromRGBO(255, 255, 255, 0.87), fontSize: 25, height: 2),
                                h2: TextStyle(fontFamily: "OpenSans-SemiBold", color: (!dark) ? Color.fromRGBO(0, 0, 0, 0.87) : Color.fromRGBO(255, 255, 255, 0.87), fontSize: 19, height: 2),
                                p: TextStyle(fontFamily: "OpenSans-Regular", color: (!dark) ? Color.fromRGBO(0, 0, 0, 0.87) : Color.fromRGBO(255, 255, 255, 0.87), height: 1.15)

                              ),
                            ),
                          ),
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
                  );
                },
              );
            } else {
              return Container();
            }
          } else if(snapshot.hasError) {
            return Center(child: Text("Error ${snapshot.error}"),);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }


  /*
    FutureBuilder(
      future: getData(args.url),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: MarkdownBody(
                    data: Utf8Decoder(allowMalformed: true).convert(snapshot.data.toString().codeUnits),
                    onTapLink: (url) => _launch(url),
                    styleSheet: MarkdownStyleSheet(
                      h1: TextStyle(fontFamily: "OpenSans-Bold", color: (!dark) ? Color.fromRGBO(0, 0, 0, 0.87) : Color.fromRGBO(255, 255, 255, 0.87), fontSize: 25, height: 2),
                      h2: TextStyle(fontFamily: "OpenSans-SemiBold", color: (!dark) ? Color.fromRGBO(0, 0, 0, 0.87) : Color.fromRGBO(255, 255, 255, 0.87), fontSize: 19, height: 2),
                      p: TextStyle(fontFamily: "OpenSans-Regular", color: (!dark) ? Color.fromRGBO(0, 0, 0, 0.87) : Color.fromRGBO(255, 255, 255, 0.87), height: 1.15)

                    ),
                  ),
                ),
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
  */
}

class GiornaleScreenArgs {
  final String title;
  final String url;

  GiornaleScreenArgs({@required this.url, @required this.title});

}