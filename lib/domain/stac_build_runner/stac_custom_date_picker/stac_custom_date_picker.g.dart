// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_custom_date_picker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StacCustomDatePicker _$StacCustomDatePickerFromJson(
  Map<String, dynamic> json,
) => StacCustomDatePicker(
  id: json['id'] as String?,
  decoration: json['decoration'] == null
      ? null
      : StacInputDecoration.fromJson(
          json['decoration'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$StacCustomDatePickerToJson(
  StacCustomDatePicker instance,
) => <String, dynamic>{
  'id': instance.id,
  'decoration': instance.decoration?.toJson(),
  'type': instance.type,
};
