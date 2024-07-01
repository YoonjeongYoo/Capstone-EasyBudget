import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/search_db.dart';

Future<void> joinSpace(String uid, String sname) async {
  final currentUserid = uid; // 현재 로그인된 사용자 아이디
  String? udocid = '';

  await FirebaseFirestore.instance
      .collection('User')
      .where('uid', isEqualTo: currentUserid)
      .get().then((value) {
    for(var element in value.docs) {
      udocid = element.id;
    }
  }); // 현재 사용자의 문서 아이디 검색

  String? sdocid = '';
  await FirebaseFirestore.instance
      .collection('Space')
      .where('sname', isEqualTo: sname)
      .get().then((value) async {
    for(var element in value.docs) {
      sdocid = element.id;
      print("Space Document ID: $sdocid");
    }
  }); // 사용자가 선택한 스페이스의 문서 아이디 검색
  final sid = await getSid(sdocid!);
  print("Space ID: $sid");

  // 'User' 컬렉션의 'entered' 필드에 새로 참가한 space의 'sid' 값을 추가
  await FirebaseFirestore.instance
      .collection('User')
      .doc(udocid)
      .update({
    'entered': FieldValue.arrayUnion([sid])
  })
      .then((_) {
    print("Space SID successfully added to entered array!");
  })
      .catchError((error) {
    print("Failed to add Space SID to entered array: $error");
  });

  // 'Space' 문서의 'Member' 서브 컬렉션에 사용자 정보 추가
  final data1 = <String, dynamic> {
    'uid': currentUserid,
    'authority': 2,
  }; // 현재 사용자의 아이디, 권한

  await FirebaseFirestore.instance
      .collection('Space')
      .doc(sdocid)
      .collection('Member')
      .add(data1) // data1을 스페이스의 member 서브 컬렉션에 저장
      .then((_) {
    print("User successfully added to Space Member collection!");
  })
      .catchError((error) {
    print("Failed to add user to Space Member collection: $error");
  });
}