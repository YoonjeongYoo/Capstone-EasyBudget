import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';

class ApprovalManagementScreen extends StatelessWidget {
  const ApprovalManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 참여 요청',
        action: [],
        back: true,
      ),
      body: SingleChildScrollView( // 2. SingleChildScrollView 추가
        child: Column(
          children: [
            _RequestContainer(name: '김효영', uid: 'khy1234', profile: 'asset/img/profile_img_2.png',),
            _RequestContainer(name: '이하빈', uid: 'lhb123', profile: 'asset/img/profile_img_2.png',),
            _RequestContainer(name: '이은수', uid: 'les456', profile: 'asset/img/profile_img_2.png',),
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


class _RequestContainer extends StatelessWidget {
  final String name;
  final String uid;
  final String profile;
  const _RequestContainer({super.key, required this.name, required this.uid, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(
          horizontal: 30
      ),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xffe9ecef)), // 위쪽 테두리
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(profile),
              ),
              SizedBox(width: 20,),
              Text(
                '$name',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSansKR'
                ),
              ),
              Text(
                '($uid)',
                style: TextStyle(
                    color: Colors.black38,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'NotoSansKR'
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: blueColor,
                  foregroundColor: primaryColor,
                  textStyle: TextStyle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  '승인',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSansKR'
                  ),
                ),
              ),
              SizedBox(width: 5,),
              ElevatedButton(
                onPressed: () {

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: primaryColor,
                  textStyle: TextStyle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  '거절',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSansKR'
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
