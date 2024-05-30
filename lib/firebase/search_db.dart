import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../firebase/object_db.dart';
import '../firebase/login_db.dart';
import 'package:flutter/material.dart';

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

Future<void> loginUser(String uid, String password) async {
  final db = FirebaseFirestore.instance;

  try {
    // 로그인 검증
    bool isValid = await validateLogin(uid, password);

    if (isValid) {
      print("Login successful for user: $uid");

      // 사용자 문서 조회
      final userQuery = await db.collection("User").where("uid", isEqualTo: uid).get();

      if (userQuery.docs.isNotEmpty) {
        final userDoc = userQuery.docs.first;
        final userData = userDoc.data();
        print("User Data: $userData"); // 디버깅 출력 추가

        if (userData != null) {
          // 사용자가 참여하고 있는 Space ID 목록 조회
          List<dynamic> spaceIds = userData['spaces'];
          print("User spaces: $spaceIds"); // 디버깅 출력 추가

          // Space 문서들 조회
          for (var spaceId in spaceIds) {
            final spaceDoc = await db.collection("Space").doc(spaceId).get();

            if (spaceDoc.exists) {
              final spaceData = spaceDoc.data();
              print("Space ID: $spaceId, Data: $spaceData");
            } else {
              print("Space document with ID $spaceId does not exist.");
            }
          }
        } else {
          print("User data is null.");
        }
      } else {
        print("User document does not exist for userId: $uid"); // 디버깅 출력 추가
      }
    } else {
      print("Invalid login credentials for user: $uid");
    }
  } catch (e) {
    print("Error during login process: $e");
  }
}

// 로그인 검증 함수
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

Future<List<String>> getUserSpaces(String userId) async {
  final db = FirebaseFirestore.instance;
  final userQuery = await db.collection("User").where("uid", isEqualTo: userId).get();

  if (userQuery.docs.isNotEmpty) {
    final userDoc = userQuery.docs.first;
    final userData = userDoc.data();
    print("User Data: $userData"); // 디버깅 출력 추가
    if (userData != null && userData.containsKey('spaces')) {
      return List<String>.from(userData['spaces']);
    }
  } else {
    print("User document does not exist for userId: $userId"); // 디버깅 출력 추가
  }
  return [];
}
