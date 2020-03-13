import 'package:flutter/material.dart';

class ItemScreen extends StatefulWidget {
  ItemScreen({Key key}) : super(key: key);

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {

    final ItemScreenArgs args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0x00000000),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 10/7,
              child: Container(
                width: double.infinity,
                child: PageView.builder(
                  itemCount: args.imgsUrl.length,
                  itemBuilder: (c, i) {
                    return (i == 0) ?
                    Hero(tag: args.uuid, child: Image.network(args.imgsUrl[i], fit: BoxFit.cover, alignment: Alignment.center, loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
        if (loadingProgress == null)
          return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },))
                    :
                    Image.network(args.imgsUrl[i], fit: BoxFit.cover, alignment: Alignment.center,);
                  },
                ),
              ),
            ),
            Text(args.name, style: TextStyle(fontFamily: "OpenSans-Bold", fontSize: 20)),
            Text("${args.price} €", style: TextStyle(fontFamily: "OpenSans-SemiBold", fontSize: 18)),
            Text('Autore ${args.author}'),

          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
        child: RaisedButton(
          
          child: Text("CONTATTA", style: TextStyle(fontSize: 18, fontFamily: "RobotoSlab", fontWeight: FontWeight.w900, letterSpacing: 0.9),),
          onPressed: () {},
          
        ),
      ),
    );
  }
}

class ItemScreenArgs {
  final String uuid, name, price;
  final List<dynamic> imgsUrl;
  final Map author;

  ItemScreenArgs(this.uuid, this.name, this.price, this.imgsUrl, this.author); 
}