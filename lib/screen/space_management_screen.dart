import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/bottom_navigationbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/screen/create_space_screen.dart';
import 'package:easybudget/screen/join_space_screen.dart';
import 'package:easybudget/screen/mypage_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Flexible(
            //   flex: 8,
            //   child: SingleChildScrollView(
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //       children: [
            //         _SpaceContainer(name: '경기대학교 학생회',),
            //       ],
            //     ),
            //   ),
            // ),
            Flexible(
              flex: 8,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('EnteredSpace').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: snapshot.data!.docs.map((document) {
                        return _SpaceContainer(name: document['sname']);
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10.0),
                  // 로그인 버튼
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoinSpaceScreen(), // 수정
                        ),
                      );
                    },
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
                    child: Text(
                      '스페이스 참가하기',
                    ),
                  ),
                  SizedBox(height: 5,),
                  OutlinedButton(
                    onPressed: () {
                      // 회원가입 버튼을 눌렀을 때의 동작 추가
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateSpaceScreen(), // 수정
                        ),
                      );
                    },
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
                      padding: EdgeInsets.symmetric(vertical: 15), // 높이를 5씩 늘림
                    ),
                    child: Text(
                      '스페이스 생성하기',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _SpaceContainer extends StatelessWidget {
  final String name;
  const _SpaceContainer({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: primaryColor, // 내부 색상을 primaryColor로 설정
            borderRadius: BorderRadius.circular(10), // 테두리를 둥글게
            border: Border.all(
              color: Color(0xffe9ecef), // 테두리 색상 설정
              width: 1, // 테두리 두께 설정
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26, // 그림자 색상
                blurRadius: 5, // 그림자 흐림 반경
                offset: Offset(0, 5), // 그림자 오프셋
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$name',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSansKR',
                    color: blueColor
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TabView(), // 수정
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  foregroundColor: primaryColor,
                  textStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NotoSansKR'
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10), // 높이를 5씩 늘림
                ),
                child: Text('입장하기'),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
