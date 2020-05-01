import 'package:flutter/material.dart';

class Video extends StatelessWidget {

  final String title, thumbnailUrl;

  const Video({Key key, this.title, this.thumbnailUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16/9,
            child: ClipRRect(child: Image.network(thumbnailUrl), borderRadius: BorderRadius.circular(10),)
          ),
          SizedBox(height: 10,),
          Text(title, style: TextStyle(fontFamily: "OpenSans-Bold", fontSize: 21, height: 1),),
        ],
      ),
    );
  }
}

class VideoLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              color: Colors.grey,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: 30,
            color: Colors.grey,
            width: double.infinity
          )
        ],
      ),
    );
  }
}