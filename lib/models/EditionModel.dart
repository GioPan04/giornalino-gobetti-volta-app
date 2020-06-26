class Edition {
  final String title, author, thumbnailUrl, articleUrl, timestamp;

  Edition({this.title, this.author, this.articleUrl, this.thumbnailUrl, this.timestamp});

  factory Edition.fromJSON(Map<String,dynamic> data) {
    return Edition(
      title: data['title'] as String,
      author: data['author'] as String,
      thumbnailUrl: data['thumnail_url'] as String,
      articleUrl: data['article_url'] as String,
      timestamp: data['date'] as String,
    );
  }
}