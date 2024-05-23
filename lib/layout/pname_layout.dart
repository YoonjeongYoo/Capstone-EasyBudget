import 'package:flutter/material.dart';

class PnameView extends StatelessWidget {
  final String pname;

  const PnameView({super.key, required this.pname,});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$pname',
      style: TextStyle(

          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'NotoSansKR',
          color: Colors.black54
      ),
    );
  }
}

class PnameEdit extends StatelessWidget {
  final String? existingData;

  const PnameEdit({super.key, this.existingData});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController(
      text: existingData,
    );

    return Container(
      width: 100,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: existingData == null || existingData!.isEmpty
              ? '상품명'
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