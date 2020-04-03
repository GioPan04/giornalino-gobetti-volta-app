import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ItemScreen.dart';

class MercatinoScreen extends StatefulWidget {
  MercatinoScreen({Key key}) : super(key: key);

  @override
  _MercatinoScreenState createState() => _MercatinoScreenState();
}

class _MercatinoScreenState extends State<MercatinoScreen> with AutomaticKeepAliveClientMixin<MercatinoScreen> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder(
      stream: Firestore.instance.collection('mercatino').snapshots(),
      builder: (context, snapshot) {

        if(snapshot.hasData) {
          var data = snapshot.data.documents;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () => Navigator.pushNamed(context, '/item', arguments: ItemScreenArgs(uuid: data[i].documentID, name: data[i]['name'], price: data[i]['price'].toString(), imgsUrl: data[i]['imageUrl'], author: data[i]['author'], description: data[i]['description'])),
                child: MercatinoItem(
                  name: data[i]['name'],
                  price: data[i]['price'].toString(),
                  imgUrl: data[i]['imageUrl'][0],
                  uuid: data[i].documentID,
                ),
              );
            },
          );
        } else if(snapshot.hasError) {
          return Text("Error");
        } else {
          return Center(child: CircularProgressIndicator(),);
        }

        
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MercatinoItem extends StatelessWidget {

  final String name, uuid;
  final String price;
  final String imgUrl;

  const MercatinoItem({Key key, this.name, this.price, this.imgUrl, this.uuid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
            child: Hero(tag: uuid,child: Image.network(imgUrl, fit: BoxFit.cover, width: 160, height: (160*9) / 16, alignment: Alignment.center,)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(name, style: TextStyle(fontFamily: "OpenSans-SemiBold", fontSize: 17)),
                SizedBox(height: 10),
                Text("$price €"),
              ],
            ),
          )
        ],
      ),
    );
  }


  /*
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.network(imgUrl),
        SizedBox(height: 3),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(name, style: TextStyle(fontSize: 22, color: Color.fromRGBO(255, 255, 255, 0.87)),),
            ),
            Spacer(),
            Text("€ $price", style: TextStyle(fontSize: 34, color: Color.fromRGBO(255, 255, 255, 0.6), fontFamily: "RobotoSlab"),),
          ],
        )
      ],
    );
  }
  */
}