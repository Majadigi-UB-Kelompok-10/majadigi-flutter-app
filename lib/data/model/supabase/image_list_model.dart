// ? Enums representing columns
enum ImageListColumn {
  image_list_id,
  service_list_id,
  image_url,
  semantic_label,
  created_at
}

// ? Main Image List Table
class ImageListModel {
  final String? id;
  final String? fkServiceListId;
  final String? imageUrl;
  final String? semanticLabel;
  final DateTime? createdAt;

  // Constructor
  ImageListModel({
    this.id,
    this.fkServiceListId,
    this.imageUrl,
    this.semanticLabel,
    this.createdAt,
  });

  // Factory (JSON Parse)
  factory ImageListModel.fromJson(Map<String, dynamic> json) {
    return ImageListModel(
      id: json[ImageListColumn.image_list_id.name] as String?,
      fkServiceListId: json[ImageListColumn.service_list_id.name] as String?,
      imageUrl: json[ImageListColumn.image_url.name] as String?,
      semanticLabel: json[ImageListColumn.semantic_label.name] as String?,
      createdAt: json[ImageListColumn.created_at.name] as DateTime?,
    );
  }
}