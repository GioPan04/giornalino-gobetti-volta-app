//Import Flutter & Dart stuff
import 'package:flutter/material.dart';
import 'package:giornalino_gv_app/models/EditionModel.dart';
import 'package:giornalino_gv_app/providers/LastEditionsProvider.dart';
import 'package:giornalino_gv_app/screens/EditionScreen.dart';
import 'package:giornalino_gv_app/widgets/EditionThumbnail.dart';
import 'package:provider/provider.dart';

import 'package:animations/animations.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<LastEditionsProvider>(context, listen: false).getData();
    });
  }

  void openEdition(Edition edition) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
        title: Text("Gobetti Volta Reporter"),
      ),
      body: Consumer<LastEditionsProvider>(
        builder: (context, data, _) {
          if(data.failure != null) return Center(child: Text(data.failure.toString(),));
          if(data.editions != null) return ListView.separated(
            separatorBuilder: (context, i) => SizedBox(height: 5,),
            itemBuilder: (context, i) => OpenContainer(
              closedBuilder: (context, _) => EditionThumbnail(data.editions[i], ),
              openBuilder: (context, _) => EditionScreen(data.editions[i]),
              closedColor: Colors.grey[850],
              openColor: Colors.grey[850],
              transitionType: ContainerTransitionType.fade,
              closedElevation: 0,
              openElevation: 5,
            ),
            itemCount: data.editions.length,
          );
          return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}