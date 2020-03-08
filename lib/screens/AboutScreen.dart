import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class AboutScreen extends StatelessWidget {

  
  final List<Widget> people = ["Lilian Danciger,Presidente", "Gioele Pannetto,Vice Presidente & App Developer,https://instagram.com/giopan.sh", "Daniele Loreto,Caporedattore,https://instagram.com/daniele.loreto", "Tommaso Piccardi,Caposervizi,https://www.instagram.com/tommys_poetry"].map((f) {
    List<String> l = f.split(',');
    //return GestureDetector(child: Text("${l[0]} che fa ${l[1]}"), onTap: () => _launchURL(l[2]),);
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(l[0]),
      subtitle: Text(l[1]),
      onTap: () => _launchURL(l[2]),
    );
  }).toList();

  static _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info sull'app"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  
                  Image.asset('assets/logo.png', width: 130,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(onPressed: () => _launchURL('https://github.com/GioPan04/giornalino-gobetti-volta-app'), child: Text('GITHUB')),
                      FlatButton(onPressed: () => Share.share("Scarica subito l'app del giornlino scolastico del I.S.I.S. Gobetti Volta\n\nhttps://ggvapp.pangio.it"), child: Text('CONDIVIDI')),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 16, bottom: 10),
                child: Text("La nostra redazione:"),
              ),
              Column(
                children: people,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
            ]
          ),
        ),
      ),
    );
  }
}