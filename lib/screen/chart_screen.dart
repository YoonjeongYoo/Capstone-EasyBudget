import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:getwidget/getwidget.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<String> _values = <String>['예산 분석', '날짜별'];
  String? _selectedValue;

  Map<String, Map<String, double>> dateData = {};
  Map<String, double> _selectedData = {}; // 선택된 데이터를 저장할 변수
  double totalBudget = 0.0;
  double totalExpense = 0.0;
  Map<String, double> expenses = {};
  Map<String, int> budgets = {};

  String selectedDate = '2023-05';
  List<String> dateOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedValue = _values[0];
    fetchDataFromFirestore(); // Firestore에서 데이터 불러오기
  }

  Future<void> fetchDataFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // BudgetAnalysis 데이터 불러오기
    DocumentSnapshot budgetAnalysisSnapshot = await firestore
        .collection('Space')
        .doc('KBpkiTfmpsg3ZI5iSpyY')
        .collection('Chart')
        .doc('BudgetAnalysis')
        .get();

    if (budgetAnalysisSnapshot.exists) {
      Map<String, dynamic> data = budgetAnalysisSnapshot.data() as Map<String, dynamic>;
      setState(() {
        expenses = Map<String, double>.from(data['expenses']);
        budgets = Map<String, int>.from(data['budgets']);
        totalExpense = expenses.values.reduce((a, b) => a + b); // totalExpense 값을 expenses 요소들의 합으로 설정
        totalBudget = budgets.values.reduce((a, b) => a + b).toDouble(); // totalBudget 값을 budgets 요소들의 합으로 설정
      });
    }

    // DatewiseData 데이터 불러오기
    QuerySnapshot datewiseDataSnapshot = await firestore
        .collection('Space')
        .doc('KBpkiTfmpsg3ZI5iSpyY')
        .collection('Chart')
        .doc('BudgetAnalysis')
        .collection('DatewiseData')
        .get();

    Map<String, Map<String, double>> tempData = {};
    List<String> tempDateOptions = [];
    for (var doc in datewiseDataSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      tempData[doc.id] = {
        '식비': data['식비'].toDouble(),
        '교통비': data['교통비'].toDouble(),
        '기타': data['기타'].toDouble(),
      };
      tempDateOptions.add(doc.id);
    }

    setState(() {
      dateData = tempData;
      dateOptions = tempDateOptions;
      if (!dateOptions.contains(selectedDate)) {
        selectedDate = dateOptions.isNotEmpty ? dateOptions[0] : '';
      }
      _selectedData = dateData[selectedDate] ?? {'식비': 0, '교통비': 0, '기타': 0};
    });
  }

  Widget _buildChart() {
    switch (_selectedValue) {
      case '예산 분석':
        String formatValue(double value) {
          if (value >= 1000000) {
            return '${(value / 1000000).toStringAsFixed(1)}M';
          } else if (value >= 1000) {
            return '${(value / 1000).toStringAsFixed(1)}K';
          } else {
            return value.toString();
          }
        }

        Color getProgressBarColor(double percentage, double threshold) {
          return percentage > threshold ? Colors.red : Colors.lightBlue;
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('총 예산: ${formatValue(totalBudget)}', style: TextStyle(fontSize: 14)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0), // 간격 추가
                    child: GFProgressBar(
                      percentage: 1.0,
                      backgroundColor: Colors.grey.shade200,
                      progressBarColor: Colors.green,
                      lineHeight: 20,
                      alignment: MainAxisAlignment.spaceBetween,
                      trailing: Text('100.0%'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('총 지출: ${formatValue(totalExpense)}', style: TextStyle(fontSize: 14)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0), // 간격 추가
                    child: GFProgressBar(
                      percentage: totalExpense / totalBudget,
                      backgroundColor: Colors.grey.shade200,
                      progressBarColor: getProgressBarColor(totalExpense / totalBudget, 0.9),
                      lineHeight: 20,
                      alignment: MainAxisAlignment.spaceBetween,
                      trailing: Text('${(totalExpense / totalBudget * 100).toStringAsFixed(1)}%'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: expenses.entries.map((entry) {
                  String categoryKey = entry.key;
                  double expense = entry.value;
                  String budgetKey = categoryKey.replaceFirst('지출', '예산');
                  double budget = budgets[budgetKey]?.toDouble() ?? 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0), // 간격 추가
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$categoryKey: ${formatValue(expense)}', style: TextStyle(fontSize: 14)),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0), // 간격 추가
                          child: GFProgressBar(
                            percentage: budget != 0 ? expense / budget : 0,
                            backgroundColor: Colors.grey.shade200,
                            progressBarColor: getProgressBarColor(budget != 0 ? expense / budget : 0, 0.8),
                            lineHeight: 20,
                            alignment: MainAxisAlignment.spaceBetween,
                            trailing: Text('${budget != 0 ? (expense / budget * 100).toStringAsFixed(1) : 0}%'),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );

      case '날짜별':
        List<FlSpot> lineSpots = List.generate(dateOptions.length, (index) {
          String selectedMonth = dateOptions[index];
          double total = dateData[selectedMonth]!.values.reduce((a, b) => a + b);
          return FlSpot(index.toDouble(), total);
        });

        String formatValue(double value) {
          if (value >= 1000000) {
            return '${(value / 1000000).toStringAsFixed(1)}M';
          } else if (value >= 1000) {
            return '${(value / 1000).toStringAsFixed(1)}K';
          } else {
            return value.toString();
          }
        }

        double calculateInterval() {
          final double maxY = lineSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
          return maxY / 5;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedDate,
                items: dateOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDate = newValue!;
                    _selectedData = dateData[selectedDate] ?? {'식비': 0, '교통비': 0, '기타': 0};
                  });
                },
              ),
              SizedBox(
                height: 300,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    sections: [
                      PieChartSectionData(
                        value: _selectedData['식비']!,
                        color: Colors.blue,
                        title: '식비',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: _selectedData['교통비']!,
                        color: Colors.green,
                        title: '교통비',
                        radius: 50,
                      ),
                      PieChartSectionData(
                        value: _selectedData['기타']!,
                        color: Colors.orange,
                        title: '기타',
                        radius: 50,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            switch (value.toInt()) {
                              case 0:
                                return Text('식비');
                              case 1:
                                return Text('교통비');
                              case 2:
                                return Text('기타');
                              default:
                                return Text('');
                            }
                          },
                          reservedSize: 40,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    barGroups: [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            toY: _selectedData['식비']!,
                            color: Colors.blue,
                          )
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            toY: _selectedData['교통비']!,
                            color: Colors.green,
                          )
                        ],
                      ),
                      BarChartGroupData(
                        x: 2,
                        barRods: [
                          BarChartRodData(
                            toY: _selectedData['기타']!,
                            color: Colors.orange,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 400,
                width: double.infinity, // 핸드폰 화면에 맞게 조정
                child: LineChart(
                  LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                        spots: lineSpots,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 4,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.3),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Colors.lightBlueAccent,
                              strokeWidth: 2,
                              strokeColor: Colors.black,
                            );
                          },
                        ),
                      ),
                    ],
                    minY: 0,
                    maxY: lineSpots.isNotEmpty
                        ? lineSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) * 1.1
                        : 1,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: calculateInterval(),
                          getTitlesWidget: (value, meta) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              space: 4.0,
                              child: Text(
                                formatValue(value),
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          },
                          reservedSize: 50,
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 && value.toInt() < dateOptions.length) {
                              // 2개 중 1개만 레이블을 표시
                              if (value.toInt() % 2 == 0) {
                                return Transform.rotate(
                                  angle: 0 * 3.1415927 / 180,
                                  child: Text(
                                    dateOptions[value.toInt()]
                                        .replaceFirst('년 ', '.')
                                        .replaceFirst('월', ''),
                                    style: TextStyle(fontSize: 10),
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }
                            return Text('');
                          },
                          reservedSize: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '시각화',
        action: [],
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownButton(
                  value: _selectedValue,
                  items: _values
                      .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ))
                      .toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedValue = value;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: _buildChart(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
