import 'package:flutter/material.dart';
import 'expense_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetDetailsScreen extends StatefulWidget {
  final DateTime selectedDay;

  const BudgetDetailsScreen({
    Key? key,
    required this.selectedDay,
  }) : super(key: key);

  @override
  _BudgetDetailsScreenState createState() => _BudgetDetailsScreenState();
}

class _BudgetDetailsScreenState extends State<BudgetDetailsScreen> {
  List<Map<String, dynamic>> expenses = [];

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  fetchExpenses() async {
    var selectedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDay); // 'yyyy-MM-dd' 형식의 문자열
    var firestore = FirebaseFirestore.instance;

    // selectedDate를 DateTime으로 변환
    DateTime selectedDateTime = DateFormat('yyyy-MM-dd').parse(selectedDate);

    // 시작과 끝 시간을 구하기 위해 해당 날짜의 시작과 끝을 설정
    var startOfDay = Timestamp.fromDate(DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, 0, 0, 0));
    var endOfDay = Timestamp.fromDate(DateTime(selectedDateTime.year, selectedDateTime.month, selectedDateTime.day, 23, 59, 59));

    var querySnapshot = await firestore
        .collection('Space')
        .doc('u3dYxuN5bv8BxjV6AzpF') // 필요하다면 문서 ID 지정
        .collection('Receipts')
        .where('pdate', isGreaterThanOrEqualTo: startOfDay)
        .where('pdate', isLessThanOrEqualTo: endOfDay)
        .get();

    var fetchedExpenses = querySnapshot.docs.map((doc) {
      print(doc['pdate']);
      return {
        'category': doc['category'],
        'item': doc['pname'],
        'amount': doc['totalcost'],
      };
    }).toList();

    setState(() {
      expenses = fetchedExpenses;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 선택된 날짜에 대한 총 수입과 지출 계산
    int total = expenses.fold<int>(0, (int sum, dynamic expense) {
      // 여기서 expense['amount']를 int로 캐스팅합니다.
      // expense['amount']가 항상 int임을 확신할 수 있다면, 이 방법을 사용할 수 있습니다.
      // 그렇지 않다면, 먼저 검사를 수행해야 할 수도 있습니다 (예를 들어, is int를 사용하여).
      return sum + (expense['amount'] as int);
    });

    // total 포맷
    final formattedTotal = NumberFormat('#,###').format(total.abs());

    return Scaffold(
      appBar: AppBar(
        title: Text('달력', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '  ${widget.selectedDay.day}  ',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${widget.selectedDay.year}. ${widget.selectedDay.month}',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    Spacer(),
                    Text(
                      '총합: $formattedTotal',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: total < 0 ? Colors.blue : Colors.red,),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  children: expenses.map((expense) => Column(
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
                                  expense['category'],
                                  style: TextStyle(fontSize: 13, color: Colors.grey),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  expense['item'],
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  '${NumberFormat('#,###').format(expense['amount'].abs())}원', // 절대값으로 출력
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: expense['amount'] < 0 ? Colors.blue : Colors.red, // 조건에 따른 색상 변경
                                  ),
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
