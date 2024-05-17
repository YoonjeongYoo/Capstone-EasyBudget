import 'package:flutter/material.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> expense;

  const ExpenseDetailsScreen({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(expense['item']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('카테고리: ${expense['category']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('항목: ${expense['item']}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 8),
            Text('금액: ${expense['amount']}원', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
