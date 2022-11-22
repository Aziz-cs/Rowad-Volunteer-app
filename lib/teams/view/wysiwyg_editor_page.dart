// import 'dart:convert';

// import 'package:app/teams/controller/team_controller.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as qu;
// import 'package:get/get.dart';
// import '../../widgets/simple_btn.dart';

// import '../../utils/constants.dart';

// class WYSIWYGPage extends StatelessWidget {
//   WYSIWYGPage({Key? key}) : super(key: key);
//   final teamController = Get.put(TeamController());

//   qu.QuillController _controller = qu.QuillController.basic();

//   final teamCategory = '- أختر -'.obs;

//   // late final XFile? pickedImage;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kGreenColor,
//         title: const Text('إضافة فريق تطوعي'),
//         centerTitle: true,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(
//             bottom: Radius.circular(15),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           qu.QuillToolbar.basic(controller: _controller),
//           Directionality(
//             textDirection: TextDirection.rtl,
//             child: Expanded(
//               child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('WYSIWYG')
//                     .doc('agq30w6W4txBLapPNK2q')
//                     .snapshots(),
//                 builder: ((context, snapshot) {
//                   print(snapshot.connectionState.toString());
//                   if (snapshot.connectionState == ConnectionState.active) {
//                     var result = snapshot.data!.data() as Map;
//                     print(result);
//                     var myJSON = jsonDecode(result['name']);

//                     // _controller = qu.QuillController(
//                     //     document: qu.Document.fromJson({'hello': "ddd"}),
//                     //     selection: TextSelection.collapsed(offset: 0));
//                     ;
//                     return qu.QuillEditor.basic(
//                       controller: _controller,
//                       readOnly: false, // true for view only mode
//                     );
//                   }

//                   return SizedBox();
//                 }),
//               ),
//             ),
//           ),
//           SimpleButton(
//             label: 'show',
//             onPress: () async {
//               print(_controller.document.toDelta().toJson().toString());
//               var json = jsonEncode(_controller.document.toDelta().toJson());

//               Map<String, dynamic> teamData = {
//                 'JSON': json,
//               };
//               // FirebaseFirestore.instance.collection('WYSIWYG').add('data':'').;
//               FirebaseFirestore.instance.collection('WYSIWYG').add(teamData);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
