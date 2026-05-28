import '../jdih_document.dart';

class JdihSearchResultItem {
  final String category;
  final String nomor;
  final String tahun;
  final String title;
  final String status;
  final String description;
  final String date;
  final String views;
  final String pdfSize;
  final String tglPenetapan;

  const JdihSearchResultItem({
    required this.category,
    required this.nomor,
    required this.tahun,
    required this.title,
    required this.status,
    required this.description,
    required this.date,
    required this.views,
    required this.pdfSize,
    required this.tglPenetapan,
  });

  factory JdihSearchResultItem.fromJson(Map<String, dynamic> json) {
    return JdihSearchResultItem(
      category: json['category'] as String? ?? '',
      nomor: json['nomor'] as String? ?? '',
      tahun: json['tahun'] as String? ?? '',
      title: json['title'] as String? ?? '',
      status: json['status'] as String? ?? '',
      description: json['description'] as String? ?? '',
      date: json['date'] as String? ?? '',
      views: json['views'] as String? ?? '',
      pdfSize: json['pdfSize'] as String? ?? '',
      tglPenetapan: json['tglPenetapan'] as String? ?? '',
    );
  }

  JdihDocument toDocument() {
    return JdihDocument(
      category: category,
      title: title,
      nomor: '$nomor/$tahun',
      tahun: tahun,
      tglPenetapan: tglPenetapan,
      status: status,
      pdfUrl: '',
      pdfSize: pdfSize,
    );
  }
}