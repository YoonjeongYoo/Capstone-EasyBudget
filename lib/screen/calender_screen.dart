import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'budget_detail_screen.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, int> expenses = {};

  final Map<DateTime, List> _events = {};

  @override
  void initState() {
    super.initState();
    _fetchExpensesFromFirestore();
  }

  Future<void> _fetchExpensesFromFirestore() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Space')
        .doc('u3dYxuN5bv8BxjV6AzpF')
        .collection('Receipts')
        .get();

    final Map<DateTime, int> fetchedExpenses = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final DateTime date = (data['pdate'] as Timestamp).toDate();
      final int cost = data['totalcost'];

      final dateKey = DateTime(date.year, date.month, date.day);

      if (fetchedExpenses.containsKey(dateKey)) {
        fetchedExpenses[dateKey] = fetchedExpenses[dateKey]! + cost;
      } else {
        fetchedExpenses[dateKey] = cost;
      }
    }

    setState(() {
      expenses = fetchedExpenses;
    });
  }

  int _getExpenseForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return expenses[dateKey] ?? 0;
  }

  List _getEventsForDay(DateTime day) {
    final events = _events[day] ?? [];
    final expense = _getExpenseForDay(day);
    if (expense > 0) {
      events.add('지출: $expense원');
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '경기대학교 학생회',
        action: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: TableCalendar(
          locale: 'ko_KR',
          firstDay: DateTime.utc(2020, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          eventLoader: _getEventsForDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BudgetDetailsScreen(
                  selectedDay: selectedDay,
                ),
              ),
            );
          },
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, day, focusedDay) {
              final expense = _getExpenseForDay(day);
              Color backgroundColor;

              if (expense > 0) {
                backgroundColor = Colors.red;
              } else if (expense < 0) {
                backgroundColor = Colors.blue;
              } else {
                backgroundColor = Color(0xffffffff);
              }

              return Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: backgroundColor == Colors.white ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
