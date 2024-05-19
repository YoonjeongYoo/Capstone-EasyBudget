import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/bottom_navigationbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/screen/mypage_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SpaceManagementScreen extends StatelessWidget {
  const SpaceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 관리',
        action: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MypageScreen(), // 수정
                  ),
                );
              },
              icon: Icon(CupertinoIcons.person_crop_circle_fill),
              iconSize: 30,
            ),
          ),
        ],
      ),
      body: Container(
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TabView(), // 수정
              ),
            );
          },
          child: Text('입장하기'),
        ),
      ),
    );
  }
}
