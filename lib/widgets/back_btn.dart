import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackBtn extends StatelessWidget {
  const BackBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Row(
        children: [
          const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 13,
          ),
          SizedBox(width: 3.w),
          Text(
            'رجوع',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white,
              height: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
