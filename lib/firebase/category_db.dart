import 'package:drift/drift.dart';
import 'package:easybudget/firebase/search_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createCategory(String cname) async {
  final db = FirebaseFirestore.instance;
  final space = db.collection('Space');
  print('creating ne category...');

  try {
    final data1 = <String, dynamic>{
      'cname': [],
    };
    await space.doc(await searchSpace()).collection('Category').doc('categories').set(data1);
    print('Data updated!');
  } catch (e) {
    print(e);
  } finally {
    // await db
    //     .collection("Space")
    //     .doc(await searchSpace())
    //     .collection('Category')
    //     .get()
    //     .then((value) {
    //   for (var element in value.docs) {
    //     //print(element.id);
    //     var docid = element.id;
    //     print('category: $cname is in $docid');
    //   }
    // });
  }
}

Future<void> appendCategory(String cname) async {
  final db = FirebaseFirestore.instance;
  final space = db.collection('Space');
  print('adding new category item...');

  try {
    final data1 = cname;
    await space.doc(await searchSpace()).collection('Category')
        .doc('categories').update({
      "cname": FieldValue.arrayUnion([data1]),
    });
    print('Data updated!');
  } catch (e) {
    print(e);
  } finally {
    // await db
    //     .collection("Space")
    //     .doc(await searchSpace())
    //     .collection('Category')
    //     .get()
    //     .then((value) {
    //   for (var element in value.docs) {
    //     //print(element.id);
    //     var docid = element.id;
    //     print('category: $cname is in $docid');
    //   }
    // });
  }
}