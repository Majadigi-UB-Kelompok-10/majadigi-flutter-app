import 'package:stac/stac.dart';
import 'package:flutter/material.dart';

import 'package:majadigi_mobile/domain/stac_build_runner/stac_custom_form_modal/stac_custom_form_modal.dart';

class StacCustomFormDropdownParser extends StacParser<StacCustomFormModal> {
  const StacCustomFormDropdownParser();

  @override
  String get type => 'customFormModal';

  @override
  StacCustomFormModal getModel(Map<String, dynamic> json) =>
      StacCustomFormModal.fromJson(json);

  @override
  Widget parse(BuildContext context, StacCustomFormModal model) {
    if (model.items == null || model.items!.isEmpty) {
      return const SizedBox.shrink();
    }

    return _DropdownWidget(model: model, formScope: StacFormScope.of(context));
  }
}

class _DropdownWidget extends StatefulWidget {
  const _DropdownWidget({required this.model, this.formScope});
  final StacCustomFormModal model;
  final StacFormScope? formScope;

  @override
  State<StatefulWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<_DropdownWidget> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    if (widget.model.id != null && _selectedValue != null) {
      widget.formScope?.formData[widget.model.id!] = _selectedValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showOptionsModal(context),
      borderRadius: widget.model.borderRadius?.parse,
      child: InputDecorator(
        isEmpty: _selectedValue == null,
        decoration: widget.model.decoration.parse(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Shows the selected value, or an empty string to let the hintText show
            Expanded(
              child: Text(
                _selectedValue ?? '',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );

    // return InkWell(
    //   onTap: () => _showOptionsModal(context),
    //   borderRadius: BorderRadius.circular(16), // Matches your border radius for the ripple effect
    //   child: InputDecorator(
    //     isEmpty: _selectedValue == null,
    //     decoration: InputDecoration(
    //       hintText: widget.model.hintText,
    //       enabledBorder: OutlineInputBorder(
    //         borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       focusedBorder: OutlineInputBorder(
    //         borderSide: const BorderSide(color: Colors.blue, width: 1),
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       fillColor: Colors.white,
    //       filled: true,
    //     ),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         // Shows the selected value, or an empty string to let the hintText show
    //         Expanded(
    //           child: Text(
    //             _selectedValue ?? '',
    //             style: const TextStyle(fontSize: 16),
    //             overflow: TextOverflow.ellipsis,
    //           ),
    //         ),
    //         const Icon(Icons.arrow_drop_down, color: Colors.grey),
    //       ],
    //     ),
    //   ),
    // );

    // return DropdownMenuFormField<String>(
    //   width: double.maxFinite,
    //   hintText: widget.model.hintText,
    //   decorationBuilder: (BuildContext context, MenuController controller) {
    //     return InputDecoration(
    //       enabledBorder: OutlineInputBorder(
    //         borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       focusedBorder: OutlineInputBorder(
    //         borderSide: BorderSide(color: Colors.blue, width: 1),
    //         borderRadius: BorderRadius.circular(16),
    //       ),
    //       fillColor: Colors.white,
    //       filled: true,
    //     );
    //   },
    //   dropdownMenuEntries: widget.model.items!.map((String item) {
    //     return DropdownMenuEntry(value: item, label: item);
    //   }).toList(),
    //   onSelected: (String? newValue) {
    //     setState(() => _selectedValue = newValue);
    //     if (widget.model.id != null && newValue != null) {
    //       widget.formScope?.formData[widget.model.id!] = newValue;
    //     }
    //   },
    // );
  }

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true, // Allows the sheet to size correctly if the list is long
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wraps to the content's size
            children: [
              // Optional: A small drag handle for better UX
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true, // Prevents ListView from taking infinite height
                  itemCount: widget.model.items!.length,
                  itemBuilder: (context, index) {
                    final String item = widget.model.items![index];

                    return ListTile(
                      title: Text(item),
                      // Highlights the currently selected item
                      trailing: _selectedValue == item
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                      onTap: () {
                        // 1. Close the modal
                        Navigator.pop(context);

                        // 2. Execute your original selection logic
                        setState(() => _selectedValue = item);
                        if (widget.model.id != null) {
                          widget.formScope?.formData[widget.model.id!] = item;
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}