import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constant/color.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _isSendCodeButtonEnabled = false;
  bool _isNextButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_formatPhoneNumber);
    _phoneController.addListener(_updateSendCodeButtonState);
    _codeController.addListener(_updateNextButtonState);
  }

  void _formatPhoneNumber() {
    String text = _phoneController.text;
    text = text.replaceAll(RegExp(r'\D'), ''); // Remove all non-digit characters

    if (text.length > 3 && text.length <= 7) {
      text = '${text.substring(0, 3)}-${text.substring(3)}';
    } else if (text.length > 7) {
      text = '${text.substring(0, 3)}-${text.substring(3, 7)}-${text.substring(7)}';
    }

    _phoneController.value = _phoneController.value.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _updateSendCodeButtonState() {
    setState(() {
      _isSendCodeButtonEnabled = _phoneController.text.isNotEmpty;
    });
  }

  void _updateNextButtonState() {
    setState(() {
      _isNextButtonEnabled = _codeController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _phoneController.removeListener(_formatPhoneNumber);
    _phoneController.removeListener(_updateSendCodeButtonState);
    _codeController.removeListener(_updateNextButtonState);
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '비밀번호 찾기',
        action: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                  hintText: '아이디를 입력해 주세요.',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: '이름',
                  border: OutlineInputBorder(),
                  hintText: '이름을 입력해 주세요.',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: '전화번호',
                  border: OutlineInputBorder(),
                  hintText: '전화번호를 입력해 주세요.',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: '인증코드',
                  border: OutlineInputBorder(),
                  hintText: '인증코드를 입력해 주세요.',
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isSendCodeButtonEnabled
                      ? () {
                    // 인증번호 전송 로직 추가
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: blueColor,
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSansKR',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text('인증번호 전송'),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isNextButtonEnabled
                      ? () {
                    // 다음 버튼 로직 추가
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
                    foregroundColor: primaryColor,
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSansKR',
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text('다음'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
