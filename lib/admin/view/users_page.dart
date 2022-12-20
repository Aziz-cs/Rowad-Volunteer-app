import 'package:app/admin/view/widgets/user_item.dart';
import 'package:app/profile/model/volunteer.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/circular_loading.dart';
import 'package:app/widgets/menu_drawer.dart';
import 'package:app/widgets/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});
  var searchController = TextEditingController();
  var searchText = ''.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        backgroundColor: kGreenColor,
        title: const Text('الاعضاء والصلاحيات'),
        centerTitle: true,
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(15),
        //   ),
        // ),
      ),
      body: Column(
        children: [
          TextField(
            cursorColor: kGreenColor,
            textDirection: TextDirection.ltr,
            style: const TextStyle(color: Colors.black87),
            controller: searchController,
            decoration: InputDecoration(
              hintTextDirection: TextDirection.ltr,
              hintText: 'Seach by Email Address',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey.shade400,
                ),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black26,
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
            onChanged: (value) {
              searchText.value = value;
            },
          ),
          Expanded(
            child: Obx(() => StreamBuilder<QuerySnapshot>(
                  stream: searchText.value.isEmpty ||
                          !GetUtils.isEmail(searchText.value.trim())
                      ? FirebaseFirestore.instance
                          .collection('users')
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: searchText.value.trim())
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      List<Volunteer> volunteersList = [];
                      var resultDocs = snapshot.data!.docs;
                      resultDocs.forEach((element) {
                        Volunteer volunteer = Volunteer.fromDB(
                            element.data() as Map<String, dynamic>, element.id);
                        volunteersList.add(volunteer);
                      });
                      return ListView(
                        children: volunteersList
                            .map((volunteer) => UserItem(volunteer: volunteer))
                            .toList(),
                      );
                    }
                    return const CircularLoading();
                  },
                )),
          ),
        ],
      ),
    );
  }
}
