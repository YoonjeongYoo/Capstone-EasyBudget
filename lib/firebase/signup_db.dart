import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/firebase_options.dart';
import '../firebase/object_db.dart';

Future<void> signUp(String uid, String pw, String uname, String phone) async {
  final db = FirebaseFirestore.instance;

  final user = db.collection('User');
  print('Adding user data...');
  try {
    final data1 = <String, dynamic>{
      'uid': uid,
      'pw': pw,
      'uname': uname,
      'phone': phone,
      'entered': [{'sid': "", 'auth': "",}],
    };
    await user.add(data1);
    print('Data updated!');
  } catch (e) {
    print(e);
  } finally {
    await db
        .collection("User")
        .where("uid", isEqualTo: uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        //print(element.id);
        var docid = element.id;
        print('uid: $uid is in $docid');
      }
    });
  }
}
