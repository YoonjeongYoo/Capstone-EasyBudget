import 'package:drift/drift.dart';
import 'package:easybudget/firebase/login_db.dart';
import 'package:easybudget/firebase/search_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createCategory(String cname) async {
  final db = FirebaseFirestore.instance;
  final space = db.collection('Space');
  String? sid = await getSpaceId();

  print('creating new category...');

  try {
    final data1 = <String, dynamic>{
      'cname': [],
    };
    await space.doc(await searchSpace(sid!)).collection('Category').doc('categories').set(data1);
  } catch (e) {
    print('Error occurred while creating category: $e');
  } finally {
    print('Data updated!');
  }
}

Future<void> appendCategory(String cname) async {
  final db = FirebaseFirestore.instance;
  final space = db.collection('Space');
  String? sid = await getSpaceId();

  print('adding new category item...');

  try {
    final data1 = cname;
    await space.doc(await searchSpace(sid!)).collection('Category')
          .doc('categories').update({
        "cname": FieldValue.arrayUnion([data1]),

    });
  } catch (e) {
    print('Error occured while adding category item: $e');
  } finally {
    print('Data updated!');
  }
}