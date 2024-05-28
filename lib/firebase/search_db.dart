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