
import 'package:stac/stac.dart';
import 'package:flutter/material.dart';

import 'package:majadigi_mobile/domain/stac_build_runner/stac_form_builder/stac_form_modal_builder.dart';

class StacFormModalBuilderParser extends StacParser<StacFormModalBuilder> {
  const StacFormModalBuilderParser();

  @override
  String get type => 'formModalBuilder';

  @override
  StacFormModalBuilder getModel(Map<String, dynamic> json) =>
      StacFormModalBuilder.fromJson(json);

  @override
  Widget parse(BuildContext context, StacFormModalBuilder model) {
    if (model.data.isNotEmpty) {
      final convertedData = ((model.data) as Map<String, dynamic>);
      return _Form(data: convertedData);
    }

    // Fallback
    return SizedBox.shrink();
  }
}

class _Form extends StatefulWidget {
  final Map<String, dynamic> data;
  const _Form({required this.data});

  @override
  State<StatefulWidget> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final formKey = GlobalKey<FormState>();
  final Map<String, String> selectedFilters = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.0,
        children: [
          for (final entry in widget.data.entries) ...[
            // Create Dropdowns
            DropdownMenuFormField(
              decorationBuilder: (BuildContext context, MenuController controller) {
                return InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: (entry.value is List)
                      ? List<String>.from(entry.value.whereType<String>().toList()).first
                      : List<String>.from(entry.value is Map ? entry.value.keys.cast<String>().toList() : []).first,
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                );
              },
              // initialSelection: _selectedFilters[entry.key],
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: (entry.value is List)
                ? List<String>.from(entry.value.whereType<String>().toList()).map((String value) {
                  return DropdownMenuEntry(
                    value: value,
                    label: value,
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all<Color>(Colors.grey.shade500),
                    ),
                  );
                }).toList()
                : List<String>.from(entry.value is Map ? entry.value.keys.cast<String>().toList() : []).map((String value) {
                  return DropdownMenuEntry(
                    value: value,
                    label: value,
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all<Color>(Colors.grey.shade500),
                    ),
                  );
                }).toList(),
              menuStyle: MenuStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
              ),
              onSelected: (value) {
                setState(() {
                  selectedFilters[entry.key] = value as String;
                });
              }
            ),
          ]
        ],
      ),
    );
  }
}