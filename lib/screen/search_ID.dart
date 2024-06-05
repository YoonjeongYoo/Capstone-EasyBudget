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

                    // 검색 결과를 dialog로 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('검색 결과'),
                          content: Text((foundId != null && foundId.isNotEmpty)
                              ? 'ID는 "$foundId" 입니다'
                              : '일치하는 ID가 존재하지 않습니다.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                '확인',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          backgroundColor: Colors.white,
                          titleTextStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'NotoSansKR',
                            color: Colors.black,
                          ),
                          contentTextStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'NotoSansKR',
                              color: Colors.black
                          ),
                        );
                      },
                    );
                  },
                  child: Text('검색'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: blueColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
