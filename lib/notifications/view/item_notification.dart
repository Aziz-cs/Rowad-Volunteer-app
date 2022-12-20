import 'package:app/notifications/model/notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants.dart';

class NotificationItem extends StatelessWidget {
  NotificationItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  GlobalNotification notification;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          // contentPadding: EdgeInsets.symmetric(
          //   vertical: 2.h,
          //   horizontal: 10.w,
          // ),
          leading: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          tileColor: kGreenColor,
          title: Text(
            notification.title,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            notification.body,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white70,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Icon(
                    CupertinoIcons.time,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    notification.getTime(),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              Text(
                notification.getDate(),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
        const Divider(
          color: Colors.white70,
          height: 0,
        ),
      ],
    );
    // Column(
    //   children: [
    //     Container(
    //       width: double.infinity,
    //       margin:
    //           const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 1),
    //       padding: const EdgeInsets.all(10),
    //       decoration: BoxDecoration(
    //         color: kGreenColor,
    //         borderRadius: BorderRadius.circular(10),
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Flexible(
    //             child: Text(
    //               notification.title,
    //               style: TextStyle(
    //                 fontSize: 14.sp,
    //                 color: Colors.white,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 15.w),
    //       child: Row(
    //         children: [
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             children: [
    //               const Icon(
    //                 CupertinoIcons.calendar,
    //                 color: kGreenColor,
    //                 size: 19.5,
    //               ),
    //               SizedBox(width: 5.w),
    //               Text(
    //                 '20-9-2022',
    //                 style: TextStyle(
    //                   fontSize: 14.sp,
    //                   color: kGreenColor,
    //                 ),
    //               )
    //             ],
    //           ),
    //           SizedBox(width: 30.w),
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             children: [
    //               const Icon(
    //                 CupertinoIcons.time,
    //                 color: kGreenColor,
    //                 size: 19.5,
    //               ),
    //               SizedBox(width: 5.w),
    //               Text(
    //                 '16:44',
    //                 style: TextStyle(
    //                   fontSize: 14.sp,
    //                   color: kGreenColor,
    //                 ),
    //               )
    //             ],
    //           ),
    //         ],
    //       ),
    //     )
    //   ],
    // );
  }
}
