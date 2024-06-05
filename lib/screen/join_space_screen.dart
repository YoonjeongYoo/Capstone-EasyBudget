import 'package:easybudget/constant/color.dart';
import 'package:easybudget/firebase/login_db.dart';
import 'package:easybudget/firebase/search_db.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:easybudget/screen/space_management_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JoinSpaceScreen extends StatefulWidget {
  const JoinSpaceScreen({Key? key}) : super(key: key);

  @override
  _JoinSpaceScreenState createState() => _JoinSpaceScreenState();
}

class _JoinSpaceScreenState extends State<JoinSpaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  String? _selectedSpaceName;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 참가하기',
        back: true,
        action: [],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: '스페이스 검색',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (_searchText.isNotEmpty)
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Space')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }

                          final spaces = snapshot.data!.docs
                              .where((doc) {
                            final name = doc['sname']
                                .toString()
                                .toLowerCase()
                                .contains(_searchText.toLowerCase());
                            final tags = doc['tag']
                                .toString()
                                .toLowerCase()
                                .contains(_searchText.toLowerCase());
                            return name || tags;
                          })
                              .toList();

                          if (spaces.isEmpty) {
                            return Center(child: Text('검색 결과가 없습니다.'));
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: spaces.length,
                            itemBuilder: (context, index) {
                              final space = spaces[index];
                              return ListTile(
                                title: Text(space['sname']),
                                onTap: () {
                                  setState(() {
                                    _selectedSpaceName = space['sname'];
                                  });
                                },
                                selected: _selectedSpaceName == space['sname'],
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: _selectedSpaceName == null
                      ? null
                      : () async {
                    final currentUserid = await getUserId(); // 현재 로그인된 사용자 아이디
                    if (currentUserid == null) {
                      // currentUserid가 null인 경우 예외 처리
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('사용자 아이디를 가져오는 데 실패했습니다. 다시 시도해 주세요.'))
                      );
                      return;
                    }

                    String? udocid = '';

                    await FirebaseFirestore.instance
                        .collection('User')
                        .where('uid', isEqualTo: currentUserid)
                        .get().then((value) {
                      for(var element in value.docs) {
                        udocid = element.id;
                      }
                    }); // 현재 사용자의 문서 아이디 검색


                    String? sdocid = '';
                    await FirebaseFirestore.instance
                        .collection('Space')
                        .where('sname', isEqualTo: _selectedSpaceName)
                        .get().then((value) async {
                      for(var element in value.docs) {
                        sdocid = element.id;
                        print(sdocid);
                      }
                    }); // 사용자가 선택한 스페이스의 문서 아이디 검색
                    final sid = await getSid(sdocid!);

                    final data1 = <String, dynamic> {
                      'uid': currentUserid,
                      'authority': 2,
                    }; // 현재 사용자의 아이디, 권한

                    final data2 = <String, dynamic> {
                      'sid': sid,
                      'authority': 2,
                    }; // 사용자가 가입한 스페이스 아이디, 스페이스에서의 권한

                    await FirebaseFirestore.instance
                        .collection('Space')
                        .doc(sdocid)
                        .collection('Member')
                        .add(data1); // data1을 스페이스의 member 서브 컬렉션에 저장

                    await FirebaseFirestore.instance
                        .collection('User')
                        .doc(udocid)
                        .collection('entered')
                        .add(data2); // data2를 entered 서브컬렉션에 저장

                    await FirebaseFirestore.instance
                        .collection('User')
                        .doc(udocid)
                        .update({
                      'spaces': FieldValue.arrayUnion([sdocid])
                    })
                        .then((_) {
                      print("udocid successfully added to member array!");
                    })
                        .catchError((error) {
                      print("Failed to add udocid to member array: $error");
                    });

                    // 뒤로가기 동작 수행
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SpaceManagementScreen(userId: currentUserid), // 수정
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blueColor,
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
                  child: Text('스페이스 참가하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
