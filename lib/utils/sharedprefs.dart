import 'package:app/profile/controller/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

// SharedPreferences Keys
  static const String keyUsername = "userName";
  static const String keyIsCompletedProfile = "isCompletedProfile";
  static const String keyIsGuest = "isGuest";
  static const String keyUserRole = "userRole";

  init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  String get userName => _sharedPrefs!.getString(keyUsername) ?? "";
  String get userRole => _sharedPrefs!.getString(keyUserRole) ?? kVolunteer;
  bool get isCompletedProfile =>
      _sharedPrefs!.getBool(keyIsCompletedProfile) ?? false;
  bool get isGuest => _sharedPrefs!.getBool(keyIsGuest) ?? false;
  set userName(String value) {
    _sharedPrefs!.setString(keyUsername, value);
  }

  set isCompletedProfile(bool value) {
    _sharedPrefs!.setBool(keyIsCompletedProfile, value);
  }

  set userRole(String value) {
    _sharedPrefs!.setString(keyUserRole, value);
  }

  set isGuest(bool value) {
    _sharedPrefs!.setBool(keyIsGuest, value);
  }

  static void clearData() {
    _sharedPrefs!.clear();
  }
}

final sharedPrefs = SharedPrefs();
