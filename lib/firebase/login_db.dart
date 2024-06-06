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