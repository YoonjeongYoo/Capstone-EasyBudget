import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/screen/login_screen.dart';
import 'package:flutter/material.dart';

class MypageScreen extends StatelessWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarLayout(
        title: '계정 관리',
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
              backgroundImage: AssetImage('asset/img/profile_img.jpg'),
            ),
            SizedBox(height: 10),
            Text(
              '유윤정',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'NotoSansKR',
                  fontWeight: FontWeight.w700
              ),
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
              onTap: () {
                // 비밀번호 변경 이벤트
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
