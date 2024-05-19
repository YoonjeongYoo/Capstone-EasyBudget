import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '회원가입',
        action: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16
            ),
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

  bool _isIdChecked = false;

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

  void _checkId() {
    // 여기에 아이디 중복 확인 로직을 넣으세요.
    setState(() {
      _isIdChecked = true;
    });
    _showDialog('중복확인 완료');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40
      ),
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
                      fontFamily: 'NotoSansKR'
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
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
          ),
          SizedBox(height: 20),
          TextField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: '비밀번호 확인'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: '이름'),
          ),
          SizedBox(height: 100),
          ElevatedButton(
            onPressed: _showSignupCompleteDialog,
            child: Text('가입하기'),
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              foregroundColor: primaryColor,
              textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'NotoSansKR'
              ),
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
    super.dispose();
  }
}
