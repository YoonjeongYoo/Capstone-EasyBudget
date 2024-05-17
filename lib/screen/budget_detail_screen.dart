import 'package:flutter/material.dart';
import 'expense_detail_screen.dart';
import 'package:intl/intl.dart';

class BudgetDetailsScreen extends StatelessWidget {
  final DateTime selectedDay;
  final List events;


  const BudgetDetailsScreen({
    Key? key,
    required this.selectedDay,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    // 테스트용 데이터
    final testExpenses = [
      {'category': '식비', 'item': '점심 식사', 'amount': 12000},
      {'category': '교통비', 'item': '버스 카드 충전', 'amount': 50000},
      {'category': '기타', 'item': '책 구매', 'amount': 18000},
    ];

    // 선택된 날짜에 대한 총 수입과 지출 계산
    int total = 0;


    for (var event in events) {
      if (event.contains('지출:')) {
        total -= int.parse(event.split(':')[1].replaceAll('원', '').trim());
      } else if (event.contains('수입:')) {
        total += int.parse(event.split(':')[1].replaceAll('원', '').trim());
      }
    }

    // total 포맷
    final formattedTotal = NumberFormat('#,###').format(total);

    return Scaffold(
      appBar: AppBar(
        title: Text('달력',style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row( // 날짜와 총합 배치
                  children: [
                    Text(
                      '  ${selectedDay.day}  ',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${selectedDay.year}. ${selectedDay.month}',
                      style: TextStyle(fontSize: 13, color: Colors.grey),

                    ),
                    Spacer(),
                    Text(
                      '총합: $formattedTotal',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: total > 0 ? Colors.blue : Colors.red,),
                    ),
                  ],

                ),
                SizedBox(height: 16),
                Column(
                  children: testExpenses.map((expense) => Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ExpenseDetailsScreen(expense: expense)),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  expense['category'] as String,
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  expense['item'] as String,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '${NumberFormat('#,###').format(expense['amount'])}원',
                                  style: TextStyle(fontSize: 16, color: Colors.red),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                        thickness: 1,
                      ),
                    ],
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
