// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stac_custom_form_submit_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StacCustomFormSubmitAction _$StacCustomFormSubmitActionFromJson(
  Map<String, dynamic> json,
) => StacCustomFormSubmitAction(
  nextPageUrl: json['nextPageUrl'] as String,
  formIds: (json['formIds'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$StacCustomFormSubmitActionToJson(
  StacCustomFormSubmitAction instance,
) => <String, dynamic>{
  'nextPageUrl': instance.nextPageUrl,
  'formIds': instance.formIds,
  'actionType': instance.actionType,
};
