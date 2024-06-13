import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemberManagementScreen extends StatefulWidget {
  final String spaceName;
  final String currentUserId;

  const MemberManagementScreen({super.key, required this.spaceName, required this.currentUserId});

  @override
  _MemberManagementScreenState createState() => _MemberManagementScreenState();
}

class _MemberManagementScreenState extends State<MemberManagementScreen> {
  Future<List<Map<String, dynamic>>> fetchMembers() async {
    final db = FirebaseFirestore.instance;

    print("Fetching members for space: ${widget.spaceName}");

    final spaceQuerySnapshot = await db
        .collection('Space')
        .where('sname', isEqualTo: widget.spaceName)
        .get();

    final spaceSnapshot = spaceQuerySnapshot.docs.isNotEmpty
        ? spaceQuerySnapshot.docs.first
        : null;

    if (spaceSnapshot == null) {
      print("No space found with name: ${widget.spaceName}");
      return [];
    }

    String spaceId = spaceSnapshot.id;
    print("Found space ID: $spaceId");

    final membersQuerySnapshot = await db
        .collection('Space')
        .doc(spaceId)
        .collection('Member')
        .get();

    print("Found ${membersQuerySnapshot.docs.length} members");

    List<Map<String, dynamic>> members = [];

    for (var memberDoc in membersQuerySnapshot.docs) {
      String memberId = memberDoc.data()['uid'];
      int authority = memberDoc.data()['authority'];
      print("Fetching user data for member ID: $memberId with authority: $authority");

      final userDoc = await db.collection('User').where('uid', isEqualTo: memberId).get();
      if (userDoc.docs.isNotEmpty) {
        var userSnapshot = userDoc.docs.first;
        Map<String, dynamic> userData = userSnapshot.data();
        userData['authority'] = authority;

        userData['uname'] = userData['uname'] ?? 'Unknown';
        userData['uid'] = userData['uid'] ?? 'Unknown';
        userData['sid'] = spaceId;

        members.add(userData);
        print("Added user data for member ID: $memberId with uname: ${userData['uname']}, uid: ${userData['uid']}");
      } else {
        print("No user data found for member ID: $memberId");
      }
    }

    return members;
  }

  Future<int> fetchCurrentUserAuthority(String spaceId) async {
    final db = FirebaseFirestore.instance;

    final memberQuerySnapshot = await db
        .collection('Space')
        .doc(spaceId)
        .collection('Member')
        .where('uid', isEqualTo: widget.currentUserId)
        .get();

    if (memberQuerySnapshot.docs.isNotEmpty) {
      return memberQuerySnapshot.docs.first.data()['authority'];
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 멤버 관리',
        back: true,
        action: [],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Members Found'));
          }

          final members = snapshot.data!;
          final spaceId = members.isNotEmpty ? members.first['sid'] : '';

          return FutureBuilder<int>(
            future: fetchCurrentUserAuthority(spaceId),
            builder: (context, authoritySnapshot) {
              if (authoritySnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (authoritySnapshot.hasError) {
                return Center(child: Text('Error: ${authoritySnapshot.error}'));
              }

              final currentUserAuthority = authoritySnapshot.data ?? 0;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    for (var member in members)
                      _MemberContainer(
                        name: member['uname'] ?? 'Unknown',
                        uid: member['uid'] ?? 'Unknown',
                        sid: member['sid'] ?? 'Unknown',
                        authority: member['authority'] ?? 0,
                        profile: 'asset/img/profile_img_2.png',
                        currentUserAuthority: currentUserAuthority,
                        onRemove: () {
                          setState(() {
                            members.remove(member);
                          });
                        },
                      ),
                    Divider(
                      color: Color(0xffe9ecef),
                    ),
                  ],
                ),
              );
            },
          );
        },
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
  final int currentUserAuthority;
  final VoidCallback onRemove;

  _MemberContainer({Key? key, required this.name, required this.uid, required this.sid, required this.authority, required this.profile, required this.currentUserAuthority, required this.onRemove});

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
      onTap: () async {
        setState(() {
          widget.authority = authorityValue;
          updateAuthorityText();
        });

        final db = FirebaseFirestore.instance;
        await db
            .collection('Space')
            .doc(widget.sid)
            .collection('Member')
            .where('uid', isEqualTo: widget.uid)
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            doc.reference.update({'authority': authorityValue});
          }
        });

        Navigator.pop(context);
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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                onPressed: widget.currentUserAuthority == 1 ? () async {
                  final db = FirebaseFirestore.instance;
                  await db
                      .collection('Space')
                      .doc(widget.sid)
                      .collection('Member')
                      .where('uid', isEqualTo: widget.uid)
                      .get()
                      .then((querySnapshot) {
                    for (var doc in querySnapshot.docs) {
                      doc.reference.delete();
                    }
                  });

                  await db.collection('User').where('uid', isEqualTo: widget.uid).get().then((querySnapshot) {
                    for (var doc in querySnapshot.docs) {
                      if ((doc.data()['entered'] as List).length == 1) {
                        doc.reference.update({'entered': FieldValue.delete()});
                      } else {
                        doc.reference.update({
                          'entered': FieldValue.arrayRemove([widget.sid])
                        });
                      }
                    }
                  });

                  widget.onRemove();
                } : null,
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
                  '탈퇴',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
