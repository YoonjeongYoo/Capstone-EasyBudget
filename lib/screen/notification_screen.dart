import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key); // 1. Key 수정

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '알림',
        action: [],
      ),
      body: SingleChildScrollView( // 2. SingleChildScrollView 추가
        child: Column(
          children: [
            _NotificationContainer_name(name: '이하빈',),
            _NotificationContainer_name(name: '김효영',),
            _NotificationContainer_category(category: '식비',),
            _NotificationContainer_name(name: '이은수',),
            Divider(
              color: Colors.black26,
            ),
            // 다른 알림 위젯들 추가
          ],
        ),
      ),
    );
  }
}

class _NotificationContainer_name extends StatelessWidget {
  final String name;

  const _NotificationContainer_name({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
        horizontal: 20
      ),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black26), // 위쪽 테두리
        ),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.envelope_fill, color: blueColor,),
          Text(
            '   "$name"님께서 참여 승인을 요청하였습니다.',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSansKR'
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationContainer_category extends StatelessWidget {
  final String category;

  const _NotificationContainer_category({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
          horizontal: 20
      ),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black26), // 위쪽 테두리
        ),
      ),
      child: Row(
        children: [
          Icon(CupertinoIcons.exclamationmark_triangle_fill, color: Colors.red,),
          Text(
            '   "$category"카테고리의 지출 상한이 10% 남았습니다.',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'NotoSansKR'
            ),
          ),
        ],
      ),
    );
  }
}
