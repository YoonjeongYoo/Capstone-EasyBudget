import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserID(String uid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', uid);
}

Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getString('uid') != null) {
    return prefs.getString('uid');
  } else {
    return '-1';
  }
}

Future<void> removeUserId() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('uid');
}