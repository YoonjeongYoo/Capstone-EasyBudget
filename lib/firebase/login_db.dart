import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserId(String uid) async {
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

Future<void> saveSpaceId(String sid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('sid', sid);
}

Future<String?> getSpaceId() async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getString('sid') != null) {
    return prefs.getString('sid');
  } else {
    return '-1';
  }
}

Future<void> removeUserId() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('uid');
}

Future<void> removeSpaceId() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('sid');
}

// 추가된 메서드
Future<String?> getUserInherenceId() async {
  final uid = await getUserId();
  if (uid == null || uid == '-1') {
    return null;
  }

  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('User')
        .where('uid', isEqualTo: uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // 고유 문서 ID를 반환
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching user document ID: $e');
    return null;
  }
}

// 추가된 메서드
Future<String?> getSpaceInherenceId(String spaceName) async {
  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Space')
        .where('sname', isEqualTo: spaceName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // 고유 문서 ID를 반환
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching space document ID: $e');
    return null;
  }
}
// change password
/*
may be 'Future<void>' method which is no need to returning value
 */
Future<String?> changePassword(String pw) async {
  String? udocid;
  try {
    final uid = await getUserId(); // get user id from instance
    final db = await FirebaseFirestore.instance.collection('User');
    await db.where('uid', isEqualTo: uid)
            .get()
            .then((value) {
              for (var element in value.docs) {
                udocid = element.id;
              }
            }); // get user's document id from db
    if (udocid!.isEmpty) {
      print('Document could not found!'); // error check
    } else {
      await db.doc(udocid!).update({'pw': pw}); // set new password as method input pw
      print(pw);
    }
  } catch (e) {
    print('Error occurred: $e'); // error log
  } finally {
    print('Password Successfully Changed!');
  }
  return pw;
}