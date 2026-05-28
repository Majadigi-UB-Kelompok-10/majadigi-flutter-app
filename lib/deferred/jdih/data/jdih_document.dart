class JdihDocument {
  final String category;
  final String title;
  final String nomor;
  final String tahun;
  final String tglPenetapan;
  final String status;
  final String pdfUrl;
  final String pdfSize;

  const JdihDocument({
    required this.category,
    required this.title,
    required this.nomor,
    required this.tahun,
    required this.tglPenetapan,
    required this.status,
    required this.pdfUrl,
    required this.pdfSize,
  });

  factory JdihDocument.fromJson(Map<String, dynamic> json) {
    return JdihDocument(
      category: json['category'] as String? ?? '',
      title: json['title'] as String? ?? '',
      nomor: json['nomor'] as String? ?? '',
      tahun: json['tahun'] as String? ?? '',
      tglPenetapan: json['tglPenetapan'] as String? ?? '',
      status: json['status'] as String? ?? '',
      pdfUrl: json['pdfUrl'] as String? ?? '',
      pdfSize: json['pdfSize'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'title': title,
      'nomor': nomor,
      'tahun': tahun,
      'tglPenetapan': tglPenetapan,
      'status': status,
      'pdfUrl': pdfUrl,
      'pdfSize': pdfSize,
    };
  }
}
