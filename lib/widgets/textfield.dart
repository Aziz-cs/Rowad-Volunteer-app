import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    this.label = '',
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
  }) : super(key: key);

  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final Widget preIcon;
  final Widget suffixIcon;
  final bool isObsecure;
  final TextInputType inputType;
  final bool isLTRdirection;
  final int maxLines;
  final TextInputAction inputAction;
  final String labelText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h, bottom: 7.h),
      child: TextFormField(
        controller: controller,
        // textDirection: TextDirection.rtl,
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
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          hintTextDirection: TextDirection.rtl,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7.0),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
        ),
        obscureText: isObsecure,
      ),
    );
  }
}
