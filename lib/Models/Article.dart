class Article {
  String? author;
  int? id;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  Article(
      {this.author,
      this.id,
      this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.content});

  factory Article.fromJson(Map<String, dynamic> json) {
    String getUsername(json) {
      if (json == null) return '';
      if (json['user'] != null) {
        print(json['user']['username']);
        return json['user']['username'] ?? '';
      }
      return '';
    }

    return Article(
      author: getUsername(json),
      title: json['title'] ?? '',
      id: json['id'] ?? null,
      description: json['article'] ?? '',
      url: json['title'] as String,
      urlToImage: 'http://localhost:3000/' + (json['fullPhoto'] ?? ''),
      publishedAt: json['title'] ?? '',
      content: json['title'] ?? '',
    );
  }
}
