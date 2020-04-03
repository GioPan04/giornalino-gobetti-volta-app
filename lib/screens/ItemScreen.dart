import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemScreen extends StatefulWidget {
  ItemScreen({Key key}) : super(key: key);

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {

  void _launchURL(String url) async {
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      print("Can't launch url");
    }
  }

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
                    GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemGallery(imgsUrl: args.imgsUrl, i: i, heroTag: args.uuid,))), child: Hero(tag: args.uuid, child: Image.network(args.imgsUrl[i], fit: BoxFit.cover, alignment: Alignment.center, )))
                    :
                    GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemGallery(imgsUrl: args.imgsUrl, i: i, heroTag: i.toString()))), child: Hero(tag: i.toString(), child: Image.network(args.imgsUrl[i], fit: BoxFit.cover, alignment: Alignment.center,)));
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(args.name, style: TextStyle(fontFamily: "OpenSans-Bold", fontSize: 20, color: Color.fromRGBO(255, 255, 255, 0.87))),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("${args.price} €", style: TextStyle(fontFamily: "OpenSans-SemiBold", fontSize: 18, color: Color.fromRGBO(255, 255, 255, 0.87))),
            ),
            SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Autore: ${args.author['name']}', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.8))),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(args.description, textAlign: TextAlign.justify,),
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: SizedBox(
          height: 50,
          child: RaisedButton(
            
            child: Text("CONTATTA", style: TextStyle(fontSize: 18, fontFamily: "RobotoSlab", fontWeight: FontWeight.w900, letterSpacing: 0.9),),
            onPressed: () => _launchURL('tel:${args.author['number']}'),
            
          ),
        ),
      ),
    );
  }
}

class ItemScreenArgs {
  final String uuid, name, price, description;
  final List<dynamic> imgsUrl;
  final Map author;

  ItemScreenArgs({this.uuid, this.name, this.price, this.imgsUrl, this.author, this.description}); 
}

class ItemGallery extends StatelessWidget {

  final List<dynamic> imgsUrl;
  final int i;
  final String heroTag;

  const ItemGallery({Key key, this.imgsUrl, this.i, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(initialPage: i ?? 0);

    return Scaffold(
      backgroundColor: Color(0xFF000000),
      appBar: AppBar(),
      body: PageView.builder(
        controller: _pageController,
        itemCount: imgsUrl.length,
        itemBuilder: (context, it) {
          return Hero(tag: heroTag, child: Image.network(imgsUrl[it]));
        },
 
      ),
    );
  }
}