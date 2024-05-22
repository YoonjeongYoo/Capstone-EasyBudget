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

  /// 날짜별 데이터 저장
  final Map<String, Map<String, double>> dateData = {
    '2023년 5월': {'식비': 300000, '교통비': 150000, '기타': 450000},
    '2023년 6월': {'식비': 400000, '교통비': 250000, '기타': 500000},
    '2023년 7월': {'식비': 250000, '교통비': 270000, '기타': 330000},
    '2023년 8월': {'식비': 173823, '교통비': 217364, '기타': 325870},
    '2023년 9월': {'식비': 483723, '교통비': 432412, '기타': 265515},
    '2023년 10월': {'식비': 111111, '교통비': 222222, '기타': 324442},
    '2023년 11월': {'식비': 398321, '교통비': 178725, '기타': 744453},
    '2023년 12월': {'식비': 225381, '교통비': 330842, '기타': 473823},
    '2024년 1월': {'식비': 123748, '교통비': 59324, '기타': 403923},
    '2024년 2월': {'식비': 878735, '교통비': 546462, '기타': 231453},
    '2024년 3월': {'식비': 324561, '교통비': 338963, '기타': 430982},
    '2024년 4월': {'식비': 48213, '교통비': 29821, '기타': 56976},
  };

  /// 드롭다운 메뉴의 현재 선택 값
  String selectedDate = '2023년 5월';

  Map<String, double> _selectedData = {}; // 선택된 데이터를 저장할 변수

  @override
  void initState() {
    super.initState();
    _selectedValue = _values[0];
    _selectedData = dateData[selectedDate]!; // 초기 선택 데이터 설정
  }

  Widget _buildChart() {
    switch (_selectedValue) {
      case '예산 분석':
        Map<String, double> expenditureMap = {
          '식비 지출': 120000,
          '숙소 지출': 500000,
          '운영 지출': 1200000,
        };
        Map<String, int> budgetMap = {
          '식비 예산': 300000,
          '숙소 예산': 500000,
          '운영 예산': 1200000,
        };
        // '총 예산'을 '예산 목록'의 합으로 계산
        double totalBudget = budgetMap.values.reduce((a, b) => a + b).toDouble();
        double totalExpense = expenditureMap.values.reduce((a, b) => a + b);

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
                children: expenditureMap.entries.map((entry) {
                  String categoryKey = entry.key;
                  double expense = entry.value;
                  String budgetKey = categoryKey.replaceFirst('지출', '예산');
                  double budget = budgetMap[budgetKey]!.toDouble();

                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0), // 간격 추가
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$categoryKey: ${formatValue(expense)}', style: TextStyle(fontSize: 14)),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0), // 간격 추가
                          child: GFProgressBar(
                            percentage: expense / budget,
                            backgroundColor: Colors.grey.shade200,
                            progressBarColor: getProgressBarColor(expense / budget, 0.8),
                            lineHeight: 20,
                            alignment: MainAxisAlignment.spaceBetween,
                            trailing: Text('${(expense / budget * 100).toStringAsFixed(1)}%'),
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
      // 날짜 선택을 위한 드롭다운 메뉴 항목들 생성
        List<String> dateOptions = List.generate(12, (index) {
          int year = 2023;
          int month = 5 + index;
          if (month > 12) {
            year += month ~/ 12;
            month %= 12;
          }
          return '${year}년 ${month}월';
        });

        // x축의 날짜와 y축의 총합 값 연동
        List<FlSpot> lineSpots = List.generate(dateOptions.length, (index) {
          String selectedMonth = dateOptions[index];
          double total =
          dateData[selectedMonth]!.values.reduce((a, b) => a + b);
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

        // y축 라벨 간격을 계산하는 함수
        double calculateInterval() {
          final double maxY =
          lineSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
          return maxY / 5; // 최대값을 5등분하여 간격을 설정 (필요에 따라 조정 가능)
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              DropdownButton<String>(
                value: selectedDate,
                items:
                dateOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDate = newValue!;
                    _selectedData = dateData[selectedDate]!; // 선택된 월의 데이터를 업데이트
                  });
                },
              ),
              SizedBox(
                height: 300, // 크기를 늘림
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
                height: 300, // 크기를 늘림
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
                height: 400, // 크기를 늘림
                width: 1500,
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
                              radius: 4, // 점의 크기
                              color: Colors.lightBlueAccent, // 점의 색상
                              strokeWidth: 2,
                              strokeColor: Colors.black, // 점의 테두리 색상
                            );
                          },
                        ),
                      ),
                    ],
                    minY: 0, // y축의 최소값 설정
                    maxY: lineSpots
                        .map((spot) => spot.y)
                        .reduce((a, b) => a > b ? a : b) *
                        1.1, // y축의 최대값 설정 (최대값의 1.1배)
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: calculateInterval(), // 적절한 간격 계산 함수 사용
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
                          reservedSize: 50, // y축 라벨 공간 확보
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
                          interval: 1, // x축 값 간격을 조정하기 위해 추가
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() < dateOptions.length) {
                              return Text(dateOptions[value.toInt()]
                                  .replaceFirst('년 ', '.')
                                  .replaceFirst('월', ''));
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
        return Container(); // 기본적으로 아무것도 표시하지 않음
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
                child: _buildChart(), // 차트 위젯을 동적으로 생성하는 함수 호출
              ),
            ),
          ],
        ),
      ),
    );
  }
}