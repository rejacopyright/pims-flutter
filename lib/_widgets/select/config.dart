import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

final formKey = GlobalKey<FormState>();
final outlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xffdddddd)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);
final labelStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
focusedBorder(Color color) => outlineInputBorder.copyWith(
      borderSide: BorderSide(color: color),
    );

inputDecoration(String? text, Color color) {
  return InputDecoration(
    hintText: 'Masukan ${text ?? ''}',
    labelText: text ?? 'Label',
    labelStyle: labelStyle,
    // floatingLabelBehavior: FloatingLabelBehavior.always,
    hintStyle: TextStyle(color: Color(0xff777777)),
    contentPadding: EdgeInsets.symmetric(horizontal: 24),
    border: outlineInputBorder,
    enabledBorder: outlineInputBorder,
    focusedBorder: focusedBorder(color),
  );
}

searchInputDecoration(Color color) {
  return InputDecoration(
    hintText: 'Cari',
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
    border: outlineInputBorder,
    enabledBorder: outlineInputBorder,
    focusedBorder: focusedBorder(color),
  );
}

final clickProps = ClickProps(
  borderRadius: BorderRadius.circular(50),
);

final menuProps = MenuProps(
  align: MenuAlign.topCenter,
  backgroundColor: Colors.white,
  borderRadius: BorderRadius.circular(20),
  barrierColor: Colors.black.withOpacity(0.15),
  shadowColor: Colors.black.withOpacity(0.5),
);

final modalBottomSheetProps = ModalBottomSheetProps(
  useSafeArea: true,
  backgroundColor: Colors.white,
  barrierColor: Colors.black.withOpacity(0.15),
);

final itemClickProps = ClickProps(
  borderRadius: BorderRadius.circular(10),
  splashColor: Colors.black.withOpacity(0.05),
);

final suffixProps = DropdownSuffixProps(
  dropdownButtonProps: DropdownButtonProps(
    iconClosed: Icon(Icons.keyboard_arrow_down),
    iconOpened: Icon(Icons.keyboard_arrow_up),
  ),
);

containerBuilder(context, popupWidget) {
  return SafeArea(
    child: Container(
      padding: EdgeInsets.all(10),
      child: popupWidget,
    ),
  );
}

onTapOutside() {
  formKey.currentState?.validate();
  FocusManager.instance.primaryFocus?.unfocus();
}
