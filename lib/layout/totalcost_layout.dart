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
