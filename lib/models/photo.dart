class Photo {
  final int id;
  final String url;
  final String title;

  Photo({this.id, this.url, this.title});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(id: json['id'], url: json['url'], title: json['title']);
  }
}
