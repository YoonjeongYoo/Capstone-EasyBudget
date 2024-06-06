import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalManagementScreen extends StatelessWidget {
  final String spaceName;

  const ApprovalManagementScreen({super.key, required this.spaceName});

  Future<List<Map<String, String>>> _fetchRequests() async {
    // Space 컬렉션에서 spaceName과 일치하는 문서를 쿼리합니다.
    final spaceQuerySnapshot = await FirebaseFirestore.instance
        .collection('Space')
        .where('sname', isEqualTo: spaceName)
        .get();

    if (spaceQuerySnapshot.docs.isEmpty) {
      return [];
    }

    final spaceDocId = spaceQuerySnapshot.docs.first.id;

    final memberCollection = FirebaseFirestore.instance
        .collection('Space')
        .doc(spaceDocId)
        .collection('Member');

    final memberSnapshot = await memberCollection.get();

    List<Map<String, String>> requests = [];

    for (var memberDoc in memberSnapshot.docs) {
      final uid = memberDoc['uid'];
      final userDoc = await FirebaseFirestore.instance
          .collection('User')
          .where('uid', isEqualTo: uid)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final uname = userDoc.docs.first['uname'];
        requests.add({'name': uname, 'uid': uid});
      }
    }
    return requests;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 참여 요청',
        action: [],
        back: true,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _fetchRequests(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('참여 요청이 없습니다.'));
          } else {
            final requests = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: requests.map((request) {
                  return _RequestContainer(
                    name: request['name']!,
                    uid: request['uid']!,
                    profile: 'asset/img/profile_img_2.png',
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

class _RequestContainer extends StatelessWidget {
  final String name;
  final String uid;
  final String profile;
  const _RequestContainer({super.key, required this.name, required this.uid, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xffe9ecef))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(profile),
              ),
              SizedBox(width: 20),
              Text(
                name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansKR',
                ),
              ),
              Text(
                '($uid)',
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  foregroundColor: primaryColor,
                  textStyle: TextStyle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  '승인',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: primaryColor,
                  textStyle: TextStyle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  '거절',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
