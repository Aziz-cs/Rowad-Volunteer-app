import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';

const Color kLightPink = Color(0xFFf95e73);

class DropDownMenu extends StatelessWidget {
  DropDownMenu({
    required this.value,
    required this.items,
    required this.onChanged,
    this.arrowColor = Colors.grey,
    this.fontSize = 20,
    this.textColor = Colors.black,
    this.removeUnderLine = false,
    this.removeHeightPadding = false,
    this.dropdowncolor = Colors.white,
  });

  final String value;
  final List<String> items;
  Function(String?)? onChanged;
  final Color textColor;
  final Color arrowColor;
  final Color dropdowncolor;
  double fontSize;
  bool removeUnderLine;
  bool removeHeightPadding;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      dropdownColor: dropdowncolor,
      iconEnabledColor: arrowColor,
      underline: removeUnderLine
          ? const SizedBox()
          : Divider(
              height: 2,
              thickness: 1,
              color: Colors.grey.shade300,
            ),
      value: value,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              height: removeHeightPadding ? 0.5 : 1.1.h,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
