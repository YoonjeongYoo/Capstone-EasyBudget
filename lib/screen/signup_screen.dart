import 'package:flutter/material.dart';
import 'package:easybudget/constant/color.dart';
import 'package:easybudget/firebase/search_db.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';

import '../firebase/signup_db.dart';
import 'login_screen.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '회원가입',
        back: true,
        action: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(
              'asset/img/EB_logo.png',
              height: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(child: SigninForm()),
    );
  }
}

class SigninForm extends StatefulWidget {
  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _PhonenumController = TextEditingController();

  bool _isIdChecked = false;
  bool _isFormValid = false;

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _showSignupCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('가입이 완료되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 닫기 버튼 클릭 시 다이얼로그 닫기
                Navigator.pop(context); // 회원가입 화면 닫기
              },
              child: Text('확인'),
            ),
          ],
        );
      },
    );
  }

  void _checkId() async {
    // 여기에 아이디 중복 확인 로직을 넣으세요.
    String? idCheck;
    try {
      idCheck = await checkUserId(_idController.text);
    } catch (e) {
      print(e);
    } finally {
      if (idCheck! == '') {
        setState(() {
          _isIdChecked = true;
        });
        _showDialog('중복확인 완료');
      } else if (idCheck != '') {
        setState(() {
          _isIdChecked = false;
        });
        _showDialog('중복된 아이디입니다!');
      }
    }
  }

  void _validateForm() {
    final id = _idController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final name = _nameController.text;
    final phoneNum = _PhonenumController.text;

    setState(() {
      _isFormValid = id.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          name.isNotEmpty &&
          phoneNum.isNotEmpty &&
          _isIdChecked &&
          password == confirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: '아이디',
                    suffixIcon: _isIdChecked
                        ? Icon(Icons.check, color: Colors.green)
                        : null,
                  ),
                  onChanged: (_) => _validateForm(),
                ),
              ),
              SizedBox(width: 8),
              OutlinedButton(
                onPressed: _checkId,
                child: Text('중복확인'),
                style: OutlinedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: blueColor,
                  side: BorderSide(color: blueColor),
                  textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSansKR'),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // 높이를 5씩 늘림
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: '비밀번호'),
            obscureText: true,
            onChanged: (_) => _validateForm(),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: '비밀번호 확인'),
            obscureText: true,
            onChanged: (_) => _validateForm(),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: '이름'),
            onChanged: (_) => _validateForm(),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _PhonenumController,
            decoration: InputDecoration(labelText: '휴대폰 번호'),
            onChanged: (_) => _validateForm(),
          ),
          SizedBox(height: 100),
          ElevatedButton(
            onPressed: _isFormValid
                ? () {
              try {
                signUp(_idController.text, _passwordController.text,
                    _nameController.text, _PhonenumController.text);
              } catch (e) {
                print(e);
              } finally {
                print('successfully signed up');
              }
              _showSignupCompleteDialog();
            }
                : null,
            child: Text('가입하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              foregroundColor: primaryColor,
              textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansKR'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
              ),
              padding: EdgeInsets.symmetric(vertical: 15), // 높이를 5씩 늘림
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _PhonenumController.dispose();
    super.dispose();
  }
}