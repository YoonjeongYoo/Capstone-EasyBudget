import 'package:easybudget/constant/color.dart';
import 'package:easybudget/screen/signin_screen.dart';
import 'package:easybudget/screen/space_management_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
              decoration: InputDecoration(
                labelText: '아이디 입력',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            // Password 입력 필드
            TextFormField(
              obscureText: true,
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
                    onPressed: (){},
                    child: Text(
                      '아이디 찾기',
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                ),
                Text(' | '),
                TextButton(
                  onPressed: (){},
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpaceManagementScreen(), // 수정
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                foregroundColor: primaryColor,
                textStyle: TextStyle(

                ),
              ),
              child: Text('로그인'),
            ),
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
                ),
              ),
              child: Text('회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
