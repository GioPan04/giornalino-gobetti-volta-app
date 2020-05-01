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

  showCharapters(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Vai a capitolo"),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              itemCount: charapters.length,
              itemBuilder: (context, i) {
                return ListTile(
                  title: Text(Utf8Decoder(allowMalformed: true).convert(charapters[i]['title'].toString().codeUnits), style: TextStyle(fontWeight: (i == pageViewController.page.round()) ? FontWeight.w700 : FontWeight.w400),),
                  onTap: () {
                    Navigator.pop(context);
                    pageViewController.animateToPage(i, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                  },
                );
              },
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final GiornaleScreenArgs args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
          appBar: AppBar(
            title: Text(args.title),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.book), tooltip: "Vai a capitolo", onPressed: () => showCharapters(context)),
            ],
          ),
          body:
              FutureBuilder(
                future: getJSONData(args.url),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    var data = snapshot.data;
                    var pages = data["pages"];
                    charapters = pages;
                    /*if (data['numPages'] > 1){*/
                      return PageView.builder(
                        itemCount: pages.length,
                        controller: pageViewController,
                        itemBuilder: (context, i) {
                          return FutureBuilder(
                            future: getData(pages[i]['pageUrl']),
                            builder: (context, snapshot) {
                              if(snapshot.hasData) {
                                var page = snapshot.data;
                                return Container(
                                  color: Color((pages[i]['backgroundColor'] != null ) ? int.parse('0x' + pages[i]['backgroundColor']) : 0x00FFFFFF),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 30),
                                        child: MarkdownBody(
                                          
                                          data: Utf8Decoder(allowMalformed: true).convert(page.toString().codeUnits),
                                          onTapLink: (url) => _launch(url),
                                          styleSheet: MarkdownStyleSheet(
                                            textAlign: WrapAlignment.spaceEvenly,
                                            h1: TextStyle(fontFamily: "OpenSans-Bold", color: Color.fromRGBO(255, 255, 255, 0.87), fontSize: 25, height: 2),
                                            h2: TextStyle(fontFamily: "OpenSans-SemiBold", color: Color.fromRGBO(255, 255, 255, 0.87), fontSize: 23, height: 2),
                                            p: TextStyle(fontFamily: "OpenSans-Regular", color: Color.fromRGBO(255, 255, 255, 0.87), height: 1.15, fontSize: 16)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              } else if(snapshot.hasError) {
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
                          );
                        },
                      );/*
                    } else {
                      return Container();
                    }*/
                  } else if(snapshot.hasError) {
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
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
    );
  }
}

class GiornaleScreenArgs {
  final String title;
  final String url;

  GiornaleScreenArgs({@required this.url, @required this.title});

}