import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/firebase/search_db.dart';

Future<String?> findId(String phone) async {
  final db = FirebaseFirestore.instance;
  final coldb = db.collection('User');
  late String docid = '';
  String? identifier = '';

  await coldb.where('phone', isEqualTo: phone).get().then((value) {
    for (var element in value.docs) {
      docid = element.id;
    }
  });

  try {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await coldb
        .doc(docid)
        .get();

    if (docSnapshot.exists) {
      List<dynamic>? uid = docSnapshot.data()?['uid'];
      if (uid != null && uid.isNotEmpty) {
        //print('cname List:');
        for (identifier in uid) {
          print(identifier); // 디버그용 출력문
        }
      } else {
        print('uid field is empty or does not exist.');
      }
    } else {
      print('Document does not exist.');
    }
  } catch (e) {
    print('Error Code: $e');
  } finally {
    print('found id: $identifier');
  }

  return identifier;
}

Future<String?> findPw(String uid, String uname) async {
  final db = FirebaseFirestore.instance;
  final coldb = db.collection('User');
  late String docid = '';
  String? identifier = '';

  await coldb
      .where('uid', isEqualTo: uid)
      .where('uname', isEqualTo: uname)
      .get()
      .then((value) {
    for (var element in value.docs) {
      docid = element.id;
    }
  });

  try {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await coldb
        .doc(docid)
        .get();

    if (docSnapshot.exists) {
      List<dynamic>? password = docSnapshot.data()?['pw'];
      if (password != null && password.isNotEmpty) {
        //print('cname List:');
        for (identifier in password) {
          print(identifier); // 디버그용 출력문
        }
      } else {
        print('pw field is empty or does not exist.');
      }
    } else {
      print('Document does not exist.');
    }
  } catch (e) {
    print('Error Code: $e');
  } finally {
    print('found id: $identifier');
  }

  return identifier;
}