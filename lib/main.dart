import 'package:easybudget/constant/color.dart';
import 'package:easybudget/screen/logo_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easybudget/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:easybudget/screen/join_space_screen.dart';
import 'package:easybudget/screen/auth_test_screen.dart';
// import 'package:easybudget/screen/create_space_screen.dart';
// import 'package:easybudget/screen/create_space_testscreen.dart';
// import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 위젯 바인딩 초기화
  await initializeDateFormatting(); // 날짜 형식 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Firebase 초기화

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'NotoSansKR',
        textTheme: TextTheme(
          labelMedium: TextStyle(
            color: blueColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: blueColor), // 포커스됐을 때의 테두리 색상 지정
          ),
          // 포커스 되었을 때와 되지 않았을 때의 텍스트 색상 설정
          labelStyle: TextStyle(color: Colors.grey), // 포커스됐을 때의 텍스트 색상 지정
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
      //home: TabView(),
      //home: LogoScreen(),
      home: LogoScreen(),
      //home: SpaceManagementScreen(),
       // home: JoinSpaceScreen(),
      //  home: CreateSpaceWidget(),
    ),
  );
}