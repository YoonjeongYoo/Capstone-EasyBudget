import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:easybudget/constant/color.dart';
import 'package:easybudget/screen/chart_screen.dart';
import 'package:easybudget/screen/mainhome_screen.dart';
import 'package:easybudget/screen/member_management_screen.dart';
import 'package:easybudget/screen/receipt_input_screen.dart';
import 'package:easybudget/screen/receipt_scan_confirm_screen.dart';
import 'package:easybudget/screen/space_setting_screen.dart';
import 'package:path_provider/path_provider.dart';
//import '../screen/login_screen.dart';
import '../screen/approval_management_screen.dart';
import '../screen/calender_screen.dart';

String? spaceName;

class TabView extends StatefulWidget {
  final String spaceName;
  final String userId; // userId를 받기 위한 변수 추가

  const TabView({super.key, required this.spaceName, required this.userId});


  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with TickerProviderStateMixin {
  late TabController _tabController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    spaceName = widget.spaceName;

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
        children:  [
          MainHomeScreen(spaceName:spaceName, userId: widget.userId,), // 여기에 spacename 넘기기 spaceName:spaceName
          ChartScreen(),    // 여기에 spacename 넘기기
          SizedBox(), // Placeholder for Scan Dialog
          CalendarPage(spaceName:spaceName),   // 여기에 spacename 넘기기
          SizedBox(), // Placeholder for Menu Dialog
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, int tabIndex) {
    Widget dialog;
    if (tabIndex == 2) {
      dialog = ScanDialog(userId: widget.userId, spaceName: widget.spaceName,);
    } else {
      dialog = MenuDialog(currentUserId: widget.userId); // currentUserId를 전달
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

class OcrResponse {
  final String status;
  final String message;

  OcrResponse({required this.status, required this.message});

  factory OcrResponse.fromJson(Map<String, dynamic> json) {
    return OcrResponse(
      status: json['status'] ?? '', // null 값을 처리
      message: json['message'] ?? '', // null 값을 처리
    );
  }
}


class ScanDialog extends StatefulWidget {
  final String spaceName;
  final String userId;
  const ScanDialog({Key? key, required this.userId, required this.spaceName}) : super(key: key);

  @override
  State<ScanDialog> createState() => _ScanDialogState();
}

class _ScanDialogState extends State<ScanDialog> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _resizeAndUploadImage(_image!);
    }
  }

  Future<void> _resizeAndUploadImage(File image) async {
    // 이미지를 크기 조정
    final bytes = await image.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);
    img.Image resizedImage = img.copyResize(originalImage!, width: 600);

    // 크기 조정된 이미지를 파일로 저장
    final resizedImageFile = await _writeToFile(resizedImage);

    // 이미지를 서버로 업로드
    await uploadImage(resizedImageFile);
  }

  Future<File> _writeToFile(img.Image image) async {
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/resized_image.jpg';
    final imageFile = File(imagePath);
    await imageFile.writeAsBytes(img.encodeJpg(image));
    return imageFile;
  }

  Future<void> uploadImage(File imageFile) async {
    // 로딩 다이얼로그 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(color: blueColor,),
        );
      },
    );

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.183.168:5000/process_image'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      final response = await request.send().timeout(Duration(seconds: 30));

      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        final Map<String, dynamic> jsonResponse = jsonDecode(respStr);

        // JSON 응답에서 필요한 데이터 추출
        final String purchased = jsonResponse['images'][0]['receipt']['result']['storeInfo']['name']['text'] ?? 'Unknown';
        final String address = jsonResponse['images'][0]['receipt']['result']['storeInfo']['addresses'][0]['text'] ?? 'Unknown';
        final String date = jsonResponse['images']?[0]?['receipt']?['result']?['paymentInfo']?['date']?['text']?.toString() ?? 'Unknown';
        final String totalCost = jsonResponse['images']?[0]?['receipt']?['result']?['totalPrice']?['price']?['text']?.toString() ?? 'Unknown';

        final items = jsonResponse['images']?[0]?['receipt']?['result']?['subResults']?[0]?['items'] ?? [];

        List<Map<String, String>> parsedItems = items.map<Map<String, String>>((item) {
          final name = item['name']?['text']?.toString() ?? 'Unknown';
          final count = item['count']?['text']?.toString() ?? 'Unknown';
          final cost = item['price']?['price']?['text']?.toString() ?? 'Unknown';
          return {
            'name': name,
            'count': count,
            'cost': cost,
          };
        }).toList();

        // 로딩 다이얼로그 닫기
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReceiptScanComfirmScreen(
              spaceName: widget.spaceName,
              userId: widget.userId,
              purchased: purchased,
              address: address,
              date: date,
              category: '',
              items: parsedItems,
              totalCost: totalCost,
            ),
          ),
        );
      } else {
        print('Failed to upload image, status code: ${response.statusCode}');
        // 로딩 다이얼로그 닫기
        Navigator.pop(context);
      }
    } on http.ClientException catch (e) {
      print('ClientException: $e');
      // 로딩 다이얼로그 닫기
      Navigator.pop(context);
    } on SocketException catch (e) {
      print('SocketException: $e');
      // 로딩 다이얼로그 닫기
      Navigator.pop(context);
    } on TimeoutException catch (e) {
      print('TimeoutException: $e');
      // 로딩 다이얼로그 닫기
      Navigator.pop(context);
    }
  }



  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            getImage(ImageSource.camera);
          },
          child: Text(
            '영수증 사진 스캔',
            style: TextStyle(color: blueColor),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            getImage(ImageSource.gallery);
          },
          child: Text(
            '앨범에서 선택',
            style: TextStyle(color: blueColor),
          ),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReceiptInputScreen(userId: widget.userId, spaceName: widget.spaceName,),
              ),
            );
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
  final String currentUserId; // currentUserId 추가

  const MenuDialog({Key? key, required this.currentUserId}) : super(key: key);

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
                builder: (context) => MemberManagementScreen(spaceName: spaceName!, currentUserId: currentUserId), // currentUserId 전달
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
