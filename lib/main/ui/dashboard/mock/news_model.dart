class NewsModel {
  final String title;
  final String date;
  final String imagePath;
  final List<String> paragraphs;

  NewsModel({
    required this.title,
    required this.date,
    required this.imagePath,
    this.paragraphs = const [],
  });
}