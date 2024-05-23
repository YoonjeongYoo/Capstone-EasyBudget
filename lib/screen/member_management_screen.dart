import 'package:easybudget/constant/color.dart';
import 'package:easybudget/database/space_auth_db.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MemberManagementScreen extends StatelessWidget {
  const MemberManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 멤버 관리',
        action: [],
      ),
      body: SingleChildScrollView( // 2. SingleChildScrollView 추가
        child: Column(
          children: [
            _MemberContainer(name: '유윤정', uid: 'yyj0310', sid: '11aa', authority: 2, profile: 'asset/img/profile_img.jpg',),
            _MemberContainer(name: '정지용', uid: 'jjy1234', sid: '11aa', authority: 1, profile: 'asset/img/profile_img_2.png',),
            _MemberContainer(name: '조참솔', uid: 'ccs4321', sid: '11aa', authority: 3, profile: 'asset/img/profile_img_1.png',),
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


class _MemberContainer extends StatefulWidget {
  final String name;
  final String uid;
  final String sid;
  final String profile;
  int authority;
  _MemberContainer({Key? key, required this.name, required this.uid, required this.sid, required this.authority, required this.profile});

  @override
  _MemberContainerState createState() => _MemberContainerState();
}

class _MemberContainerState extends State<_MemberContainer> {
  String authorityText = '';

  @override
  void initState() {
    super.initState();
    updateAuthorityText();
  }

  void updateAuthorityText() {
    switch (widget.authority) {
      case 1:
        authorityText = '관리자';
        break;
      case 2:
        authorityText = '일반';
        break;
      case 3:
        authorityText = '기록제한';
        break;
      default:
        authorityText = 'Unknown';
        break;
    }
  }

  void _showAuthorityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "권한 선택",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'NotoSansKR',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAuthorityOption(1, '관리자'),
              _buildAuthorityOption(2, '일반'),
              _buildAuthorityOption(3, '기록제한'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuthorityOption(int authorityValue, String text) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          fontFamily: 'NotoSansKR',
        ),
      ),
      onTap: () {
        setState(() {
          widget.authority = authorityValue;
          updateAuthorityText();
          Navigator.pop(context);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 30),
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
                backgroundImage: AssetImage(widget.profile),
              ),
              SizedBox(width: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.name}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  Text(
                    '(${widget.uid})',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: _showAuthorityDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: blueColor,
                  side: BorderSide(color: blueColor),
                  textStyle: TextStyle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                ),
                child: Row(
                  children: [
                    Text(
                      authorityText,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  // 버튼이 클릭되었을 때 수행할 작업
                  updateAuthority(widget.authority, widget.uid, widget.sid);
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
                    fontFamily: 'NotoSansKR',
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
