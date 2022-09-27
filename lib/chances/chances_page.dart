import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constants.dart';
import '../home/item_chance.dart';

class ChancesPage extends StatelessWidget {
  const ChancesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Column(
            children: [
              Container(
                height: 100.h,
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: kGreenColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'جميع الفرص التطوعية',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'ترتيب حسب',
                              style: TextStyle(
                                fontSize: 14.sp,
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
                  ],
                ),
              ),
            ],
          ),
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
