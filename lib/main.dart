import 'package:flutter/material.dart';
import 'screens/giornale.dart';
import 'package:shimmer/shimmer.dart';
import 'utils/copertina.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    theme: ThemeData(),
    darkTheme: ThemeData.dark(),
    routes: {
      '/': (context) => Home(),
      '/giornale': (context) => GiornaleScreen(),
    },
  ));
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future getData() async {
    http.Response response = await http.get("https://ggv.pangio.it/api/get");
    var result = jsonDecode(response.body);
    return result["items"];
  }

  bool dark;

  @override
  Widget build(BuildContext context) {
    dark = (MediaQuery.of(context).platformBrightness == Brightness.dark);
    return Scaffold(
      appBar: AppBar(
        title: Text("Giornalino Gobetti Volta"),
        backgroundColor: Color(0xFFF44336),
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            var data = snapshot.data;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                return InkWell(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Copertina(title: data[i]['title'], imageUrl: data[i]['thumnail_url'], autore: data[i]['author'], date: data[i]['date'],),
                  ),
                  onTap: () => Navigator.pushNamed(context, '/giornale', arguments: GiornaleScreenArgs(url: data[i]['article_url'], title: data[i]['title'])),
                );
              },
            );
          } else {
            return _buildShimmer();
          }
        },
      )
    );
  }

  _buildShimmer() {
    return ListView.builder(
      itemCount: 100,
      padding: EdgeInsets.only(top: 2),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (c, i) {
        return Padding(
          padding: EdgeInsets.all(5),
          child: Shimmer.fromColors(
            highlightColor: (!dark) ? Colors.white : Color(0xFFC9C9C9), //Colore sfumatura (+ chiaro)
            baseColor: (!dark) ? Colors.grey[300] : Color(0xFF636363), //Colore di sfondo
            child: CopertinaLoading(),
          ),
        );
      }
    );
  }

}