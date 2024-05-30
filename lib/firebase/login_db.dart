import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 임포트 추가
import '../firebase/object_db.dart';
import 'package:flutter/material.dart';

// SharedPreferences에 유저 ID를 저장하는 함수
Future<void> saveUserID(String uid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('uid', uid);
}

// SharedPreferences에서 유저 ID를 가져오는 함수
Future<String?> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('uid');
}

Future<String?> searchUser() async {
  print("searching user...");
  final db = FirebaseFirestore.instance;
  late String res = '';
  late String docid = '';
  try {
    await getUserId().then((value) {
      res = value.toString();
    });

    await db.collection("User")
        .where("uid", isEqualTo: res)
        .get()
        .then((value) {
      for (var element in value.docs) {
        //print(element.id);
        docid = element.id;
      }
    });
  } catch (e) {
    print(e);
  } finally {
    print('successfully finished request!');
  }
  return docid;
}

Future<String?> searchSpace() async {
  print("searching space...");
  final db = FirebaseFirestore.instance;
  late String res = '';
  late String docid = '';
  try {
    await db.collection("Space")
        .where("sid", isEqualTo: '11bb')
        .get()
        .then((value) {
      for (var element in value.docs) {
        //print(element.id);
        docid = element.id;
      }
    });
  } catch (e) {
    print(e);
  } finally {
    print('successfully searched space: $docid!');
  }
  return docid;
}

Future<String?> searchData() async {
  print("searching data...");
  final db = FirebaseFirestore.instance;
  late String res = '';
  late String docid = '';
  try {
    await searchSpace().then((value) {
      res = value.toString();
    });

    await db.collection("Space")
        .doc(res)
        .collection('Category')
        .get()
        .then((value) {
      for (var element in value.docs) {
        print(element.id);
      }
    });
  } catch (e) {
    print(e);
  } finally {
    print('successfully searched data!');
  }
  return docid;
}

Future<String?> checkUserId(String uid) async {
  print("checking data...");

  final db = FirebaseFirestore.instance;
  late String docid = '';

  try {
    await db.collection("User")
        .where("uid", isEqualTo: uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        //print(element.id);
        docid = element.id;
      }
    });
  } catch (e) {
    print(e);
  } finally {
    if (docid == '') {
      print('finishing request failed!');
      print('docid is $docid.');
    } else {
      print('successfully finished request!');
    }
  }
  return docid;
}

Future<String?> getCateName() async {
  final db = FirebaseFirestore.instance;
  String? cname;
  print("Fetching cname data...");

  try {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await db
        .collection('Space')
        .doc(await searchSpace())
        .collection('Category')
        .doc('categories')
        .get();

    if (docSnapshot.exists) {
      List<dynamic>? cnameList = docSnapshot.data()?['cname'];
      if (cnameList != null && cnameList.isNotEmpty) {
        //print('cname List:');
        for (cname in cnameList) {
          //print(cname);
          if(cname=='event') {break;}
        }
      } else {
        print('cname field is empty or does not exist.');
      }
    } else {
      print('Document does not exist.');
    }
  } catch (e) {
    print('Error fetching cname data: $e');
  } finally {
    print('Finished fetching cname data.');
  }

  return cname;
}

// 로그인 검증 함수 추가
Future<bool> validateLogin(String uid, String password) async {
  final db = FirebaseFirestore.instance;
  bool isValid = false;

  try {
    final querySnapshot = await db.collection("User")
        .where("uid", isEqualTo: uid)
        .where("pw", isEqualTo: password)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      isValid = true;
    }
  } catch (e) {
    print("Error validating login: $e");
  }

  return isValid;
}
