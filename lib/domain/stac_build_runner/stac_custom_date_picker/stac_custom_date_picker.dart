import 'package:json_annotation/json_annotation.dart';
import 'package:stac/stac_core.dart';

part 'stac_custom_date_picker.g.dart';

@JsonSerializable(explicitToJson: true)
class StacCustomDatePicker extends StacWidget {
  const StacCustomDatePicker({
    this.id,
    this.decoration,
  });

  final String? id;
  final StacInputDecoration? decoration;

  @override
  @JsonKey(includeToJson: true, includeFromJson: false)
  String get type => 'customDatePicker';

  factory StacCustomDatePicker.fromJson(Map<String, dynamic> json) => _$StacCustomDatePickerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$StacCustomDatePickerToJson(this);
}