import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/screen/mypage_screen.dart';
import 'package:easybudget/screen/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // NumberFormat을 사용하기 위해 임포트합니다.

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
  const _AnnouncementBox({super.key,});

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
          Expanded( // 내부 컨텐츠가 컨테이너를 벗어나지 않도록 함
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
                SizedBox(height: 5,),
                // 텍스트가 컨테이너를 벗어나면 '...'으로 표시
                _AnnouncementContent(),
              ],
            ),
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
          SizedBox(height: 25,),
          _RecentBudgetSpendingContent(purchased: '파리바게트', cost: 25000,),
          _RecentBudgetSpendingContent(purchased: '다이소', cost: 5000,),
          _RecentBudgetSpendingContent(purchased: '카카오 택시', cost: 12500,),
          _RecentBudgetSpendingContent(purchased: '에어비앤비', cost: 400000,),
          _RecentBudgetSpendingContent(purchased: '홈플러스', cost: 5000,),
        ],
      ),
    );
  }
}

class _AnnouncementContent extends StatelessWidget {
  const _AnnouncementContent({super.key,});

  @override
  Widget build(BuildContext context) {
    return Text(
      '<학생회 예산 관리 공지사항>\n'
          '학생회 예산 관리와 관련된 주요 공지사항은 다음과 같습니다:\n\n'
          '- 학생회 예산 신청 방법\n'
          '1. 학생회 예산 신청은 온라인 신청 시스템을 통해 진행됩니다. \n'
          '2. 예산 비목별 신청 방법과 제출 서류를 잘 확인하여 준비해야 합니다. \n',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoSansKR',
        fontSize: 13
      ),
      overflow: TextOverflow.ellipsis, // Overflow handling with ellipsis
      maxLines: 6, // Set max lines to control overflow behavior
    );
  }
}

class _RecentBudgetSpendingContent extends StatelessWidget {
  final String purchased;
  final int cost;
  const _RecentBudgetSpendingContent({Key? key, required this.purchased, required this.cost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // NumberFormat 인스턴스를 생성하여 콤마를 포함한 형식으로 숫자를 변환합니다.
    final formatter = NumberFormat('#,###');

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            purchased,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontFamily: 'NotoSansKR',
                fontSize: 14
            ),
          ),
          Text(
            // formatter.format을 사용하여 콤마를 포함한 형식으로 변환된 숫자를 출력합니다.
            formatter.format(cost),
            style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
                fontFamily: 'NotoSansKR',
                fontSize: 15
            ),
          ),
        ],
      ),
    );
  }
}