import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String loggedInKey = 'LOGGEDINKEY';
  static String userNameKey = 'USERNAMEKEY';
  static String userEmailkey = 'USEREMAILKEY';

  static Future<bool> saveUserLoggedinStatus(bool isUserLoggedin) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(loggedInKey, isUserLoggedin);
  }

  static Future<bool> saveUsername(String username) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, username);
  }

  static Future<bool> saveUserEmail(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailkey, userEmail);
  }

  static Future<bool?> getUserLoggedinStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(loggedInKey);
  }

  static Future<String?> getUserName() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailkey);
  }
}
