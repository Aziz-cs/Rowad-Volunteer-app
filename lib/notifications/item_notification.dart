import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/constants.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin:
              const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 1),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kGreenColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'تم إضافة عمل تطوعي لفريق بناء المستقبل يرجى التقدم بالإنضمام قبل يوم الخميس 22-9-2022',
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.delete,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    CupertinoIcons.calendar,
                    color: kGreenColor,
                    size: 19.5,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '20-9-2022',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: kGreenColor,
                    ),
                  )
                ],
              ),
              SizedBox(width: 30.w),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    CupertinoIcons.time,
                    color: kGreenColor,
                    size: 19.5,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    '16:44',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: kGreenColor,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
