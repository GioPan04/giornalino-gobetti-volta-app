//Import Flutter & Dart stuff 
import 'package:flutter/material.dart';
import 'package:giornalino_gv_app/providers/LastEditionsProvider.dart';

//Import screens
import 'package:giornalino_gv_app/screens/HomeScreen.dart';
import 'package:giornalino_gv_app/screens/AboutScreen.dart';
import 'package:provider/provider.dart';

//Import packages


void main() {
  runApp(MateApp());
}

class MateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LastEditionsProvider>(create: (_) => LastEditionsProvider()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/about': (context) => AboutScreen()
        },
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(headline6: TextStyle(fontFamily: "NanumMyeongjo-Regular", fontSize: 20, color: Colors.white))
          )
        ),
      ),
    );
  }
}