import 'package:flutter/material.dart';

class TotalCostView extends StatelessWidget {
  final String? totalcost;

  const TotalCostView({Key? key, required this.totalcost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (totalcost == null || totalcost!.isEmpty) {
      return Container();
    }

    return Text(
      '$totalcost',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        fontFamily: 'NotoSansKR',
        color: Colors.red,
      ),
    );
  }
}

class TotalCostEdit extends StatelessWidget {
  final TextEditingController controller;

  const TotalCostEdit({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: controller.text.isEmpty ? '총합계를 입력하세요' : '',
          border: OutlineInputBorder(),
        ),
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          fontFamily: 'NotoSansKR',
          color: Colors.red,
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
