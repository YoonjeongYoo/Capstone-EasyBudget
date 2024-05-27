import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/firebase_options.dart';
import '../firebase/object_db.dart';
import '../firebase/login_db.dart';

Future<void> searchData() async {
  print("searching data...");
  final db = FirebaseFirestore.instance;
  db.collection("User")
    .where("uid", isEqualTo: getUserId().toString())
    .get()
    .then((value) {
      for (var element in value.docs) {
        print(element.id);
      }
  });
}