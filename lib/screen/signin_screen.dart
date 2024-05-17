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
      body: Column(
        children: [

        ],
      )
    );
  }
}
