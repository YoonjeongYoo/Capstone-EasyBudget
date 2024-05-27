import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/firebase_options.dart';
import '../firebase/search_db.dart';

Future<void> signUp(String uid, String pw, String uname, String phone) async {
  final db = FirebaseFirestore.instance;

  final user = db.collection('User');

  final data1 = <String, dynamic>{
    'uid': uid,
    'pw': pw,
    'uname': uname,
    'phone': phone
  };
  user.add(data1);
  print('data updated');
}
