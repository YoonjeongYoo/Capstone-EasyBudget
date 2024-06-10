import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/screen/mypage_screen.dart';
import 'package:easybudget/screen/notification_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart'; // NumberFormat을 사용하기 위해 임포트합니다.

class MainHomeScreen extends StatelessWidget {
  // const MainHomeScreen({super.key});
  final String? spaceName;
  final String userId; // userId를 받기 위한 변수 추가
  const MainHomeScreen({super.key, required this.spaceName, required this.userId});
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
                  onPressed: () {
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MypageScreen(userId: userId,), // 수정
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
        // title: '경기대학교 학생회',
        title: spaceName ?? 'default name',
        back: true,
        // SpaceName 출력
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
              child: _AnnouncementBox(spaceName: spaceName),
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
  final String? spaceName;
  const _AnnouncementBox({super.key, this.spaceName});

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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('공지사항'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    _AnnouncementContent(spaceName: spaceName, isExpanded: true),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    '닫기',
                                    style: TextStyle(
                                      color: blueColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                              backgroundColor: Colors.white,
                              titleTextStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'NotoSansKR',
                                color: Colors.black,
                              ),
                              contentTextStyle: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'NotoSansKR',
                                  color: Colors.black
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        '더보기',
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                // 텍스트가 컨테이너를 벗어나면 '...'으로 표시
                _AnnouncementContent(spaceName: spaceName, isExpanded: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentBudgetSpending extends StatefulWidget {
  const _RecentBudgetSpending({super.key});

  @override
  __RecentBudgetSpendingState createState() => __RecentBudgetSpendingState();
}

class __RecentBudgetSpendingState extends State<_RecentBudgetSpending> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> recentSpending = [];

  @override
  void initState() {
    super.initState();
    fetchRecentSpending();
  }

  Future<void> fetchRecentSpending() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('Space')
        .doc('KBpkiTfmpsg3ZI5iSpyY')
        .collection('Receipt')
        .orderBy('indate', descending: true)
        .limit(6)
        .get();

    setState(() {
      recentSpending = querySnapshot.docs
          .map((doc) => {
        'purchased': doc['purchased'],
        'cost': doc['totalCost'],
      })
          .toList();
    });
  }

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
          // Firestore에서 불러온 데이터를 이용해 _RecentBudgetSpendingContent 위젯 생성
          for (var spending in recentSpending)
            _RecentBudgetSpendingContent(
              purchased: spending['purchased'],
              cost: spending['cost'],
            ),
        ],
      ),
    );
  }
}


class _AnnouncementContent extends StatelessWidget {
  final String? spaceName;
  final bool isExpanded;
  const _AnnouncementContent({super.key, this.spaceName, this.isExpanded = false});

  Future<String> _fetchAnnouncement() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('Space')
        .where('sname', isEqualTo: spaceName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('Space')
          .doc(querySnapshot.docs.first.id)
          .collection('Notice')
          .doc('notice')
          .get();
      return snapshot.data()?['announcement'] ?? 'No announcement found';
    } else {
      return 'No space found with the specified name';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _fetchAnnouncement(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Failed to load announcement'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No announcement found'));
        } else {
          return Text(
            snapshot.data!,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontFamily: 'NotoSansKR',
              fontSize: 13,
            ),
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            maxLines: isExpanded ? null : 7,
          );
        }
      },
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
              fontSize: 14,
            ),
          ),
          Text(
            // formatter.format을 사용하여 콤마를 포함한 형식으로 변환된 숫자를 출력합니다.
            formatter.format(cost),
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w700,
              fontFamily: 'NotoSansKR',
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
