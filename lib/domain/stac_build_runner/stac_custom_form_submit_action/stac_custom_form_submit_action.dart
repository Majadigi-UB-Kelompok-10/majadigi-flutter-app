import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'stac_custom_form_submit_action.g.dart';

@JsonSerializable(explicitToJson: true)
class StacCustomFormSubmitAction extends StacAction {
  const StacCustomFormSubmitAction({
    required this.nextPageUrl,
    required this.formIds
  });

  final String nextPageUrl;
  final List<String> formIds;

  factory StacCustomFormSubmitAction.fromJson(Map<String, dynamic> json) =>
    _$StacCustomFormSubmitActionFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StacCustomFormSubmitActionToJson(this);

  @override
  String get actionType => 'formSubmitAction';
}