import 'package:flutter/material.dart';
import 'screens/giornale.dart';
import 'package:shimmer/shimmer.dart';
import 'utils/copertina.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'screens/MercatinoScreen.dart';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  _sendArg(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) {
        return _Arg(scaffoldKey: _scaffoldKey,);
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF404040),
      appBar: AppBar(
        title: Text("the News Times", style: TextStyle(fontFamily: "NanumMyeongjo-Regular", fontSize: 24),),
        backgroundColor: Color(0xFF303030),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add_comment), onPressed: () => _sendArg(context))
        ],
      ),
      body: PageView(
        onPageChanged: (int i) => setState(() => currentPage = i),
        controller: _pageController,
        children: <Widget>[
          HomePageScreen(),
          MercatinoScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          _pageController.animateToPage(i, duration: Duration(milliseconds: 500), curve: Curves.ease);
          setState(() {
            currentPage = i;
          });
        },
        selectedItemColor: Color(0xFFF44336),
        currentIndex: currentPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.new_releases), title: Text("Giornalini")),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), title: Text("Mercatino"))
        ]
      ),
    );
  }

}

class HomePageScreen extends StatefulWidget {

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> with AutomaticKeepAliveClientMixin<HomePageScreen> {

  bool dark;

  String date(String timestamp) {
    
    var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    var format = DateFormat("dd/MM/yyyy");
    return format.format(date);
  }

  Future getData() async {
    http.Response response = await http.get("https://ggv.pangio.it/api/get");
    var result = jsonDecode(response.body);
    return result["items"];
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

  @override
  Widget build(BuildContext context) {
    dark = (MediaQuery.of(context).platformBrightness == Brightness.dark);
    super.build(context);
    return FutureBuilder(
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
                  child: Copertina(title: data[i]['title'], imageUrl: data[i]['thumnail_url'], autore: data[i]['author'], date: date(data[i]['date']),),
                ),
                onTap: () => Navigator.pushNamed(context, '/giornale', arguments: GiornaleScreenArgs(url: data[i]['article_url'], title: data[i]['title'])),
              );
            },
          );
        } else {
          return _buildShimmer();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _Arg extends StatefulWidget {
  const _Arg({
    Key key,
    this.scaffoldKey,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  __ArgState createState() => __ArgState();
}

class __ArgState extends State<_Arg> {

  final TextEditingController argCtrl = TextEditingController();
  String argError;

  bool dark;

  @override
  Widget build(BuildContext context) {
    dark = (MediaQuery.of(context).platformBrightness == Brightness.dark);
    return AlertDialog(
      title: Text("Segnalaci un'argomento"),
      content: SingleChildScrollView(
        child: TextField(
          keyboardType: TextInputType.text,
          controller: argCtrl,
          maxLines: null,
          minLines: null,
          maxLength: null,
          style: new TextStyle(color: (dark) ? Colors.white: Colors.black),
          onChanged: (str) {
            if(str.isEmpty) {
              setState(() {
                argError = "Compila il campo";
              });
            } else {
              setState(() {
               argError = null;
              });
            }
          },
          onSubmitted: (str) => _sendArg(context, str),
          decoration: InputDecoration(
            hintText: "Scrivi un'argomento di cui parlare",
            errorText: argError,
            hintStyle: TextStyle(color: (dark) ? Colors.white: Colors.black),
            labelStyle: TextStyle(color: (dark) ? Colors.white: Colors.black),
            border: OutlineInputBorder(borderSide: BorderSide(color: (dark) ? Colors.white: Colors.black)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: (dark) ? Colors.white: Colors.black)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: (dark) ? Colors.white: Colors.black)),
            fillColor: (dark) ? Colors.white: Colors.black,
            focusColor: (dark) ? Colors.white: Colors.black,
            hoverColor: (dark) ? Colors.white: Colors.black,
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: () => _sendArg(context, argCtrl.text), child: Text("INVIA"))
      ],
    );
  }

  void _sendArg(BuildContext c, String text) async {
    if(text.isEmpty) {
      setState(() {
        argError = "Compila il campo";
      });
    } else {
      setState(() {
        argError = null;
      });
      http.Response argResponce = await http.post("https://ggv.pangio.it/api/post/arg/index.php", headers: {"text": text});
      Navigator.pop(c);
      var response = jsonDecode(argResponce.body);
      if(response['error']) {
        _showSnackBar(response['error']);
      } else {
        _showSnackBar("Argomento inviato correttamente 👍");
      }
    }
  }

  _showSnackBar(String body) {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(body)));
  }

}