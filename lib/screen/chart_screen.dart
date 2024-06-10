import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:getwidget/getwidget.dart';
import 'package:intl/intl.dart';

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
  Map<String, double> budgets = {};

  String selectedDate = '2023-07';
  List<String> dateOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedValue = _values[0];
    fetchDataFromFirestore(); // Firestore에서 데이터 불러오기
  }

  Future<void> fetchDataFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      // BudgetAnalysis 데이터 불러오기
      DocumentSnapshot budgetAnalysisSnapshot = await firestore
          .collection('Space')
          .doc('KBpkiTfmpsg3ZI5iSpyY')
          .collection('Chart')
          .doc('BudgetAnalysis')
          .get();

      if (budgetAnalysisSnapshot.exists) {
        Map<String, dynamic> data =
        budgetAnalysisSnapshot.data() as Map<String, dynamic>;
        setState(() {
          expenses = {
            '식비 지출': 0.0,
            '숙소 지출': 0.0,
            '기타 지출': 0.0,
            '도서 지출': 0.0,
            '교통 지출': 0.0,
          };
          totalExpense = 0.0;
          budgets = Map<String, double>.from(
              data['budgets']?.map((k, v) => MapEntry(k, v.toDouble())) ?? {});
          totalBudget =
          budgets.isNotEmpty ? budgets.values.reduce((a, b) => a + b) : 0.0;
          print('totalBudget: $totalBudget');
        });
      } else {
        print('BudgetAnalysis document does not exist.');
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
        if (doc.id != '기타') {
          print('Document ID: ${doc.id}, Data: ${doc.data()}'); // 디버깅용
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          tempData[doc.id] = {
            '식비 지출': data['식비 지출']?.toDouble() ?? 0.0,
            '숙소 지출': data['숙소 지출']?.toDouble() ?? 0.0,
            '기타 지출': data['기타 지출']?.toDouble() ?? 0.0,
            '도서 지출': data['도서 지출']?.toDouble() ?? 0.0,
            '교통 지출': data['교통 지출']?.toDouble() ?? 0.0,
          };
          tempDateOptions.add(doc.id);

          // expenses 필드 업데이트
          expenses['식비 지출'] =
              (expenses['식비 지출'] ?? 0.0) + (data['식비 지출']?.toDouble() ?? 0.0);
          expenses['숙소 지출'] =
              (expenses['숙소 지출'] ?? 0.0) + (data['숙소 지출']?.toDouble() ?? 0.0);
          expenses['기타 지출'] =
              (expenses['기타 지출'] ?? 0.0) + (data['기타 지출']?.toDouble() ?? 0.0);
          expenses['도서 지출'] =
              (expenses['도서 지출'] ?? 0.0) + (data['도서 지출']?.toDouble() ?? 0.0);
          expenses['교통 지출'] =
              (expenses['교통 지출'] ?? 0.0) + (data['교통 지출']?.toDouble() ?? 0.0);
        }
      }

      // Receipt 데이터 불러오기 (processed 필드가 false인 경우만)
      QuerySnapshot receiptSnapshot = await firestore
          .collection('Space')
          .doc('KBpkiTfmpsg3ZI5iSpyY')
          .collection('Receipt')
          .where('processed', isEqualTo: false)
          .get();

      print('Receipt documents found: ${receiptSnapshot.docs.length}');
      for (var doc in receiptSnapshot.docs) {
        print('Receipt Document ID: ${doc.id}, Data: ${doc.data()}'); // 디버깅용
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Date 필드의 Timestamp를 DateTime으로 변환
        Timestamp timestamp = data['date'];
        DateTime dateTime = timestamp.toDate();
        String formattedDate =
            "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}";

        // category 필드를 확인하고 총 지출을 분류
        String category = data['category'];
        double totalCost = (data['totalCost'] as num).toDouble();

        if (!tempData.containsKey(formattedDate)) {
          tempData[formattedDate] = {
            '식비 지출': 0.0,
            '숙소 지출': 0.0,
            '기타 지출': 0.0,
            '도서 지출': 0.0,
            '교통 지출': 0.0,
          };
        }

        if (category == '식비') {
          tempData[formattedDate]!['식비 지출'] =
              tempData[formattedDate]!['식비 지출']! + totalCost;
          expenses['식비 지출'] = (expenses['식비 지출'] ?? 0.0) + totalCost;
        } else if (category == '숙소비') {
          tempData[formattedDate]!['숙소 지출'] =
              tempData[formattedDate]!['숙소 지출']! + totalCost;
          expenses['숙소 지출'] = (expenses['숙소 지출'] ?? 0.0) + totalCost;
        } else if (category == '도서') {
          tempData[formattedDate]!['도서 지출'] =
              tempData[formattedDate]!['도서 지출']! + totalCost;
          expenses['도서 지출'] = (expenses['도서 지출'] ?? 0.0) + totalCost;
        } else if (category == '교통비') {
          tempData[formattedDate]!['교통 지출'] =
              tempData[formattedDate]!['교통 지출']! + totalCost;
          expenses['교통 지출'] = (expenses['교통 지출'] ?? 0.0) + totalCost;
        } else {
          tempData[formattedDate]!['기타 지출'] =
              tempData[formattedDate]!['기타 지출']! + totalCost;
          expenses['기타 지출'] = (expenses['기타 지출'] ?? 0.0) + totalCost;
        }

        if (!tempDateOptions.contains(formattedDate)) {
          tempDateOptions.add(formattedDate);
        }

        // Receipt 문서 업데이트 (processed 필드를 true로 변경)
        await firestore
            .collection('Space')
            .doc('KBpkiTfmpsg3ZI5iSpyY')
            .collection('Receipt')
            .doc(doc.id)
            .update({'processed': true});
      }

      setState(() {
        dateData = tempData;
        dateOptions = tempDateOptions;
        if (!dateOptions.contains(selectedDate)) {
          selectedDate = dateOptions.isNotEmpty ? dateOptions[0] : '';
        }
        _selectedData = dateData[selectedDate] ??
            {
              '식비 지출': 0.0,
              '숙소 지출': 0.0,
              '기타 지출': 0.0,
              '도서 지출': 0.0,
              '교통 지출': 0.0,
            };
        print('dateData: $dateData');
        totalExpense = expenses.values.reduce((a, b) => a + b);
      });

      // 업데이트된 데이터를 Firestore에 저장
      await firestore
          .collection('Space')
          .doc('KBpkiTfmpsg3ZI5iSpyY')
          .collection('Chart')
          .doc('BudgetAnalysis')
          .set({'expenses': expenses}, SetOptions(merge: true));

      for (var entry in dateData.entries) {
        await firestore
            .collection('Space')
            .doc('KBpkiTfmpsg3ZI5iSpyY')
            .collection('Chart')
            .doc('BudgetAnalysis')
            .collection('DatewiseData')
            .doc(entry.key)
            .set(entry.value, SetOptions(merge: true));
      }
    } catch (e) {
      print('Error fetching data from Firestore: $e');
    }
  }

  String formatValue(double value) {
    final formatter = NumberFormat('#,###');
    return '${formatter.format(value)}원';
  }

  String formatShortValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}백만';
    } else if (value >= 10000) {
      return '${(value / 10000).toStringAsFixed(1)}만';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}천';
    } else {
      return '${value.toString()}';
    }
  }

  Widget _buildChart() {
    switch (_selectedValue) {
      case '예산 분석':
        Color getProgressBarColor(double percentage, double threshold) {
          return percentage >= threshold ? Colors.red : Colors.lightBlue;
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('총 예산: ${formatValue(totalBudget)}',
                      style: TextStyle(fontSize: 14)),
                  if (totalBudget > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
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
                  Text('총 지출: ${formatValue(totalExpense)}',
                      style: TextStyle(fontSize: 14)),
                  if (totalBudget > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: GFProgressBar(
                        percentage: totalExpense / totalBudget,
                        backgroundColor: Colors.grey.shade200,
                        progressBarColor: getProgressBarColor(
                            totalExpense / totalBudget, 0.9),
                        lineHeight: 20,
                        alignment: MainAxisAlignment.spaceBetween,
                        trailing: Text(
                            '${(totalExpense / totalBudget * 100).toStringAsFixed(1)}%'),
                      ),
                    ),
                ],
              ),
            ),
            Divider(thickness: 3, color: Colors.black12), // Divider 추가
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: expenses.entries.map((entry) {
                  String categoryKey = entry.key;
                  double expense = entry.value;
                  String budgetKey = categoryKey.replaceFirst('지출', '예산');
                  double budget = budgets[budgetKey] ?? 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$categoryKey: ${formatValue(expense)}',
                            style: TextStyle(fontSize: 14)),
                        if (budget > 0)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: GFProgressBar(
                              percentage: expense / budget,
                              backgroundColor: Colors.grey.shade200,
                              progressBarColor:
                              getProgressBarColor(expense / budget, 0.9),
                              lineHeight: 20,
                              alignment: MainAxisAlignment.spaceBetween,
                              trailing: Text(
                                  '${(expense / budget * 100).toStringAsFixed(1)}%'),
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
        print('selectedDate: $selectedDate');
        print('_selectedData: $_selectedData');
        print('dateData: $dateData');

        // 2024-06을 기준으로 이전 12개월 데이터를 선택합니다.
        List<String> chartDateOptions = [];
        DateTime currentDate = DateTime(2024, 6);
        for (int i = 0; i < 12; i++) {
          DateTime date = DateTime(currentDate.year, currentDate.month - i);
          String formattedDate =
              "${date.year}-${date.month.toString().padLeft(2, '0')}";
          if (dateData.containsKey(formattedDate)) {
            chartDateOptions.add(formattedDate);
          }
        }
        chartDateOptions =
            chartDateOptions.reversed.toList(); // 최신 날짜가 가장 오른쪽으로 가도록 정렬

        List<FlSpot> lineSpots =
        List.generate(chartDateOptions.length, (index) {
          String selectedMonth = chartDateOptions[index];
          double total =
              dateData[selectedMonth]?.values.reduce((a, b) => a + b) ?? 0.0;
          return FlSpot(index.toDouble(), total);
        });

        double calculateInterval() {
          final double maxY =
          lineSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
          return (maxY / 5) > 0 ? maxY / 5 : 1;
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedDate,
                items: dateOptions
                    .where((value) => value != '기타')
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDate = newValue!;
                    _selectedData = dateData[selectedDate] ??
                        {
                          '식비 지출': 0.0,
                          '숙소 지출': 0.0,
                          '기타 지출': 0.0,
                          '도서 지출': 0.0,
                          '교통 지출': 0.0,
                        };
                  });
                },
              ),
              if (selectedDate != '기타') ...[
                SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          value: _selectedData['식비 지출']!,
                          color: Colors.blue,
                          title: '식비',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: _selectedData['숙소 지출']!,
                          color: Colors.green,
                          title: '숙소',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: _selectedData['기타 지출']!,
                          color: Colors.orange,
                          title: '기타',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: _selectedData['도서 지출']!,
                          color: Colors.purple,
                          title: '도서',
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: _selectedData['교통 지출']!,
                          color: Colors.red,
                          title: '교통',
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
                                  return Text('숙소');
                                case 2:
                                  return Text('도서');
                                case 3:
                                  return Text('교통');
                                case 4:
                                  return Text('기타');
                                default:
                                  return Text('');
                              }
                            },

                            reservedSize: 40,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              final String text = formatShortValue(value);
                              if (text ==
                                  formatShortValue(lineSpots
                                      .map((spot) => spot.y)
                                      .reduce((a, b) => a > b ? a : b))) {
                                return const SizedBox(); // 최대값을 숨김
                              }
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 4.0,
                                child: Text(
                                  text,
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
                      ),
                      barGroups: [
                        BarChartGroupData(
                          x: 0,
                          barRods: [
                            BarChartRodData(
                              toY: _selectedData['식비 지출']!,
                              color: Colors.blue,
                            )
                          ],
                        ),
                        BarChartGroupData(
                          x: 1,
                          barRods: [
                            BarChartRodData(
                              toY: _selectedData['숙소 지출']!,
                              color: Colors.green,
                            )
                          ],
                        ),
                        BarChartGroupData(
                          x: 2,
                          barRods: [
                            BarChartRodData(
                              toY: _selectedData['도서 지출']!,
                              color: Colors.purple,
                            )
                          ],
                        ),
                        BarChartGroupData(
                          x: 3,
                          barRods: [
                            BarChartRodData(
                              toY: _selectedData['교통 지출']!,
                              color: Colors.red,
                            )
                          ],
                        ),
                        BarChartGroupData(
                          x: 4,
                          barRods: [
                            BarChartRodData(
                              toY: _selectedData['기타 지출']!,
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
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30.0), // 오른쪽으로 30 정도 이동
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
                            ? lineSpots
                            .map((spot) => spot.y)
                            .reduce((a, b) => a > b ? a : b) *
                            1.1
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
                                    formatShortValue(value),
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
                                if (value.toInt() >= 0 &&
                                    value.toInt() < chartDateOptions.length) {
                                  if (value.toInt() % 2 == 0 ||
                                      value.toInt() == chartDateOptions.length - 1) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: value.toInt() ==
                                              chartDateOptions.length - 1
                                              ? 15.0  // Increase this value to shift the last label left
                                              : 0.0),
                                      child: Text(
                                        chartDateOptions[value.toInt()]
                                            .substring(2), // '23-07' 형식으로 표기
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    );
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
                ),
              ],
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
        back: true,
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
