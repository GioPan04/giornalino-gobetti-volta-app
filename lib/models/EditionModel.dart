import 'package:intl/intl.dart';

class Edition {
  final String title, author, thumbnailUrl, articleUrl, timestamp;

  Edition({this.title, this.author, this.articleUrl, this.thumbnailUrl, this.timestamp});

  factory Edition.fromJSON(Map<String,dynamic> data) {

    String date(String timestamp) {
      var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);
      var format = DateFormat("dd/MM/yyyy");
      return format.format(date);
    }

    return Edition(
      title: data['title'] as String,
      author: data['author'] as String,
      thumbnailUrl: data['thumnail_url'] as String,
      articleUrl: data['article_url'] as String,
      timestamp: date(data['date']),
    );
  }
}