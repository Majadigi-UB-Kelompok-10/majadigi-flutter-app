import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'stac_form_modal_builder.g.dart';

@JsonSerializable(explicitToJson: true)
class StacFormModalBuilder extends StacWidget {
  const StacFormModalBuilder({
    required this.data,
  });

  // Map<String, List<String>>
  final dynamic data;

  @override
  @JsonKey(includeToJson: true, includeFromJson: false)
  String get type => 'formModalBuilder';

  factory StacFormModalBuilder.fromJson(Map<String, dynamic> json) => _$StacFormModalBuilderFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StacFormModalBuilderToJson(this);
}