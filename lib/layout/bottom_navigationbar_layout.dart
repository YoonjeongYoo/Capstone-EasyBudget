import 'package:easybudget/constant/color.dart';
import 'package:easybudget/screen/chart_screen.dart';
import 'package:easybudget/screen/mainhome_screen.dart';
import 'package:easybudget/screen/member_management_screen.dart';
import 'package:easybudget/screen/space_setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../screen/approval_management_screen.dart';
import '../screen/calender_screen.dart';

class TabView extends StatefulWidget {
  const TabView({Key? key}) : super(key: key);

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with TickerProviderStateMixin {
  late TabController _tabController;
  int _index = 0;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _navItems.length, vsync: this);
    _tabController.addListener(tabListener);
  }

  @override
  void dispose() {
    _tabController.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      _index = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: blueColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 10, fontFamily: 'NotoSansKR'),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
        ),
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          if (index == 2 || index == 4) {
            _showDialog(context, index);
          } else {
            _tabController.animateTo(index);
          }
        },
        currentIndex: _index,
        items: _navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(
              _index == item.index ? item.activeIcon : item.inactiveIcon,
            ),
            label: item.label,
          );
        }).toList(),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [
          MainhomeScreen(),
          ChartScreen(),
          SizedBox(), // Placeholder for Scan Dialog
          CalendarPage(),
          SizedBox(), // Placeholder for Menu Dialog
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, int tabIndex) {
    Widget dialog;
    if (tabIndex == 2) {
      dialog = ScanDialog();
    } else {
      dialog = MenuDialog();
    }

    showCupertinoModalPopup(
      context: context,
      builder: (context) => dialog,
    );
  }
}

class NavItem {
  final int index;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const NavItem({
    required this.index,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}

const _navItems = [
  NavItem(
    index: 0,
    activeIcon: Icons.home,
    inactiveIcon: Icons.home_outlined,
    label: '홈',
  ),
  NavItem(
    index: 1,
    activeIcon: CupertinoIcons.chart_bar_alt_fill,
    inactiveIcon: CupertinoIcons.chart_bar_alt_fill,
    label: '시각화',
  ),
  NavItem(
    index: 2,
    activeIcon: CupertinoIcons.camera_viewfinder,
    inactiveIcon: CupertinoIcons.camera_viewfinder,
    label: '스캔',
  ),
  NavItem(
    index: 3,
    activeIcon: CupertinoIcons.calendar,
    inactiveIcon: CupertinoIcons.calendar,
    label: '캘린더',
  ),
  NavItem(
    index: 4,
    activeIcon: CupertinoIcons.list_bullet,
    inactiveIcon: CupertinoIcons.list_bullet,
    label: '메뉴',
  ),
];

class ScanDialog extends StatelessWidget {
  const ScanDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            // Add your action here
          },
          child: Text(
            '영수증 사진 스캔',
            style: TextStyle(color: blueColor),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            // Add your action here
          },
          child: Text(
            '앨범에서 선택',
            style: TextStyle(color: blueColor),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            // Add your action here
          },
          child: Text(
            '수기로 작성',
            style: TextStyle(color: blueColor),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          '취소',
          style: TextStyle(color: blueColor),
        ),
      ),
    );
  }
}

class MenuDialog extends StatelessWidget {
  const MenuDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            // 초대 클릭 시 다이얼로그 창
            showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: Text("공유하기"),
                  content: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: (){},
                          icon: Icon(CupertinoIcons.chat_bubble_fill),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Color(0xffFEE500)),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              CircleBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: (){},
                          icon: Icon(CupertinoIcons.envelope_fill, color: primaryColor,),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              CircleBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: (){},
                          icon: Icon(CupertinoIcons.link),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              CircleBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(
                        "취소",
                        style: TextStyle(color: blueColor),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Text(
            '초대',
            style: TextStyle(color: blueColor),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            // 스페이스 참여 승인 관리 클릭 시 이벤트
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApprovalManagementScreen(), // 수정
              ),
            );
          },
          child: Text(
            '스페이스 참여 승인 관리',
            style: TextStyle(color: blueColor),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            // 스페이스 멤버 관리 클릭 시 이벤트
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MemberManagementScreen(), // 수정
              ),
            );
          },
          child: Text(
            '스페이스 멤버 관리',
            style: TextStyle(color: blueColor),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            // 스페이스 세부 설정 클릭 시 이벤트
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SpaceSettingScreen(), // 수정
              ),
            );
          },
          child: Text(
            '스페이스 세부 설정',
            style: TextStyle(color: blueColor),
          ),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          '취소',
          style: TextStyle(color: blueColor),
        ),
      ),
    );
  }
}
