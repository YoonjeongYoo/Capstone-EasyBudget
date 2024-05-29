import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateSpaceWidget extends StatefulWidget {
  @override
  _CreateSpaceWidgetState createState() => _CreateSpaceWidgetState();
}

class _CreateSpaceWidgetState extends State<CreateSpaceWidget> {
  final TextEditingController _spaceNameController = TextEditingController();
  final TextEditingController _joinCodeController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  bool _approvalRequired = false;

  Future<void> _createSpace() async {
    String spaceName = _spaceNameController.text;
    String joinCode = _joinCodeController.text;
    String tag = _tagController.text;

    if (spaceName.isEmpty || joinCode.isEmpty || tag.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 채워주세요.')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Space').add({
        'sname': spaceName,
        'sid': joinCode,
        'tag': tag,
        'approvalRequired': _approvalRequired,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스페이스가 성공적으로 생성되었습니다.')),
      );

      _spaceNameController.clear();
      _joinCodeController.clear();
      _tagController.clear();
      setState(() {
        _approvalRequired = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('스페이스 생성 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스페이스 생성'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _spaceNameController,
              decoration: InputDecoration(labelText: '스페이스 이름'),
            ),
            TextField(
              controller: _joinCodeController,
              decoration: InputDecoration(labelText: '참여 코드'),
            ),
            TextField(
              controller: _tagController,
              decoration: InputDecoration(labelText: '태그'),
            ),
            SwitchListTile(
              title: Text('참여 승인 기능'),
              value: _approvalRequired,
              onChanged: (bool value) {
                setState(() {
                  _approvalRequired = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createSpace,
              child: Text('스페이스 생성'),
            ),
          ],
        ),
      ),
    );
  }
}
