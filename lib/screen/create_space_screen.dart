import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';

import 'mypage_screen.dart';

class CreateSpaceScreen extends StatefulWidget {
  const CreateSpaceScreen({super.key});

  @override
  _CreateSpaceScreenState createState() => _CreateSpaceScreenState();
}

class _CreateSpaceScreenState extends State<CreateSpaceScreen> {
  TextEditingController spaceNameController = TextEditingController();
  TextEditingController totalBudgetController = TextEditingController();
  TextEditingController participationCodeController = TextEditingController();
  TextEditingController confirmParticipationCodeController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  bool isApprovalRequired = false;
  bool isParticipationCodeMatched = false;

  Future<void> _checkDuplicate() async {
    String spaceName = spaceNameController.text;

    if (spaceName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스페이스명을 입력해 주세요')),
      );
      return;
    }

    // Firestore에서 스페이스 이름이 있는지 확인
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Space')
        .where('sname', isEqualTo: spaceName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미 생성된 스페이스명 입니다')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('사용 가능한 스페이스명 입니다')),
      );
    }
  }

  Future<void> _createSpace() async {
    String spaceName = spaceNameController.text;
    String spaceBudget = totalBudgetController.text;
    String joinCode = participationCodeController.text;
    String confirmJoinCode = confirmParticipationCodeController.text;
    String tag = tagController.text;

    if (spaceName.isEmpty || joinCode.isEmpty || tag.isEmpty || spaceBudget.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 채워주세요.')),
      );
      return;
    }

    if (joinCode != confirmJoinCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('참여코드가 일치하지 않습니다')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Space').add({
        'sname': spaceName,
        'sid': joinCode,
        'tag': tag,
        'approvalRequired': isApprovalRequired,
        'sTotalBudget' : spaceBudget,
      });

      await FirebaseFirestore.instance.collection('EnteredSpace').add({
        'sname': spaceName,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스페이스가 성공적으로 생성되었습니다.')),
      );

      spaceNameController.clear();
      participationCodeController.clear();
      confirmParticipationCodeController.clear();
      totalBudgetController.clear();
      tagController.clear();
      setState(() {
        isApprovalRequired = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스페이스 생성 중 오류가 발생했습니다.')),
      );
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    participationCodeController.addListener(_checkParticipationCode);
    confirmParticipationCodeController.addListener(_checkParticipationCode);
  }

  @override
  void dispose() {
    spaceNameController.dispose();
    participationCodeController.dispose();
    confirmParticipationCodeController.dispose();
    tagController.dispose();
    super.dispose();
  }

  void _checkParticipationCode() {
    setState(() {
      isParticipationCodeMatched =
          participationCodeController.text.isNotEmpty &&
              participationCodeController.text == confirmParticipationCodeController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 생성하기',
        action: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MypageScreen(),
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 9,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '스페이스 이름',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: spaceNameController,
                      decoration: InputDecoration(
                        hintText: '이름을 입력해 주세요.',
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _checkDuplicate,
                      // {
                      //   // 중복 확인 로직 추가
                      // },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color.fromRGBO(0, 88, 246, 1),
                        side: BorderSide(color: Color.fromRGBO(0, 88, 246, 1), width: 2),
                      ),
                      child: Text('중복확인'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '총 예산 설정',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: totalBudgetController,
                      decoration: InputDecoration(
                        hintText: '총 예산을 입력해 주세요.',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '참여코드',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: participationCodeController,
                      decoration: InputDecoration(
                        hintText: '참여코드를 입력해 주세요.',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '참여코드 확인',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: confirmParticipationCodeController,
                      decoration: InputDecoration(
                        hintText: '참여코드를 한번 더 입력해 주세요.',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '태그',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: tagController,
                      decoration: InputDecoration(
                        hintText: '태그를 작성하여 주세요. ex) #경기대',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '참여 기능 승인',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '참여 승인 기능을 ON으로 설정 시 스페이스에 새로   참여할 때 관리자의 승인을 반드시 받아야 합니다.',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isApprovalRequired = !isApprovalRequired;
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isApprovalRequired
                                    ? Color.fromRGBO(0, 88, 246, 1)
                                    : Color.fromRGBO(194, 194, 194, 1),
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                  left: isApprovalRequired ? 30 : 0,
                                  right: isApprovalRequired ? 0 : 30,
                                  child: Container(
                                    width: 30,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: isApprovalRequired
                                          ? Color.fromRGBO(0, 88, 246, 1)
                                          : Color.fromRGBO(194, 194, 194, 1),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: isApprovalRequired ? Alignment.centerLeft : Alignment.centerRight,
                                  child: Text(
                                    isApprovalRequired ? 'ON' : 'OFF',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isApprovalRequired
                                          ? Color.fromRGBO(0, 88, 246, 1)
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    //onPressed: isParticipationCodeMatched
                    onPressed: _createSpace,
                    //     ? () {
                    //   // 스페이스 생성 로직 추가
                    // }
                    //     : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isParticipationCodeMatched ? blueColor : Colors.grey,
                      foregroundColor: primaryColor,
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'NotoSansKR',
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('스페이스 생성'),
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