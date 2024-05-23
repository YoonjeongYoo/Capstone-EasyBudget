import 'package:flutter/material.dart';

class PurchasedView extends StatelessWidget {
  final String perchased;

  const PurchasedView({super.key, required this.perchased});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$perchased',
      style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'NotoSansKR',
          color: Colors.black54
      ),
    );
  }
}

class PurchasedEdit extends StatelessWidget {
  final String? existingData;

  const PurchasedEdit({super.key, this.existingData});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController(
      text: existingData,
    );

    return Container(
      width: 230,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: existingData == null || existingData!.isEmpty
              ? '구매처를 입력하세요'
              : '',
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        scrollPhysics: BouncingScrollPhysics(),
        keyboardType: TextInputType.text,
        minLines: 1, // 최소 줄 수
        maxLines: 3, // 최대 줄 수
        scrollPadding: EdgeInsets.all(5.0),
        textInputAction: TextInputAction.done,
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}