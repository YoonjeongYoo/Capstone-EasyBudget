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
    return Scaffold(
      appBar: AppBar(title: Text('공지사항 저장하기')),
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
            ),
          ],
        ),
      ),
    );
  }
}
