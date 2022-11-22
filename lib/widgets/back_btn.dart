import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackBtn extends StatelessWidget {
  BackBtn({
    Key? key,
    this.isBlack = false,
  }) : super(key: key);
  bool isBlack;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios,
            color: isBlack ? Colors.black54 : Colors.white,
            size: 13,
          ),
          SizedBox(width: 3.w),
          Text(
            'رجوع',
            style: TextStyle(
              fontSize: 13.sp,
              color: isBlack ? Colors.black54 : Colors.white,
              height: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
