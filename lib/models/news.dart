class News {
  final DateTime date;
  final String title;
  final String body;
  final String url;
  final String imageUrl;
  final String source;

  const News({
    required this.date,
    required this.title,
    required this.body,
    required this.url,
    required this.imageUrl,
    required this.source,
  });

  News.fromJson(Map<String, dynamic> json)
      : date = DateTime.tryParse(json['date']) ?? DateTime.now(),
        title = json['title'] ?? 'Title',
        body = json['body'] ?? 'Body',
        url = json['url'] ?? '',
        imageUrl = json['image'] ?? '',
        source = json['source'] ?? '';
}
