import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnouncementForm extends StatefulWidget {
  @override
  _AnnouncementFormState createState() => _AnnouncementFormState();
}

class _AnnouncementFormState extends State<AnnouncementForm> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _saveAnnouncement() async {
    if (_controller.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('Space')
          .doc('KBpkiTfmpsg3ZI5iSpyY')
          .collection('Notice')
          .doc('notice').set({
        'announcement': _controller.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('공지사항 저장 완료!')));
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('여기에 공지사항을 입력해주세요')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '공지사항 저장하기',
        back: true,
        action: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 10,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '공지사항을 작성해 주세요',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveAnnouncement,
              child: Text('공지사항 저장하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: blueColor,
                foregroundColor: primaryColor,
                textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSansKR'
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                ),
                padding: EdgeInsets.all(15), // 높이를 5씩 늘림
              ),
            ),
          ],
        ),
      ),
    );
  }
}
