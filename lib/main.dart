import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:giornalino_gv_app/screens/AboutScreen.dart';
import 'package:giornalino_gv_app/screens/FirstScreen.dart';
import 'screens/giornale.dart';
import 'package:shimmer/shimmer.dart';
import 'utils/copertina.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
//import 'screens/MercatinoScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'screens/authenticate/AuthenticateScreen.dart';
//import 'screens/ItemScreen.dart';
//import 'screens/authenticate/AuthenticateScreen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      
    ),
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
      ),
      accentIconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      primaryIconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
      textTheme: TextTheme(body1: TextStyle(color: Color(0xFFFFFFFF)), button: TextStyle(color: Color(0xFFFFFFFF)), subtitle: TextStyle(color: Color(0xFFFFFFFF)), title: TextStyle(color: Color(0xFFFFFFFF)), subhead: TextStyle(color: Color(0xFFFFFFFF)), caption: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.7))),
    ),
    routes: {
      '/': (context) => Home(),
      '/giornale': (context) => GiornaleScreen(),
      '/about': (context) => AboutScreen(),
      '/first': (context) => FirstScreen(),
      /*'/item': (context) => ItemScreen(),
      '/itemGallery': (context) => ItemGallery(),
      '/login': (context) => Login(),*/
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
  final PageController _pageController = PageController(initialPage: 0);
  final FirebaseMessaging _fcm = new FirebaseMessaging();
  int currentPage = 0;
  bool logged = true;
  StreamSubscription iosSubscription;

  _sendArg(BuildContext context) {
    showDialog(
      context: context,
      builder: (c) {
        return _Arg(scaffoldKey: _scaffoldKey,);
      }
    );
  }

  _sellOn(BuildContext context) {

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
    if(Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        _fcm.subscribeToTopic('registeredUsers');
      });
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    } else {
      _fcm.subscribeToTopic('registeredUsers');
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called: $message');
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called: $message');
      },
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called: $message');
      },
    );
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
        onPageChanged: (i) {
          setState(() {
            currentPage = i;
          });
        },
        children: <Widget>[
          HomePageScreen(),
          //(logged) ? MercatinoScreen() : Login(),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _sendArg(context), child: Icon(Icons.add_comment),),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {
          if(i == 1) _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Coming Soon! 😉"),));
          /*_pageController.animateToPage(i, duration: Duration(milliseconds: 500), curve: Curves.ease);
          setState(() {
            currentPage = i;
          });*/
        },
        currentIndex: currentPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.library_books), title: Text("Edizioni")),
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
    dark = /*(MediaQuery.of(context).platformBrightness == Brightness.dark);*/ true;
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
                  child: Copertina(title: data[i]['title'], imageUrl: data[i]['thumnail_url'], autore: data[i]['author'], date: date(data[i]['date']), read: !readed.contains(data[i]['id'].toString()),),
                ),
                onTap: () {
                  if(!readed.contains(data[i]['id'].toString())) {
                    setState(() {
                      readed.add(data[i]['id'].toString());
                    });
                    _addRead();
                  }
                  Navigator.pushNamed(context, '/giornale', arguments: GiornaleScreenArgs(url: data[i]['article_url'], title: data[i]['title']));

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

  bool dark;

  @override
  Widget build(BuildContext context) {
    dark = /*(MediaQuery.of(context).platformBrightness == Brightness.dark);*/ true;
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
      http.Response araResponse = await http.post("https://ggv.pangio.it/api/post/arg/index.php", body: {"text": text});
      Navigator.pop(c);
      var response = jsonDecode(araResponse.body);
      if(response['error'] == true) {
        _showSnackBar(response['msg']);
      } else {
        _showSnackBar("Argomento inviato correttamente 👍");
      }
    }
  }

  _showSnackBar(String body) {
    widget.scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(body)));
  }

}