import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpaceSettingScreen extends StatelessWidget {
  const SpaceSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 세부 설정',
        back: true,
        action: [],
      ),
      body: SingleChildScrollView( // 2. SingleChildScrollView 추가
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // 탭 이벤트가 발생했을 때 실행할 코드를 여기에 작성합니다.
                // 예를 들어, 다른 화면으로 이동하는 등의 동작을 수행할 수 있습니다.
                print('컨테이너가 탭되었습니다!');
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 30,),
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xffe9ecef)), // 위쪽 테두리
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '예산 세부 설정',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // 탭 이벤트가 발생했을 때 실행할 코드를 여기에 작성합니다.
                // 예를 들어, 다른 화면으로 이동하는 등의 동작을 수행할 수 있습니다.
                print('컨테이너가 탭되었습니다!');
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 30,),
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xffe9ecef)), // 위쪽 테두리
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '세부 예산 카테고리 설정',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 30,),
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xffe9ecef)), // 위쪽 테두리
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '참여 승인 기능',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  MyToggle(),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 30,),
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xffe9ecef)), // 위쪽 테두리
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '스페이스 검색 공개',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  MyToggle(),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // 탭 이벤트가 발생했을 때 실행할 코드를 여기에 작성합니다.
                // 예를 들어, 다른 화면으로 이동하는 등의 동작을 수행할 수 있습니다.
                print('컨테이너가 탭되었습니다!');
              },
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 30,),
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xffe9ecef)), // 위쪽 테두리
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '공지사항 작성하기',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              color: Color(0xffe9ecef),
            ),
            // 다른 알림 위젯들 추가
          ],
        ),
      ),
    );
  }
}


class MyToggle extends StatefulWidget {
  @override
  _MyToggleState createState() => _MyToggleState();
}

class _MyToggleState extends State<MyToggle> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: _switchValue,
      onChanged: (value) {
        setState(() {
          _switchValue = value;
        });
      },
    );
  }
}