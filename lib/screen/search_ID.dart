import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';
import '../firebase/find_db.dart';

class FindIdScreen extends StatefulWidget {
  @override
  _FindIdScreenState createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '아이디 찾기',
        action: [],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Column의 크기를 내용물에 맞게 조절
              children: [
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: '전화번호를 입력해주세요',
                    hintText: '010-1234-5678',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    // 검색 버튼 클릭 이벤트 처리. 검색 로직을 여기에 구현.
                    print("검색 버튼 클릭됨: ${_controller.text}");
                    // 검색 로직을 여기에 구현하세요.
                    final foundId = await findId(_controller.text);
                    print(foundId);
                  },
                  child: Text('검색'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: blueColor,
                  ),
                ),
                SizedBox(height: 20.0),
                // Firebase 연동 없이 임시 검색 결과 표시
                Text('검색 결과가 여기에 표시됩니다.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
