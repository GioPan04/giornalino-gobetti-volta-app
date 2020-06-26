import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:giornalino_gv_app/screens/VideoScreen.dart';
import 'package:giornalino_gv_app/utils/Video.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class VideosScreen extends StatefulWidget {
  @override
  _VideosScreenState createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 100,
      padding: EdgeInsets.only(top: 2),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (c, i) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Shimmer.fromColors(
            highlightColor: Color(0xFFC9C9C9), //Colore sfumatura (+ chiaro)
            baseColor: Color(0xFF636363), //Colore di sfondo
            child: VideoLoading(),
          ),
        );
      }
    );
  }

  Future getData() async {
    http.Response response = await http.get("http://igioele.pangio.lan:3000/api/videos");
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> data = jsonDecode(response.body);
      return data["data"];
    } else {
      throw Error();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          List data = snapshot.data;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (c,i) => InkWell(child: Video(title: data[i]['title'], thumbnailUrl: data[i]['thumbnailUrl']), onTap: () => Navigator.pushNamed(context, '/video', arguments: VideoArgs(title: data[i]['title'], url: data[i]['videoUrl'])),),
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
          return _buildShimmer();
        }
      },
    );
  }
}