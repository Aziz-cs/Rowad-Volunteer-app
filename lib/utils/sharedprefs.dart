import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

// SharedPreferences Keys
  static const String keyUsername = "userName";
  static const String keyIsStaffTeam = "isStaffTeam";
  static const String keyChildName = "childName";
  static const String keyChildYear = "childYear";
  static const String keyChildMonth = "childMonth";
  static const String keyChildDay = "childDay";
  static const String keyChildWeight = "childWeight";
  static const String keyIsChildMale = "isChildMale";
  // static const String keyIsHaveChild = "isHaveChild";
  static const String keyDateOfLastWhenWakeUp = "dateOfLastWhenWakeUp";
  static const String keySelectedWakeUpTime = "selectedWakeUpTime";
  static const String keyIsFirstTimeSchedule = "isFirstTimeSchedule";
  static const String keyAnswersSaved = "answersSaved";
  static const String keyAnswersSent = "answersSent";
  static const String keyIsPremium = "isPremium";
  static const String keyMotherPhoneNo = "motherPhoneNo";

  static const String keyIsInstagramShown = "isInstagramShown";

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get userName => _sharedPrefs!.getString(keyUsername) ?? "";

  set userName(String value) {
    _sharedPrefs!.setString(keyUsername, value);
  }

  static void clearData() {
    _sharedPrefs!.clear();
  }
}

final sharedPrefs = SharedPrefs();
