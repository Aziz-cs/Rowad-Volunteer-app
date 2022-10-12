import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/constants.dart';
import '../../widgets/circular_loading.dart';
import '../model/chance.dart';
import 'widgets/item_chance.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chances')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: ((context, snapshot) {
                List<ChanceItem> chanceItems = [];
                print(snapshot.connectionState.toString());
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasError) {
                    print('has error in loading news');
                    return const Center(child: Text('هناك خطأ ما'));
                  }
                  var chancesData = snapshot.data!.docs;
                  chancesData.forEach(
                    (chanceElement) {
                      Chance aChance = Chance.fromDB(
                        chanceElement.data() as Map<String, dynamic>,
                        chanceElement.id,
                      );
                      chanceItems.add(ChanceItem(
                        chance: aChance,
                      ));
                    },
                  );
                  return Expanded(
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: chanceItems.reversed.toList(),
                    ),
                  );
                }
                return Column(
                  children: const [
                    Center(child: CircularLoading()),
                  ],
                );
              }),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
