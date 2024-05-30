import 'package:flutter/material.dart';

class PurchasedView extends StatelessWidget {
  final String? perchased;

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
  final TextEditingController controller;

  const PurchasedEdit({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: controller.text.isEmpty ? '구매처를 입력하세요' : '',
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
        scrollPhysics: BouncingScrollPhysics(),
        keyboardType: TextInputType.text,
        minLines: 1,
        maxLines: 3,
        scrollPadding: EdgeInsets.all(5.0),
        textInputAction: TextInputAction.done,
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
