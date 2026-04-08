// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_custom_form_modal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StacCustomFormModal _$StacCustomFormModalFromJson(Map<String, dynamic> json) =>
    StacCustomFormModal(
      id: json['id'] as String?,
      hintText: json['hintText'] as String?,
      items:
          (json['items'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      borderRadius: json['borderRadius'] == null
          ? null
          : StacBorderRadius.fromJson(json['borderRadius']),
      decoration: StacInputDecoration.fromJson(
        json['decoration'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$StacCustomFormModalToJson(
  StacCustomFormModal instance,
) => <String, dynamic>{
  'id': instance.id,
  'hintText': instance.hintText,
  'borderRadius': instance.borderRadius?.toJson(),
  'decoration': instance.decoration.toJson(),
  'items': instance.items,
  'type': instance.type,
};
