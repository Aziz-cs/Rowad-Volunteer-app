import 'package:app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../widgets/online_img.dart';
import '../../../widgets/simple_btn.dart';
import '../../model/chance.dart';
import '../chance_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ChanceItem extends StatelessWidget {
  ChanceItem({
    Key? key,
    required this.chance,
  }) : super(key: key);

  Chance chance;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: ChancePage(chance: chance),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      ),
      child: Container(
        width: 160.w,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: CachedOnlineIMG(imageURL: chance.imageURL),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 5.h),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kGreenColor,
                  ),
                  child: Text(
                    chance.title,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (chance.title.length < 25) SizedBox(height: 7.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chance.organization,
                        maxLines: 1,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12.sp,
                          color: kGreenColor,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          Text(
                            'من',
                            style: TextStyle(
                              fontSize: 12.sp,
                              height: 1,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          const Icon(
                            CupertinoIcons.calendar_today,
                            size: 17,
                            color: Colors.green,
                          ),
                          SizedBox(width: 3.w),
                          Flexible(
                            child: Text(
                              chance.startDate,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Text(
                                  'إلى',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    height: 1,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Icon(
                                  CupertinoIcons.calendar_today,
                                  size: 17,
                                  color: Colors.red.shade800,
                                ),
                                SizedBox(width: 3.w),
                                Flexible(
                                  child: Text(
                                    chance.endDate,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.defaultDialog(
                              title: 'حذف هذه الفرصة؟',
                              middleText: '',
                              actions: [
                                SimpleButton(
                                  label: 'تأكيد',
                                  onPress: () {
                                    FirebaseFirestore.instance
                                        .collection('chances')
                                        .doc(chance.id)
                                        .delete();
                                    Get.back();

                                    Fluttertoast.showToast(msg: kMsgDeleted);
                                  },
                                ),
                                SimpleButton(
                                  label: 'إلغاء',
                                  onPress: () => Get.back(),
                                )
                              ],
                            ),
                            child: Icon(
                              CupertinoIcons.delete,
                              size: 17,
                              color: Colors.red.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      if (chance.title.length < 25) SizedBox(height: 7.h),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildIconTitleRow(
                            title: chance.city,
                            iconData: Icons.pin_drop,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: kGreenColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              '${chance.getDaysLeft()} ${chance.getDaysWordinArabic()}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Row _buildIconTitleRow({required String title, required IconData iconData}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        iconData,
        size: 17,
        color: Colors.green,
      ),
      SizedBox(width: 3.w),
      Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.grey.shade600,
        ),
      ),
    ],
  );
}
