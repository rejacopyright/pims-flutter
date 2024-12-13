import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './config.dart';

// class DropdownDataController extends GetxController {
//   final selected = Rxn<Map<String, dynamic>>();
//   setSelected(e) => selected.value = e;
// }

class DropdownData extends StatefulWidget {
  const DropdownData({
    super.key,
    required this.title,
    this.items = const [],
    this.initialValue,
    this.onChange,
  });

  final String title;
  final List<Map<String, dynamic>> items;
  final ValueChanged<Map<String, dynamic>?>? onChange;
  final dynamic initialValue;

  @override
  State<DropdownData> createState() => DropdownDataWidget();
}

class DropdownDataWidget extends State<DropdownData> {
  Map<String, dynamic>? selected;

  void setSelected(e) => setState(() => selected = e);

  @override
  void initState() {
    if (!['', null].contains(widget.initialValue)) {
      final initialSelect = widget.items
          .firstWhereOrNull((item) => item['value'] == widget.initialValue);
      if (initialSelect != null) {
        selected = initialSelect;
      }
    } else {
      selected = null;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isSelected = selected != null && selected?['value'] != null;

    if (!['', null].contains(widget.initialValue)) {
      final initialSelect = widget.items
          .firstWhereOrNull((item) => item['value'] == widget.initialValue);
      if (initialSelect != null) {
        setSelected(initialSelect);
      }
    } else {
      setSelected(null);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DropdownSearch<Map<String, dynamic>>(
          clickProps: clickProps,
          mode: Mode.custom,
          items: (f, cs) => widget.items,
          compareFn: (a, b) => a['value'] == b['label'],
          popupProps: PopupProps.modalBottomSheet(
            showSearchBox: true,
            searchDelay: Duration(milliseconds: 100),
            // disableFilter: true,
            // menuProps: menuProps,
            modalBottomSheetProps: modalBottomSheetProps,
            searchFieldProps: TextFieldProps(
              autofocus: true,
              decoration: searchInputDecoration(primaryColor),
              onChanged: (e) {},
            ),
            fit: FlexFit.tight,
            containerBuilder: (context, popupWidget) {
              return containerBuilder(context, popupWidget);
            },
            itemClickProps: itemClickProps,
            itemBuilder: (context, item, isDisabled, isSelected) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  item['label'] ?? '',
                  style: TextStyle(fontSize: 16),
                ),
              );
            },
          ),
          suffixProps: suffixProps,
          dropdownBuilder: (ctx, selectedItem) => Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffdddddd)),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              isSelected && selected?['label'] != null
                  ? selected!['label']
                  : widget.title,
              style: TextStyle(
                color: isSelected ? Colors.black : Color(0xff777777),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          onChanged: (e) {
            setSelected(e);
            widget.onChange!(e);
          },
        ),
        isSelected
            ? Positioned(
                top: -10,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  margin: EdgeInsets.only(left: 15),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 14,
                      // fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
