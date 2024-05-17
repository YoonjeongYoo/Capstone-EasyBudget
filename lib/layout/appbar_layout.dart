import 'package:easybudget/constant/color.dart';
import 'package:flutter/material.dart';

class AppbarLayout extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> action;
  final String title;

  const AppbarLayout({
    required this.action,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true, // 뒤로가기 버튼 자동 사용
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'NotoSansKR',
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: primaryColor,
      centerTitle: true,
      actions: action,
      /*leading: IconButton(
          onPressed: (){},
          icon: Icon(CupertinoIcons.back),
        )*/
    );
  }
}