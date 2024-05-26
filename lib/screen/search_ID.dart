import 'package:flutter/material.dart';

class FindIdScreen extends StatefulWidget {
  @override
  _FindIdScreenState createState() => _FindIdScreenState();
}

class _FindIdScreenState extends State<FindIdScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10),  // 기본 높이 + 여백
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);  // 이전 페이지로 돌아가기
            },
          ),
          title: Text('ID 찾기', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Color(0xfff2f2f2),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10), // 여백 크기
            child: SizedBox(height: 10),  // 실제 여백을 만드는 위젯
          ),
        ),
      ),
      body: Center( // 화면의 위젯들을 가운데에 위치시키기 위해 Center 위젯 사용
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                onPressed: () {
                  // 검색 버튼 클릭 이벤트 처리. 검색 로직을 여기에 구현.
                  print("검색 버튼 클릭됨: ${_controller.text}");
                  // 검색 로직을 여기에 구현하세요.
                },
                child: Text('검색'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue,
                ),
              ),
              SizedBox(height: 20.0),
              // Firebase 연동 없이 임시 검색 결과 표시
              Text('검색 결과가 여기에 표시됩니다.'),
            ],
          ),
        ),
      ),
    );
  }
}
