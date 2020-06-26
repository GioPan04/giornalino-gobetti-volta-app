import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class SputiScreen extends StatefulWidget {
  @override
  _SputiScreenState createState() => _SputiScreenState();
}

class _SputiScreenState extends State<SputiScreen> {

  final DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm:ss");

  Future getData() async {
    http.Response response = await http.get("http://igioele.pangio.lan:3000/api/sputi/public");
    if (response.statusCode == 200) {
      Map<dynamic, dynamic> data = jsonDecode(response.body);
      return data["data"];
    } else {
      throw Error();
    }
  }

  String getDate(String timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return dateFormat.format(date);
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
            itemBuilder: (context, i) => ListTile(
              isThreeLine: false,
              leading: Icon(Icons.chat_bubble_outline),
              title: Text(data[i]["text"]),
              subtitle: Text(getDate(data[i]['timestamp'])),
            ),
          );
        } else if (snapshot.hasError) {
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
    );
  }
}