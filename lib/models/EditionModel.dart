class Edition {
  final String title, author;

  Edition({this.title, this.author});

  factory Edition.fromJSON(Map<String,dynamic> data) {
    return Edition(
      title: data['title']
    );
  }
}