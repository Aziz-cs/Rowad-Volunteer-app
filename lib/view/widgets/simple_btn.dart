import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class DefaultButton extends StatelessWidget {
//   const DefaultButton({
//     Key? key,
//     required this.label,
//     required this.onPress,
//     this.isCurved = true,
//   }) : super(key: key);

//   final String label;
//   final VoidCallback onPress;
//   final bool isCurved;
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       style: ButtonStyle(
//         elevation: MaterialStateProperty.all(0),
//         backgroundColor: MaterialStateProperty.all(kGreenColor),
//         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(isCurved ? 22.0 : 6),
//           ),
//         ),
//         padding: MaterialStateProperty.all(
//             const EdgeInsets.symmetric(horizontal: 23, vertical: 13.5)),
//         minimumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
//       ),
//       onPressed: onPress,
//       child: Text(
//         label,
//         style: TextStyle(
//           fontSize: 14.sp,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    Key? key,
    required this.label,
    required this.onPress,
    this.isCurved = true,
    this.icon = const SizedBox(),
    this.backgroundColor = kGreenColor,
    this.labelColor = Colors.white,
    this.isClickable = true,
    this.fontSize = 14,
  }) : super(key: key);

  final String label;
  final Color labelColor;
  final VoidCallback onPress;
  final bool isCurved;
  final bool isClickable;
  final Widget icon;
  final Color backgroundColor;
  final int fontSize;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isCurved ? 10.0 : 6),
          ),
        ),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h)),
      ),
      onPressed: isClickable ? onPress : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.h,
            child: icon,
          ),
          SizedBox(width: 7.w),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: labelColor,
                fontSize: fontSize.sp,
                height: 1,
                fontWeight: FontWeight.w100),
          ),
        ],
      ),
    );
  }
}
