import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

final preferences = SharedPreference();

class SharedPreference {
  static SharedPreferences? _preferences;

  init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static const appDeviceType = "App-Device-Type";
  static const appStoreVersion = "App-Store-Version";
  static const appDeviceModel = "App-Device-Model";
  static const appOsVersion = "App-Os-Version";
  static const appStoreBuildNumber = "App-Store-Build-Number";
  static const authToken = "Auth-Token";
  static const homeScreenTutorialShown = "Home-Screen-Tutorial-Shown";

  static const IS_LOG_IN = "IS_LOG_IN";
  static const USER_MODEL = "USER_MODEL";
  static const HAPTIC_FEEDBACK_ENABLED = "HAPTIC_FEEDBACK_ENABLED";

  static const APP_DEVICE_TYPE = "App-Device-Type";
  static const APP_STORE_VERSION = "App-Store-Version";
  static const APP_DEVICE_MODEL = "App-Device-Model";
  static const APP_OS_VERSION = "App-Os-Version";
  static const APP_STORE_BUILD_NUMBER = "App-Store-Build-Number";
  ///
  static const LocationTrack = "Location-Track";

  void clearUserItem() async {
    _preferences?.clear();
    _preferences = null;
    await init();

  }

  Future<bool?> putString(String key, String value) async {
    if (_preferences == null) {
      return null;
    } else {
      return _preferences!.setString(key, value);
    }
  }

  String? getString(String key, {String defValue = ""}) {
    return _preferences == null
        ? defValue
        : _preferences!.getString(key) ?? defValue;
  }

  Future<bool?> putList(String key, List<String> value) async {
    if (_preferences == null) {
      return null;
    } else {
      return _preferences!.setStringList(key, value);
    }
  }

  List<String>? getList(String key, {List<String> defValue = const []}) {
    return _preferences == null
        ? defValue
        : _preferences!.getStringList(key) ?? defValue;
  }

  Future<bool?> putInt(String key, int value) async {
    if (_preferences == null) {
      return null;
    } else {
      return _preferences!.setInt(key, value);
    }
  }

  int? getInt(String key, {int defValue = 0}) {
    return _preferences == null
        ? defValue
        : _preferences!.getInt(key) ?? defValue;
  }

  bool? getBool(String key, {bool defValue = false}) {
    return _preferences == null
        ? defValue
        : _preferences!.getBool(key) ?? defValue;
  }

  Future<bool?> putBool(String key, bool value) async {
    if (_preferences == null) {
      return null;
    } else {
      return _preferences!.setBool(key, value);
    }
  }
}
