import 'dart:async';

import 'package:easybudget/constant/color.dart';
import 'package:easybudget/screen/login_screen.dart';
import 'package:flutter/material.dart';

import 'space_management_screen.dart';


class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  State<LogoScreen> createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 4),
          () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SpaceManagementScreen()),//LoginScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 50
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('asset/img/EB_logo.png'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
