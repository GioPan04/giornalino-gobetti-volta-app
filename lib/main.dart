import 'dart:async';
import 'package:flutter/material.dart';
import 'package:giornalino_gv_app/screens/AboutScreen.dart';
import 'package:giornalino_gv_app/screens/FirstScreen.dart';
import 'package:giornalino_gv_app/screens/VideoScreen.dart';
import 'screens/SputiScreen.dart';
import 'screens/VideosScreen.dart';
import 'screens/giornale.dart';
import 'package:shimmer/shimmer.dart';
import 'utils/copertina.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    title: 'GV Reporter',
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
    darkTheme: ThemeData(
      primaryColor: Color(0xFF000000),
      scaffoldBackgroundColor: Color(0xFF222222),
      accentColor: Color(0xFFFFFFFF),
      bottomAppBarColor: Color(0xFF000000),
      bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFF000000)),
      canvasColor: Color(0xFF000000),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFFFFFFFF),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF000000),
        foregroundColor: Color(0xFFFFFFFF)
      ),
      primaryIconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      textTheme: TextTheme(bodyText2: TextStyle(color: Color(0xFFFFFFFF)), button: TextStyle(color: Color(0xFFFFFFFF)), subtitle2: TextStyle(color: Color(0xFFFFFFFF)), headline6: TextStyle(color: Color(0xFFFFFFFF)), subtitle1: TextStyle(color: Color(0xFFFFFFFF)), caption: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7))),
    ),
    routes: {
      '/': (context) => Home(),
      '/video': (context) => VideoScreen(),
      '/giornale': (context) => GiornaleScreen(),
      '/about': (context) => AboutScreen(),
      '/first': (context) => FirstScreen(),
    },
  )
  );
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController(initialPage: 1);
  int currentPage = 1;

  _sendArg(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) {
        return _Arg(scaffoldKey: _scaffoldKey,);
      }
    );
  }

  _check(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('started') == null || prefs.getBool('started') == false) {
      Navigator.of(context).pushReplacementNamed('/first');
    }
  }

  @override
  void initState() {
    _check(context);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Gobetti Volta Reporter", style: TextStyle(fontFamily: "NanumMyeongjo-Regular", fontSize: 20),),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.info_outline), onPressed: () => Navigator.of(context).pushNamed('/about')),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (i) {
          setState(() {
            currentPage = i;
          });
        },
        children: <Widget>[
          VideosScreen(),
          HomePageScreen(),
          SputiScreen(),
        ],
      ),
      floatingActionButton: (currentPage == 2) ? FloatingActionButton(onPressed: () => _sendArg(context), child: Icon(Icons.add_comment),) : null,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          _pageController.animateToPage(i, duration: Duration(milliseconds: 500), curve: Curves.ease);
          setState(() {
            currentPage = i;
          });
        },
        currentIndex: currentPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.video_library), title: Text("Video")),
          BottomNavigationBarItem(icon: Icon(Icons.library_books), title: Text("Edizioni")),
          BottomNavigationBarItem(icon: Icon(Icons.chat), title: Text("Sputi"))
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

  List<String> readed = [];
  Future data;

  @override
  void initState() {
    data = getData();
    super.initState();
    _getReaded();
  }

  _getReaded() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      readed = prefs.getStringList('readed') ?? [];
    });
  }

  _addRead() async {
    final prefs = await SharedPreferences.getInstance();
    print(readed.runtimeType);
    prefs.setStringList('readed', readed);
  }

  String date(String timestamp) {
    var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
    var format = DateFormat("dd/MM/yyyy");
    return format.format(date);
  }

  Future getData() async {
    http.Response response = await http.get("http://igioele.pangio.lan:3000/api/articles");
    var result = jsonDecode(response.body);
    return result["data"];
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
            highlightColor: Color(0xFFC9C9C9), //Colore sfumatura (+ chiaro)
            baseColor: Color(0xFF636363), //Colore di sfondo
            child: CopertinaLoading(),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: data,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          var data = snapshot.data;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              return InkWell(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Copertina(title: data[i]['title'], imageUrl: data[i]['thumnail_url'], autore: data[i]['author'], date: date(data[i]['date']), read: !readed.contains(data[i]['id'].toString())),
                ),
                onTap: () {
                  if(!readed.contains(data[i]['id'].toString())) {
                    setState(() {
                      readed.add(data[i]['id'].toString());
                    });
                    _addRead();
                  }
                  Navigator.pushNamed(context, '/giornale', arguments: GiornaleScreenArgs(id: data[i]['id'], title: data[i]['title']));

                } 
              );
            },
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Mandaci uno sputo"),
      content: SingleChildScrollView(
        child: TextField(
          keyboardType: TextInputType.text,
          controller: argCtrl,
          maxLines: null,
          minLines: null,
          maxLength: null,
          style: new TextStyle(color: Colors.white),
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
            hintText: "Scrivi qui il tuo sputo",
            errorText: argError,
            hintStyle: TextStyle(color: Colors.white),
            labelStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            fillColor: Colors.white,
            focusColor: Colors.white,
            hoverColor: Colors.white,
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
      http.Response araResponse = await http.post("http://igioele.pangio.lan:3000/api/sputo", body: {"text": text});
      Navigator.pop(c);
      var response = jsonDecode(araResponse.body);
      if(response['posted'] != true) {
        _showSnackBar(response['error']);
      } else {
        _showSnackBar("Sputo inviato correttamente 👍");
      }
    }
  }

  _showSnackBar(String body) {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(body)));
  }

}