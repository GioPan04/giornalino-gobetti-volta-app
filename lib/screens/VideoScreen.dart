import 'package:flutter/material.dart';
import 'package:giornalino_gv_app/utils/Video.dart';
import 'package:shimmer/shimmer.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  _buildShimmer() {
    return ListView.builder(
      itemCount: 100,
      padding: EdgeInsets.only(top: 2),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (c, i) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Shimmer.fromColors(
            highlightColor: Color(0xFFC9C9C9), //Colore sfumatura (+ chiaro)
            baseColor: Color(0xFF636363), //Colore di sfondo
            child: VideoLoading(),
          ),
        );
      }
    );
  }

  List<Map<String,String>> data = [
    {
      "title": "Un video a caso mentre programmo",
      "thumbnail": "https://upload.wikimedia.org/wikipedia/commons/7/7c/Aspect_ratio_16_9_example.jpg"
    },
    {
      "title": "Un video a caso mentre programmo",
      "thumbnail": "https://upload.wikimedia.org/wikipedia/commons/7/7c/Aspect_ratio_16_9_example.jpg"
    },
    {
      "title": "Un video a caso mentre programmo",
      "thumbnail": "https://upload.wikimedia.org/wikipedia/commons/7/7c/Aspect_ratio_16_9_example.jpg"
    },
    {
      "title": "Un video a caso mentre programmo",
      "thumbnail": "https://upload.wikimedia.org/wikipedia/commons/7/7c/Aspect_ratio_16_9_example.jpg"
    },
    {
      "title": "Un video a caso mentre programmo",
      "thumbnail": "https://upload.wikimedia.org/wikipedia/commons/7/7c/Aspect_ratio_16_9_example.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (c,i) => Video(title: data[i]['title'], thumbnailUrl: data[i]['thumbnail']),
    );
  }
}