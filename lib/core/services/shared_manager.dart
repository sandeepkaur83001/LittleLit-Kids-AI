import 'package:little_kids_ai/core/common_imports.dart';



class SharedManager {
  static Future<String?> getStringSharePreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<int?> getIntSharePreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  static Future<double?> getDoubleSharePreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  static Future<bool?> getBoolSharePreferences(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> setStringSharePreferences(String key, String? value) async {
    if (value != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await deleteSpecificSharePreference(key);
    }
  }

  static Future<void> setIntSharePreferences(String key, int? value) async {
    if (value != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, value);
    } else {
      await deleteSpecificSharePreference(key);
    }
  }

  static Future<void> setDoubleSharePreferences(String key, double? value) async {
    if (value != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(key, value);
    } else {
      await deleteSpecificSharePreference(key);
    }
  }

  static Future<void> setBoolSharePreferences(String key, bool? value) async {
    if (value != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } else {
      await deleteSpecificSharePreference(key);
    }
  }

  static Future<bool> deleteSpecificSharePreference(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.remove(key);
    return result;
  }

  static Future<bool> deleteAllSharePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = await prefs.clear();

    return result;
  }

  static Future<void> saveAuthData(AuthResponseModel authResponse) async {
    if (authResponse.data?.accessToken != null && authResponse.data!.accessToken!.isNotEmpty) {
      Globals.BearerToken = authResponse.data!.accessToken;
      await setStringSharePreferences(SharedConstants.ACCESS_TOKEN, authResponse.data!.accessToken);
    }
    if (authResponse.data != null) {
      Globals.currentUser = authResponse.data;
      await setStringSharePreferences(
        SharedConstants.USER_DATA,
        jsonEncode(authResponse.data!.toJson()),
      );
    }
  }

  static Future<UserData?> getUserData() async {
    if (Globals.currentUser != null) {
      return Globals.currentUser;
    }
    String? data = await getStringSharePreferences(SharedConstants.USER_DATA);
    if (data != null && data.isNotEmpty) {
      try {
        Globals.currentUser = UserData.fromJson(jsonDecode(data));
        return Globals.currentUser;
      } catch (e) {
        CommonApiClass().normalPrintJson("Error decoding UserData: $e");
      }
    }
    return null;
  }

  static Future<void> clearAuthData() async {
    Globals.BearerToken = null;
    Globals.currentUser = null;
    await deleteSpecificSharePreference(SharedConstants.ACCESS_TOKEN);
    await deleteSpecificSharePreference(SharedConstants.USER_DATA);
    await deleteSpecificSharePreference(SharedConstants.LOGIN_MODEL);
  }

  static Future<bool> getToken() async {
    if (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty) {
      CommonApiClass().normalPrintJson("USER_BEARER_TOKEN  ${Globals.BearerToken}");
      return true;
    } else {
      String? token = await getStringSharePreferences(SharedConstants.ACCESS_TOKEN);
      Globals.BearerToken = token;
      await getUserData();
      CommonApiClass().normalPrintJson("USER_BEARER_TOKEN  ${Globals.BearerToken}");

      return (Globals.BearerToken != null && Globals.BearerToken!.isNotEmpty);
    }
  }
}
