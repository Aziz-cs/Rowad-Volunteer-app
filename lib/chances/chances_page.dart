import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constants.dart';
import '../home/item_chance.dart';

class ChancesPage extends StatelessWidget {
  const ChancesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kGreenColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'جميع الفرص التطوعية',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'ترتيب حسب',
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1,
                  ),
                ),
                SizedBox(width: 3.w),
                const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Expanded(
            child: SingleChildScrollView(
              child: GridView.count(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: List.generate(
                  8,
                  (index) => ChanceItem(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
