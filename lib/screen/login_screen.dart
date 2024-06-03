import 'package:easybudget/constant/color.dart';
import 'package:easybudget/firebase/auth_db.dart';
import 'package:easybudget/firebase/category_db.dart';
import 'package:easybudget/firebase/signup_db.dart';
import 'package:easybudget/screen/search_ID.dart';
import 'package:easybudget/screen/signup_screen.dart';
import 'package:easybudget/screen/space_management_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:easybudget/screen/search_password.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 임포트 추가
import '../firebase/search_db.dart';
import '../firebase/login_db.dart'; // 로그인 검증 함수가 있는 파일 임포트

final userIdController = TextEditingController();
final passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'asset/img/EB_logo.png',
              height: 80,
            ),
            SizedBox(
              height: 50,
            ),
            // Username 입력 필드
            TextFormField(
              controller: userIdController,
              decoration: InputDecoration(
                labelText: '아이디 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            // Password 입력 필드
            TextFormField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: '비밀번호 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FindIdScreen(),
                        ),
                      );
                    } catch (e) {
                      print("Error: $e");
                    }
                  },
                  child: Text(
                    '아이디 찾기',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
                Text(' | '),
                TextButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PasswordResetScreen(),
                      ),
                    );
                  },
                  child: Text(
                    '비밀번호 찾기',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            // 로그인 버튼
            ElevatedButton(
              onPressed: () async {
                final id = userIdController.text.trim();
                final password = passwordController.text.trim();
                print(id);

                if (id.isEmpty || password.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('아이디와 비밀번호를 모두 입력해주세요.'),
                        actions: [
                          TextButton(
                            child: Text('닫기'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                  return;
                }

                // 로그인 검증 및 사용자 정보 가져오기
                bool isValid = await validateLogin(id, password); // validateLogin 함수 호출

                if (isValid) {
                  await loginUser(id, password); // loginUser 함수 호출
                  await saveUserId(id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpaceManagementScreen(userId: id), // 수정
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('아이디 또는 비밀번호가 올바르지 않습니다!'),
                        actions: [
                          TextButton(
                            child: Text('닫기'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                foregroundColor: primaryColor,
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansKR',
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                ),
                padding: EdgeInsets.symmetric(vertical: 15), // 높이를 5씩 늘림
              ),
              child: Text(
                '로그인',
              ),
            ),
            SizedBox(height: 5),
            OutlinedButton(
              onPressed: () {
                // 회원가입 버튼을 눌렀을 때의 동작 추가
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SigninScreen(), // 수정
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: blueColor,
                side: BorderSide(color: blueColor),
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansKR',
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                ),
                padding: EdgeInsets.symmetric(vertical: 15), // 높이를 5씩 늘림
              ),
              child: Text(
                '회원가입',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
