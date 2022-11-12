import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    this.hintText = '',
    required this.controller,
    required this.validator,
    this.preIcon = const SizedBox(),
    this.suffixIcon = const SizedBox(),
    this.isObsecure = false,
    this.inputType = TextInputType.text,
    this.maxLines = 1,
    this.isLTRdirection = false,
    this.inputAction = TextInputAction.done,
    this.labelText = '',
    this.isLabelCentered = false,
    this.isReadOnly = false,
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final Widget preIcon;
  final Widget suffixIcon;
  final bool isObsecure;
  final bool isLabelCentered;
  final TextInputType inputType;
  final bool isLTRdirection;
  final int maxLines;
  final TextInputAction inputAction;
  final String labelText;
  final bool isReadOnly;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, bottom: 7.h),
      child: TextFormField(
        textAlign: isLabelCentered
            ? TextAlign.center
            : isLTRdirection
                ? TextAlign.left
                : TextAlign.right,
        controller: controller,
        readOnly: isReadOnly,
        cursorColor: Colors.black,
        maxLines: maxLines,
        keyboardType: inputType,
        textInputAction: inputAction,
        textDirection: isLTRdirection ? TextDirection.ltr : TextDirection.rtl,
        style: const TextStyle(color: Colors.black),
        validator: validator,
        decoration: InputDecoration(
          // labelText: labelText,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          hintTextDirection: TextDirection.rtl,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: 1.0,
            ),
          ),
          suffixIcon: suffixIcon,
          prefixIcon: preIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        obscureText: isObsecure,
      ),
    );
  }
}
