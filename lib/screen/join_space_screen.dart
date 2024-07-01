import 'package:easybudget/constant/color.dart';
import 'package:easybudget/firebase/login_db.dart';
import 'package:easybudget/firebase/search_db.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/join_db.dart';

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
        action: [], back: true,
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
                    String? uid = await getUserId();
                    await joinSpace(uid!, _selectedSpaceName!); // 현재 로그인 된 유저를 선택한 스페이스에 가입 시키는 메서드

                    // 뒤로가기 동작 수행
                    Navigator.of(context).pop();
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
