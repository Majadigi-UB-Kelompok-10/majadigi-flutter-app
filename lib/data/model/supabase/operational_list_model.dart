// ? Enums representing columns
enum OperationalListColumn {
  operational_list_id,
  service_list_id,
  service_url,
  address,
  operational_hour,
  social_media,
  created_at
}

// ? Main Image List Table
class OperationalListModel {
  final String? id;
  final String? fkServiceListId;
  final String? serviceUrl;
  final String? address;
  final Map<String, dynamic>? operationalHour;
  final Map<String, dynamic>? socialMedia;
  final DateTime? createdAt;

  // Constructor
  OperationalListModel({
    this.id,
    this.fkServiceListId,
    this.serviceUrl,
    this.address,
    this.operationalHour,
    this.socialMedia,
    this.createdAt,
  });

  // Factory (JSON Parse)
  factory OperationalListModel.fromJson(Map<String, dynamic> json) {
    return OperationalListModel(
      id: json[OperationalListColumn.operational_list_id.name] as String?,
      fkServiceListId: json[OperationalListColumn.service_list_id.name] as String?,
      serviceUrl: json[OperationalListColumn.service_url.name] as String?,
      address: json[OperationalListColumn.address.name] as String?,
      operationalHour: json[OperationalListColumn.operational_hour.name] as Map<String, dynamic>?,
      socialMedia: json[OperationalListColumn.social_media.name] as Map<String, dynamic>?,
      createdAt: json[OperationalListColumn.created_at.name] as DateTime?,
    );
  }
}