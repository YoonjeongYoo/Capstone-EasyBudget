import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/search_db.dart';
import '../firebase/login_db.dart';

Future<int?> authCheck() async {
  final db = FirebaseFirestore.instance;
  final user = db.collection('User');
  final sid = await getSpaceId();
  final uid = await getUserId();
  String? docid;
  int? auth;

  try {
    await user
          .doc(await searchUser(uid!))
          .collection('entered')
          .where('sid', isEqualTo: "11bb") // need to set sid from saveSpaceId
          .get()
          .then((value) {
      for (var element in value.docs) {
        //print(element.id);
          docid = element.id;
      }
    });
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await user
        .doc(await searchUser(uid))
        .collection('entered')
        .doc(docid!)
        .get();

    if (docSnapshot.exists) {
      auth = docSnapshot.data()?['auth'];
      if (auth != null) {
        print('auth: $auth');
        }
      } else {
        print('auth field is empty.');
      }

  } catch (e) {
    print('Error occurred while checking authority: $e');
  } finally {
    print('successfully checked authority');
  }
  return auth;
}