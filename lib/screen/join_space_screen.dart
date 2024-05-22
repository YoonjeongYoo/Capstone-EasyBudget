import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';

class JoinSpaceScreen extends StatelessWidget {
  const JoinSpaceScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 참가하기',
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
                      onTap: () {
                        // TextField를 탭할 때 다른 포커스를 해제하고 키보드를 감춥니다.
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      decoration: InputDecoration(
                        hintText: '스페이스 검색',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // 검색창과 다른 내용 사이의 간격
                    // 여기에 스페이스 리스트 등 다른 내용을 추가할 수 있습니다.
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 스페이스 참가하기 버튼의 동작 추가
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
                      borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15), // 높이를 5씩 늘림
                  ),
                  child: Text(
                    '스페이스 참가하기',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
