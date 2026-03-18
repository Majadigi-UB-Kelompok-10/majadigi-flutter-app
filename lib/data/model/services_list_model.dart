// ? Model for Supabase "services_list" table
class ServiceModel {
  final String id;
  final String? icon;
  final String title;
  final String? description;
  final AdditionalData additionalData;

  ServiceModel({
    required this.id,
    this.icon,
    required this.title,
    this.description,
    required this.additionalData,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      icon: json['icon'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,

      // ? Parsed by a different class since it's a JSONB with dynamic structure
      additionalData: AdditionalData.fromJson(
        json['additional_data'] as Map<String, dynamic>?,
      ),
    );
  }
}

class AdditionalData {
  final Map<String, dynamic> policies;
  final Map<String, dynamic> services;
  final Map<String, dynamic> operationals;

  AdditionalData({
    required this.policies,
    required this.services,
    required this.operationals,
  });

  // Factory to parse the JSON securely
  factory AdditionalData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return AdditionalData(policies: {}, services: {}, operationals: {});
    }

    return AdditionalData(
      // The ?? {} ensures that if Supabase returns null for a missing key,
      // your app defaults to an empty map instead of crashing.
      policies: json['policies'] as Map<String, dynamic>? ?? {},
      services: json['services'] as Map<String, dynamic>? ?? {},
      operationals: json['operationals'] as Map<String, dynamic>? ?? {},
    );
  }
}