import 'package:flutter/material.dart';

class AmountView extends StatelessWidget {
  final String amount;

  const AmountView({super.key, required this.amount,});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$amount',
      style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'NotoSansKR',
          color: Colors.black54
      ),
    );
  }
}

class AmountEdit extends StatelessWidget {
  final String? existingData;

  const AmountEdit({super.key, this.existingData});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController(
      text: existingData,
    );

    return Container(
      width: 50,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: existingData == null || existingData!.isEmpty
              ? ''
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