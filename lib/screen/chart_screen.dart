import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<String> _values = <String>['예산 분석', '날짜별'];
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = _values[0];
  }

  Widget _buildChart() {
    switch (_selectedValue) {
      case '예산 분석':
        return BarChart(
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
                        return Text('January');
                      case 1:
                        return Text('February');
                      case 2:
                        return Text('March');
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
                    toY: 8,
                    color: Colors.lightBlue,
                  )
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: 10,
                    color: Colors.lightGreen,
                  )
                ],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                    toY: 14,
                    color: Colors.pinkAccent,
                  )
                ],
              ),
              // 추가 BarChartGroupData 객체는 필요에 따라 추가할 수 있습니다.
            ],
          ),
        );


      case '날짜별':
        return Column(
          children: [
            Expanded(
              flex: 1, // PieChart와 BarChart의 크기 비율을 조정할 수 있습니다.
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2, // 섹션 사이의 간격
                  centerSpaceRadius: 40, // 중심에서의 공간 반경
                  sections: [
                    PieChartSectionData(
                      value: 30, // 첫 번째 데이터의 값
                      color: Colors.blue,
                      title: '식비', // 첫 번째 데이터의 타이틀
                      radius: 50, // 반경
                    ),
                    PieChartSectionData(
                      value: 25, // 두 번째 데이터의 값
                      color: Colors.green,
                      title: '교통비', // 두 번째 데이터의 타이틀
                      radius: 50, // 반경
                    ),
                    PieChartSectionData(
                      value: 45, // 세 번째 데이터의 값
                      color: Colors.orange,
                      title: '기타', // 세 번째 데이터의 타이틀
                      radius: 50, // 반경
                    ),
                    // 필요에 따라 더 많은 sections를 추가할 수 있습니다.
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1, // PieChart와 BarChart의 크기 비율을 조정할 수 있습니다.
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
                          toY: 30, // 식비에 해당하는 값
                          color: Colors.blue,
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 25, // 교통비에 해당하는 값
                          color: Colors.green,
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 45, // 기타에 해당하는 값
                          color: Colors.orange,
                        )
                      ],
                    ),
                    // 필요에 따라 더 많은 BarChartGroupData 객체를 추가할 수 있습니다.
                  ],
                ),
              ),
            ),
          ],
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
