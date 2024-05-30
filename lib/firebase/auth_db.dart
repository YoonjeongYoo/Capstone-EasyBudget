import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/search_db.dart';
import '../firebase/login_db.dart';

Future<void> authCheck() async {
  final db = FirebaseFirestore.instance;
  final sid = await getSpaceId();
  final uid = await getUserId();
  String? auth;

  dynamic val = await db.collection('User')
                    .where('uid', isEqualTo: uid)
                    .get();

  print("Fetching cname data...");
//TODO *******************************************************8
  try {
    LinkedHashMap<String, dynamic> data = val['entered'];

    List<dynamic> values = data.values.toList();

    for(int i = 0;i < values.length; i++) {
      list.add()
    }

    if (docSnapshot.exists) {
      List<dynamic>? cnameList = docSnapshot.data()?['cname'];
      if (cnameList != null && cnameList.isNotEmpty) {
        //print('cname List:');
        for (auth in cnameList) {
          //print(cname);
          if(auth=='event') {break;}
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
}