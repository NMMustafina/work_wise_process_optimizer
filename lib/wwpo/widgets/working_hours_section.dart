import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/add_working_hours_screen.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/edit_working_hours_screen.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/models/working_hours_model.dart';

import '../../generated/assets.dart';

class WorkingHoursSection extends StatelessWidget {
  const WorkingHoursSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: GetIt.I.get<Box<WorkingHoursModel>>().listenable(),
      builder: (context, Box<WorkingHoursModel> box, _) {
        final now = DateTime.now();
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekData = List.generate(7, (i) {
          final day = weekStart.add(Duration(days: i));
          return box.values
              .where((e) =>
                  e.date.year == day.year &&
                  e.date.month == day.month &&
                  e.date.day == day.day)
              .fold<double>(0, (sum, e) => sum + e.hours);
        });

        final totalWeek = weekData.fold(0.0, (sum, e) => sum + e);
        final maxValue = weekData.fold(0.0, (a, b) => a > b ? a : b);
        final safeMaxY = maxValue <= 12 ? 14 : ((maxValue / 2).ceil() * 2 + 2);

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF343436),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Work hours tracker',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Total for the week: ',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${totalWeek % 1 == 0 ? totalWeek.toInt() : totalWeek.toStringAsFixed(1)} hours',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showTrackerActions(context),
                    child: Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFF48484A),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: SvgPicture.asset(
                        Assets.iconsSett,
                        width: 24.w,
                        height: 24.h,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              AspectRatio(
                aspectRatio: 1.7,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: safeMaxY.toDouble(),
                    backgroundColor: const Color(0xFF48484A),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 2,
                      getDrawingHorizontalLine: (value) {
                        return const FlLine(
                          color: Colors.grey,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 32,
                          getTitlesWidget: (value, _) {
                            const days = [
                              'Mon',
                              'Tue',
                              'Wed',
                              'Thu',
                              'Fri',
                              'Sat',
                              'Sun'
                            ];
                            return Text(
                              days[value.toInt()],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 2,
                          reservedSize: 40,
                          getTitlesWidget: (value, _) {
                            if (maxValue <= 12) {
                              if ([2, 4, 6, 8, 10].contains(value.toInt())) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.sp),
                                );
                              }
                              if (value.toInt() == 12) {
                                return Text(
                                  '>12',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12.sp),
                                );
                              }
                              return const SizedBox.shrink();
                            } else {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12.sp),
                              );
                            }
                          },
                        ),
                      ),
                      rightTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles:
                          const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    barGroups: List.generate(7, (i) {
                      return BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: weekData[i],
                            width: 20,
                            color: const Color(0xFFB6E344),
                            borderRadius: BorderRadius.zero,
                          )
                        ],
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AddWorkingHoursScreen()),
                  );
                },
                child: Container(
                  height: 52.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF57BAE1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Add working hours',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTrackerActions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditWorkingHoursScreen(),
                ),
              );
            },
            child: const Text('Edit tracker'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _showClearConfirmation(context);
            },
            child: const Text('Clear tracker'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Clear data'),
        content: const Text("Are you sure you want to reset this week's data?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.of(context).pop();
              final box = GetIt.I.get<Box<WorkingHoursModel>>();
              final now = DateTime.now();
              final weekStart = now.subtract(Duration(days: now.weekday - 1));
              final weekEnd = weekStart.add(const Duration(days: 7));

              final keysToDelete = <dynamic>[];

              for (int i = 0; i < box.length; i++) {
                final item = box.getAt(i);
                if (item == null) continue;

                final itemDate =
                    DateTime(item.date.year, item.date.month, item.date.day);
                final start =
                    DateTime(weekStart.year, weekStart.month, weekStart.day);
                final end = DateTime(weekEnd.year, weekEnd.month, weekEnd.day);

                if (!itemDate.isBefore(start) && itemDate.isBefore(end)) {
                  keysToDelete.add(box.keyAt(i));
                }
              }

              for (final key in keysToDelete) {
                await box.delete(key);
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
