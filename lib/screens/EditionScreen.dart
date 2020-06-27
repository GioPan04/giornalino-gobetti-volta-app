import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:giornalino_gv_app/models/EditionModel.dart';
import 'package:giornalino_gv_app/providers/EditionProvider.dart';
import 'package:provider/provider.dart';

class EditionScreen extends StatefulWidget {

  final Edition data;

  const EditionScreen(this.data, {Key key}) : super(key: key);

  @override
  _EditionScreenState createState() => _EditionScreenState();
}

class _EditionScreenState extends State<EditionScreen> {

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<EditionProvider>(context, listen: false).getData(widget.data.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.title),
      ),
      body: Consumer<EditionProvider>(
        builder: (context, data, _) {
          if(data.failure != null) return Center(child: Text(data.failure.toString()),);
          if(data.text != null) return SingleChildScrollView(child: MarkdownBody(data: Utf8Decoder(allowMalformed: true).convert(data.text.codeUnits), styleSheet: MarkdownStyleSheet(p: TextStyle(color: Colors.black))));
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}