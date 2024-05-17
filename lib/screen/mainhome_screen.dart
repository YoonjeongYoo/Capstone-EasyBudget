import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/screen/mypage_screen.dart';
import 'package:easybudget/screen/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class MainhomeScreen extends StatelessWidget {
  const MainhomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        appbar: AppbarLayout(
          action: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationScreen(), // 수정
                        ),
                      );
                    },
                    icon: Icon(CupertinoIcons.bell),
                    iconSize: 30,
                  ),
                  IconButton(
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
                ],
              ),
            ),
          ],
          title: '경기대학교 학생회',
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 30,
          ),
          child: Column(
            children: [
              Flexible(
                flex: 4,
                child: _AnnouncementBox(),
              ),
              SizedBox(height: 50,),
              Flexible(
                flex: 6,
                child: _RecentBudgetSpending(),
              ),
            ],
          ),
        ),
    );
  }
}


class _AnnouncementBox extends StatelessWidget {
  const _AnnouncementBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 20,
              offset: Offset(10, 10),
            )
          ]
      ),
      padding: EdgeInsets.all(18,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(CupertinoIcons.speaker_1_fill, color: Colors.red, size: 30,),
                  Text(
                    '공지사항',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
              TextButton(
                  onPressed: (){},
                  child: Text(
                    '더보기',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentBudgetSpending extends StatelessWidget {
  const _RecentBudgetSpending({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18,),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 20,
              offset: Offset(10, 10),
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '최신 예산 사용 내역',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700
            ),
          ),
          Row(
            children: [

            ],
          )
        ],
      ),
    );
  }
}
