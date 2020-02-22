import 'package:flutter/material.dart';

class MercatinoScreen extends StatefulWidget {
  MercatinoScreen({Key key}) : super(key: key);

  @override
  _MercatinoScreenState createState() => _MercatinoScreenState();
}

class _MercatinoScreenState extends State<MercatinoScreen> with AutomaticKeepAliveClientMixin<MercatinoScreen> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.network("https://hd.tudocdn.net/898005?w=660&h=414",),
          ],
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}