import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? uid;
  final String? pw;
  final String? uname;
  final String? phone;

  User({
    this.uid,
    this.pw,
    this.uname,
    this.phone,
  });

  factory User.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return User(
      uid: data?['uid'],
      pw: data?['pw'],
      uname: data?['uname'],
      phone: data?['phone'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (uid != null) "uid": uid,
      if (pw != null) "pw": pw,
      if (uname != null) "uname": uname,
      if (phone != null) "phone": phone,
    };
  }
}