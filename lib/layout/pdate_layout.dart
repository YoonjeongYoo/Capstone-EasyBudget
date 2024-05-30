import 'package:flutter/material.dart';

class PdateView extends StatelessWidget {
  final String? pdate;

  const PdateView({super.key, required this.pdate,});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$pdate',
      style: TextStyle(

          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'NotoSansKR',
          color: Colors.black54
      ),
    );
  }
}

class PdateEdit extends StatelessWidget {
  final TextEditingController controller;

  const PdateEdit({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: controller.text.isEmpty ? '거래 일시를 입력하세요' : '',
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
