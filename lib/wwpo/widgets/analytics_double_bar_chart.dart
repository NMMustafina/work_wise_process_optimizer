import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../screens/models/incoomm_model.dart';
import '../screens/models/working_hours_model.dart';

class AnalyticsDoubleBarChart extends StatelessWidget {
  final DateTime selectedMonth;

  const AnalyticsDoubleBarChart({super.key, required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    final incomeBox = GetIt.I.get<Box<IncoommModel>>();
    final hoursBox = GetIt.I.get<Box<WorkingHoursModel>>();

    final weeks = _splitIntoWeeks(selectedMonth);
    final incomeData = List<double>.filled(weeks.length, 0);
    final hoursData = List<double>.filled(weeks.length, 0);

    for (int i = 0; i < weeks.length; i++) {
      final weekStart = weeks[i].start;
      final weekEnd = weeks[i].end;

      for (final income in incomeBox.values) {
        if (_isInRange(income.daatee, weekStart, weekEnd)) {
          incomeData[i] += income.amounntt;
        }
      }

      for (final hours in hoursBox.values) {
        if (_isInRange(hours.date, weekStart, weekEnd)) {
          hoursData[i] += hours.hours;
        }
      }
    }

    final maxY = [
      ...incomeData,
      ...hoursData,
    ].reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF343436),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profit per hour',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 12.sp),
              children: [
                TextSpan(
                  text: 'Total time: ',
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                TextSpan(
                  text: hoursData.fold(0.0, (sum, e) => sum + e) == 0
                      ? 'None'
                      : '${hoursData.fold(0.0, (sum, e) => sum + e).toStringAsFixed(0)} hours',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 12.sp),
              children: [
                TextSpan(
                  text: 'Total money: ',
                  style: TextStyle(color: Colors.white.withOpacity(0.6)),
                ),
                TextSpan(
                  text: incomeData.fold(0.0, (sum, e) => sum + e) == 0
                      ? 'None'
                      : '\$ ${incomeData.fold(0.0, (sum, e) => sum + e).toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                maxY: maxY == 0 ? 10 : maxY + 10,
                backgroundColor: const Color(0xFF48484A),
                barGroups: List.generate(weeks.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: hoursData[i],
                        width: 20,
                        color: const Color(0xFFFF4629),
                        borderRadius: BorderRadius.zero,
                      ),
                      BarChartRodData(
                        toY: incomeData[i],
                        width: 20,
                        color: const Color(0xFFA7C960),
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  );
                }),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, _) {
                        const weekLabels = ['W1', 'W2', 'W3', 'W4', 'W5'];
                        if (value.toInt() >= weekLabels.length) {
                          return const SizedBox();
                        }
                        return Text(
                          weekLabels[value.toInt()],
                          style:
                              TextStyle(color: Colors.white, fontSize: 10.sp),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: maxY == 0 ? 1 : (maxY / 4).ceilToDouble(),
                      getTitlesWidget: (value, _) => SizedBox(
                        width: 30.w,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value.toInt().toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 10.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _legend(
                        color: const Color(0xFFA7C960),
                        label: incomeData.every((e) => e == 0)
                            ? 'Average income per week: none'
                            : 'Average income per week: \$ ${_avg(incomeData)}',
                      ),
                      SizedBox(height: 4.h),
                      _legend(
                        color: const Color(0xFFFF4629),
                        label: hoursData.every((e) => e == 0)
                            ? 'Average work time per week: none'
                            : 'Average work time per week: ${_avg(hoursData)} hours',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _avg(List<double> values) {
    if (values.isEmpty) return '0';
    final avg = values.fold(0.0, (sum, e) => sum + e) / values.length;
    return avg.round().toString();
  }

  bool _isInRange(DateTime d, DateTime start, DateTime end) {
    final date = DateTime(d.year, d.month, d.day);
    return !date.isBefore(start) && !date.isAfter(end);
  }

  List<_WeekRange> _splitIntoWeeks(DateTime month) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final weeks = <_WeekRange>[];
    int start = 1;
    while (start <= daysInMonth) {
      final end = (start + 6 <= daysInMonth) ? start + 6 : daysInMonth;
      weeks.add(_WeekRange(
        DateTime(month.year, month.month, start),
        DateTime(month.year, month.month, end),
      ));
      start += 7;
    }
    return weeks;
  }

  Widget _legend({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 14.w,
          height: 14.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          margin: EdgeInsets.only(right: 8.w),
        ),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _WeekRange {
  final DateTime start;
  final DateTime end;

  _WeekRange(this.start, this.end);
}
