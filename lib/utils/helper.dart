import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  static Future<void> openURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}

String getFormatedDate(Timestamp timestamp) {
  var dateTime =
      DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
  var formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  return formattedDate;
}
