// ? Enums representing columns
enum IntegrationListColumn {
  integration_list_id,
  service_list_id,
  title,
  page_url,
  data_url,
  icon_url,
  created_at
}

// ? Main Image List Table
class IntegrationListModel {
  final String? id;
  final String? fkServiceListId;
  final String? title;
  final String? pageUrl;
  final String? dataUrl;
  final String? iconUrl;
  final DateTime? createdAt;

  // Constructor
  IntegrationListModel({
    this.id,
    this.fkServiceListId,
    this.title,
    this.pageUrl,
    this.dataUrl,
    this.iconUrl,
    this.createdAt,
  });

  // Factory (JSON Parse)
  factory IntegrationListModel.fromJson(Map<String, dynamic> json) {
    return IntegrationListModel(
      id: json[IntegrationListColumn.integration_list_id.name] as String?,
      fkServiceListId: json[IntegrationListColumn.service_list_id.name] as String?,
      title: json[IntegrationListColumn.title.name] as String?,
      pageUrl: json[IntegrationListColumn.page_url.name] as String?,
      dataUrl: json[IntegrationListColumn.data_url.name] as String?,
      iconUrl: json[IntegrationListColumn.icon_url.name] as String?,
      createdAt: json[IntegrationListColumn.created_at.name] as DateTime?,
    );
  }
}