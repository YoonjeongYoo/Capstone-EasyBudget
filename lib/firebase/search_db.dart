import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../firebase/object_db.dart';
import '../firebase/login_db.dart';
import 'package:flutter/material.dart';

Future<String> searchData() async {
  print("searching data...");
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

Future<String?> checkData(String uid) async {
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

Future<bool> verifyLoginCredentials(String userId, String password) async {
  final db = FirebaseFirestore.instance;
  bool loginSuccess = false;

  try {
    final querySnapshot = await db.collection("User")
        .where("uid", isEqualTo: userId)
        .where("pw", isEqualTo: password)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // 로그인 성공
      loginSuccess = true;
      print('로그인 성공');
      for (var doc in querySnapshot.docs) {
        print('Document ID: ${doc.id}');
        print('Document Data: ${doc.data()}');
      }
    } else {
      // 로그인 실패
      print('로그인 실패: 아이디 또는 비밀번호가 올바르지 않습니다. $password');
    }
  } catch (e) {
    print('로그인 중 오류 발생: $e');
  }

  return loginSuccess;
}

