import 'package:flutter/material.dart';

class AddressView extends StatelessWidget {
  final String? address;

  const AddressView({super.key, required this.address,});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$address',
      style: TextStyle(

          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: 'NotoSansKR',
          color: Colors.black54
      ),
    );
  }
}

class AddressEdit extends StatelessWidget {
  final String? existingData;

  const AddressEdit({super.key, this.existingData});

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
              ? '주소를 입력하세요'
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