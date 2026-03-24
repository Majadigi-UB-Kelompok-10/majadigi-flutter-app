// ? Enums representing columns
enum ServiceListColumn {
  service_list_id,
  title,
  description,
  icon_url,
  created_at
}

// ? Main Service List Table
class ServiceListModel {
  final String? id;
  final String? title;
  final String? description;
  final String? iconUrl;
  final DateTime? createdAt;

  // Constructor
  ServiceListModel({
    this.id,
    this.title,
    this.description,
    this.iconUrl,
    this.createdAt,
  });

  // Factory (JSON Parse)
  factory ServiceListModel.fromJson(Map<String, dynamic> json) {
    return ServiceListModel(
      id: json[ServiceListColumn.service_list_id.name] as String?,
      title: json[ServiceListColumn.title.name] as String?,
      description: json[ServiceListColumn.description.name] as String?,
      iconUrl: json[ServiceListColumn.icon_url.name] as String?,
      createdAt: json[ServiceListColumn.created_at.name] as DateTime?,
    );
  }
}