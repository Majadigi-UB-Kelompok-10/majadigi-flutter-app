import 'package:stac/stac.dart';
import 'package:flutter/material.dart';

import 'package:majadigi_mobile/domain/stac_build_runner/stac_custom_date_picker/stac_custom_date_picker.dart';

class StacCustomDatePickerParser extends StacParser<StacCustomDatePicker> {
  const StacCustomDatePickerParser();

  @override
  String get type => 'customDatePicker';

  @override
  StacCustomDatePicker getModel(Map<String, dynamic> json) =>
      StacCustomDatePicker.fromJson(json);

  @override
  Widget parse(BuildContext context, StacCustomDatePicker model) {
    return _DatePickerWidget(model, StacFormScope.of(context));
  }
}

class _DatePickerWidget extends StatefulWidget {
  const _DatePickerWidget(this.model, this.formScope);
  final StacCustomDatePicker model;
  final StacFormScope? formScope;

  @override
  State<_DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<_DatePickerWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // Format the date as needed
      final dateString = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      _controller.text = dateString;

      if (widget.model.id != null) {
        widget.formScope?.formData[widget.model.id!] = dateString;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration:
      widget.model.decoration?.parse(context),
      // InputDecoration(
      //   hintText: "Test",
      //   suffixIcon: const Icon(Icons.calendar_today),
      //   filled: true,
      //   fillColor: Colors.white,
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(16),
      //     borderSide: BorderSide(color: Colors.blueAccent, width: 1),
      //   )
      // ),
      onTap: () => _selectDate(context),
    );
  }
}