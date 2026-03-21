/*
 * This is the model for existing supabase table
 * to ensure no second-guessing in development
 */

// * services_list table section * //
// ? Enums representing columns
enum ServiceListColumn {
  id,
  title,
  description,
  iconUrl,
  createdAt
}

// ? Main Service List Table
class ServiceListModel {
  final String? id;
  final String? title;
  final String? description;
  final String? iconUrl;
  final String? createdAt;

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
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }
}