import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase/login_db.dart';

class MypageScreen extends StatelessWidget {
  final String userId; // userId를 받기 위한 변수 추가

  const MypageScreen({Key? key, required this.userId}) : super(key: key);

  Future<String> getUserName(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('User')
        .where('uid', isEqualTo: userId)
        .limit(1)
        .get()
        .then((querySnapshot) => querySnapshot.docs.first);
    return userDoc['uname'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarLayout(
        title: '계정 관리',
        back: true,
        action: [],
      ),
      body: Container(
        color: primaryColor, // 배경색 변경
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('asset/img/profile_img_2.png'),
            ),
            SizedBox(height: 10),
            FutureBuilder<String>(
              future: getUserName(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (!snapshot.hasData) {
                  return Text("사용자 이름을 가져오지 못했습니다.");
                }
                return Text(
                  snapshot.data!,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // 프로필 사진 변경 이벤트
              },
              child: _buildMenuItem(context, '프로필 사진 변경'),
            ),
            GestureDetector(
              onTap: () {
                // 사용자 이름 변경 이벤트
              },
              child: _buildMenuItem(context, '사용자 이름 변경'),
            ),
            GestureDetector(
              onTap: () async {
                // 비밀번호 변경 이벤트
                await changePassword('12345'); // need to make another screen
              },
              child: _buildMenuItem(context, '비밀번호 변경'),
            ),
            GestureDetector(
              onTap: () {
                // 로그아웃 이벤트
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(), // 수정
                  ),
                );
              },
              child: _buildMenuItem(context, '로그아웃'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white, // 메뉴 아이템 배경색 변경
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
