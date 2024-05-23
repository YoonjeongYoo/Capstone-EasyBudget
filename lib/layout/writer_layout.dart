import 'package:flutter/material.dart';

class WriterView extends StatelessWidget {
  final String name;
  final String uid;

  const WriterView({super.key, required this.name, required this.uid});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$name',
          style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: 'NotoSansKR'
          ),
        ),
        Text(
          '($uid)',
          style: TextStyle(
              color: Colors.black38,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'NotoSansKR'
          ),
        ),
      ],
    );
  }
}
