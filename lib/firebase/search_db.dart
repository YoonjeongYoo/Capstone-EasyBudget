import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/login_db.dart';

Future<String?> searchUser(String uid) async {
  print("searching user...");
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
    print('successfully finished request!');
  }
  return docid;
}

Future<String?> searchSpace(String sid) async {
  print("searching space...");
  final db = FirebaseFirestore.instance;
  //late String res = '';
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
  final sid = await getSpaceId();
  late String res = '';
  late String docid = '';
  try {
    await searchSpace(sid!).then((value) {
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
  final sid = await getSpaceId();
  String? cname;
  print("Fetching cname data...");

  try {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await db
        .collection('Space')
        .doc(await searchSpace(sid!))
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
