import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

import '../screens/models/task_model.dart';

class CalendarViewTab extends StatelessWidget {
  final Box<TaskModel> box;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final void Function(DateTime, DateTime) onDaySelected;
  final void Function(DateTime) onPageChanged;

  const CalendarViewTab({
    super.key,
    required this.box,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  List<TaskModel> _getTasksForDay(DateTime day) {
    return box.values
        .where((t) =>
            t.date.year == day.year &&
            t.date.month == day.month &&
            t.date.day == day.day)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
          color: const Color(0xFF1C1C1E),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () => onPageChanged(
                  DateTime(focusedDay.year, focusedDay.month - 1),
                ),
              ),
              Text(
                '${_monthName(focusedDay.month)} ${focusedDay.year}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () => onPageChanged(
                  DateTime(focusedDay.year, focusedDay.month + 1),
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF343436),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  _WeekdayCell('Mon'),
                  _WeekdayCell('Tue'),
                  _WeekdayCell('Wed'),
                  _WeekdayCell('Thu'),
                  _WeekdayCell('Fri'),
                  _WeekdayCell('Sat'),
                  _WeekdayCell('Sun'),
                ],
              ),
              TableCalendar<TaskModel>(
                focusedDay: focusedDay,
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2030),
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) =>
                    selectedDay != null && isSameDay(selectedDay, day),
                onDaySelected: onDaySelected,
                eventLoader: _getTasksForDay,
                headerVisible: false,
                daysOfWeekVisible: false,
                calendarStyle: const CalendarStyle(
                  isTodayHighlighted: false,
                  cellMargin: EdgeInsets.all(1),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: _buildCell,
                  outsideBuilder: _buildCell,
                  todayBuilder: _buildCell,
                  selectedBuilder: _buildSelectedCell,
                  markerBuilder: (context, date, events) {
                    final dayTasks = _getTasksForDay(date);
                    if (dayTasks.isEmpty) return const SizedBox.shrink();
                    return Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 4.h, right: 4.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: dayTasks
                              .take(3)
                              .map(
                                (task) => Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 1.w),
                                  child: Container(
                                    width: 10.w,
                                    height: 10.w,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: task.priority == 'High'
                                            ? const Color(0xFFFF4629)
                                            : task.priority == 'Medium'
                                                ? const Color(0xFFE7C91F)
                                                : const Color(0xFFA7C960)),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCell(BuildContext context, DateTime day, DateTime focusedDay) {
    final isWeekend =
        day.weekday == DateTime.saturday || day.weekday == DateTime.sunday;
    final isOutside = day.month != focusedDay.month;
    final isToday = isSameDay(day, DateTime.now());

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1C1C1E), width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          fontSize: 14.sp,
          color: isOutside
              ? Colors.white.withOpacity(0.4)
              : isToday
                  ? const Color(0xFF57BAE1)
                  : isWeekend
                      ? const Color(0xFFCC412C)
                      : Colors.white,
        ),
      ),
    );
  }

  Widget _buildSelectedCell(
      BuildContext context, DateTime day, DateTime focusedDay) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '${day.day}',
        style: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xFF4C45D4),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month];
  }
}

class _WeekdayCell extends StatelessWidget {
  final String label;

  const _WeekdayCell(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1C1C1E), width: 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
