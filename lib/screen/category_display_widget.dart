import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryDisplayWidget extends StatefulWidget {
  @override
  _CategoryDisplayWidgetState createState() => _CategoryDisplayWidgetState();
}

class _CategoryDisplayWidgetState extends State<CategoryDisplayWidget> {
  @override
  void initState() {
    super.initState();
    fetchCategoryData();
  }

  Future<void> fetchCategoryData() async {
    try {
      // Firestore 인스턴스를 가져옵니다.
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Space 컬렉션 안의 Category 컬렉션을 참조합니다.
      CollectionReference categoryCollection = firestore.collection('Space').doc('KBpkiTfmpsg3ZI5iSpyY').collection('Category');

      // 데이터를 가져옵니다.
      QuerySnapshot querySnapshot = await categoryCollection.get();
      for (var doc in querySnapshot.docs) {
        // cname 필드의 0번째 값을 가져와 콘솔에 출력합니다.
        String cname = doc['cname'];
        if (cname.isNotEmpty) {
          print('cname의 0번째 값: ${cname[0]}');
        }
      }
    } catch (e) {
      print('오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Category Display'),
      ),
      body: Center(
        child: Text('콘솔을 확인하세요!'),
      ),
    );
  }
}
