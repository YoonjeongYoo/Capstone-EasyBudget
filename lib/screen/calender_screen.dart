import 'package:flutter/material.dart';
import '../layout/appbar_layout.dart';
import '../layout/default_layout.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'budget_detail_screen.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
// 여기에 예시 데이터와 함수
  Map<DateTime, int> expenses = {
    DateTime(2024, 5, 20): 50000, // 2024년 5월 20일의 지출
    DateTime(2024, 6, 20): 50000,
  };

  Map<DateTime, int> incomes = {
    DateTime(2024, 5, 21): 30000, // 2024년 5월 21일의 수입
  };

  int _getExpenseForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return expenses[dateKey] ?? 0;
  }

  int _getIncomeForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return incomes[dateKey] ?? 0;
  }

  DateTime? _selectedDay;

  final Map<DateTime, List> _events = {
    DateTime.now().subtract(Duration(days: 1)): ['5,000원'],
    DateTime.now(): ['10,000원'],
    DateTime.now().add(Duration(days: 1)): ['15,000원'],
  };

  List _getEventsForDay(DateTime day) {
    // 기존 이벤트 로딩 로직
    final events = _events[day] ?? [];

    // 지출 정보 추가
    final expense = _getExpenseForDay(day);
    if (expense > 0) {
      events.add('지출: $expense원');
    }

    // 수입 정보 추가
    final income = _getIncomeForDay(day);
    if (income > 0) {
      events.add('수입: $income원');
    }

    return events;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '캘린더',
        action: [],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView( // SingleChildScrollView 추가
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TableCalendar(
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
                        events: _getEventsForDay(selectedDay),
                      ),
                    ),
                  );
                },
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    final expense =
                    _getExpenseForDay(day); // 가정: 이 메소드는 특정 날짜의 지출을 반환합니다.
                    final income =
                    _getIncomeForDay(day); // 가정: 이 메소드는 특정 날짜의 수입을 반환합니다.

                    if (expense > income) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    } else if (income > expense) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${day.day}',
                            style: TextStyle(color: Colors.white),
                          ),

                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
