import 'package:drift/drift.dart';
import 'package:easybudget/firebase/login_db.dart';
import 'package:easybudget/firebase/search_db.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createCategory(String uid, String cname) async {
  final db = FirebaseFirestore.instance;
  final space = db.collection('Space');
  String? sid = await getSpaceId();

  print('creating new category...');

  try {
    // Space 문서 ID를 검색
    String? spaceId = await searchSpace(uid, sid!);
    if (spaceId != null) {
      // 새로운 카테고리 데이터를 설정
      final data1 = <String, dynamic>{
        'cname': [cname], // 초기 카테고리 목록에 cname을 추가
      };
      // 카테고리 문서 생성
      await space.doc(spaceId).collection('Category').doc('categories').set(data1);
    } else {
      print('Space ID not found.');
    }
  } catch (e) {
    print('Error occurred while creating category: $e');
  } finally {
    print('Data updated!');
  }
}

Future<void> appendCategory(String uid, String cname) async {
  final db = FirebaseFirestore.instance;
  final space = db.collection('Space');
  String? sid = await getSpaceId();

  print('adding new category item...');

  try {
    // Space 문서 ID를 검색
    String? spaceId = await searchSpace(uid, sid!);
    if (spaceId != null) {
      // 기존 카테고리 목록에 새로운 카테고리 항목 추가
      await space.doc(spaceId).collection('Category')
          .doc('categories').update({
        "cname": FieldValue.arrayUnion([cname]),
      });
    } else {
      print('Space ID not found.');
    }
  } catch (e) {
    print('Error occurred while adding category item: $e');
  } finally {
    print('Data updated!');
  }
}
