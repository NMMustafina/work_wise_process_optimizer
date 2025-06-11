import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../screens/models/expense_model.dart';
import '../screens/models/incoomm_model.dart';

class AnalyticsBarChart extends StatelessWidget {
  final DateTime selectedMonth;

  const AnalyticsBarChart({super.key, required this.selectedMonth});

  @override
  Widget build(BuildContext context) {
    final Box<IncoommModel> incomeBox = GetIt.I.get();
    final Box<ExpenseModel> expenseBox = GetIt.I.get();

    final income = incomeBox.values
        .where((e) =>
            e.daatee.year == selectedMonth.year &&
            e.daatee.month == selectedMonth.month)
        .fold<double>(0, (sum, e) => sum + e.amounntt);

    final expenses = expenseBox.values
        .where((e) =>
            e.date.year == selectedMonth.year &&
            e.date.month == selectedMonth.month)
        .fold<double>(0, (sum, e) => sum + e.amount);

    final total = income + expenses;
    final incomePercent = total > 0 ? income / total * 100 : 0;
    final expensePercent = total > 0 ? expenses / total * 100 : 0;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF343436),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Expenses and income',
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
          ),
          SizedBox(height: 12.h),
          AspectRatio(
            aspectRatio: 1.3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 60.r,
                    sections: (income == 0 && expenses == 0)
                        ? [
                            PieChartSectionData(
                              color: const Color(0xFF5A5A5C),
                              value: 1,
                              title: '',
                              radius: 60.r,
                            ),
                          ]
                        : [
                            PieChartSectionData(
                              color: const Color(0xFFA7C960),
                              value: income,
                              title: '',
                              radius: 60.r,
                            ),
                            PieChartSectionData(
                              color: const Color(0xFFFF4629),
                              value: expenses,
                              title: '',
                              radius: 60.r,
                            ),
                          ],
                  ),
                ),
                SizedBox(
                  width: 80.w,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$ ${income.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: const Color(0xFFA7C960),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '\$ ${expenses.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: const Color(0xFFFF4629),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildLegendDot(
                'Income',
                const Color(0xFFA7C960),
                incomePercent.toDouble(),
              ),
              SizedBox(width: 16.h),
              _buildLegendDot(
                'Expenses',
                const Color(0xFFFF4629),
                expensePercent.toDouble(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(String label, Color color, double percent) {
    return Row(
      children: [
        Container(
            width: 14.w,
            height: 14.h,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: 8.w),
        Text(
          '$label: ${percent.toStringAsFixed(0)}%',
          style: TextStyle(color: Colors.white, fontSize: 12.sp),
        ),
      ],
    );
  }
}
