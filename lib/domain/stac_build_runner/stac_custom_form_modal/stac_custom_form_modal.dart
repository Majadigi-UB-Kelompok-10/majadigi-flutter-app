import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'stac_custom_form_modal.g.dart';

@JsonSerializable(explicitToJson: true)
class StacCustomFormModal extends StacWidget {
  const StacCustomFormModal({
    this.id,
    this.hintText,
    this.items,
    this.borderRadius,
    required this.decoration,
  });

  final String? id;
  final String? hintText;
  final StacBorderRadius? borderRadius;
  final StacInputDecoration decoration;

  @JsonKey(defaultValue: [])
  final List<String>? items;

  @override
  @JsonKey(includeToJson: true, includeFromJson: false)
  String get type => 'customFormModal';

  factory StacCustomFormModal.fromJson(Map<String, dynamic> json) => _$StacCustomFormModalFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StacCustomFormModalToJson(this);
}