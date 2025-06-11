import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/settings_screen.dart';

import '../screens/models/task_model.dart';
import '../widgets/all_tasks_tab.dart';
import '../widgets/calendar_view_tab.dart';
import 'add_edit_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showAllTasks = false;

  @override
  void initState() {
    super.initState();
  }

  List<TaskModel> _getTasksForDay(Box<TaskModel> box, DateTime day) {
    return box.values
        .where((t) =>
            t.date.year == day.year &&
            t.date.month == day.month &&
            t.date.day == day.day)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Task calendar',
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/sett.svg',
              width: 24.w,
              height: 24.h,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<TaskModel>>(
        valueListenable: GetIt.I.get<Box<TaskModel>>().listenable(),
        builder: (context, box, _) {
          final selectedTasks = _selectedDay != null
              ? _getTasksForDay(box, _selectedDay!)
              : <TaskModel>[];

          final allTasks = box.values.toList();

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showAllTasks = false),
                        child: Container(
                          height: 56.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: !_showAllTasks
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: !_showAllTasks
                                  ? const Color(0xFF57BAE1)
                                  : Colors.white,
                            ),
                          ),
                          child: Text('Calendar',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.sp)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showAllTasks = true),
                        child: Container(
                          height: 56.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _showAllTasks
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: _showAllTasks
                                  ? const Color(0xFF57BAE1)
                                  : Colors.white,
                            ),
                          ),
                          child: Text('All tasks',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.sp)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: _showAllTasks
                        ? AllTasksTab(tasks: allTasks)
                        : CalendarViewTab(
                            box: box,
                            focusedDay: _focusedDay,
                            selectedDay: _selectedDay,
                            onDaySelected: (selected, focused) {
                              setState(() {
                                _selectedDay = selected;
                                _focusedDay = focused;
                              });
                            },
                            onPageChanged: (newDate) {
                              setState(() {
                                _focusedDay = newDate;
                              });
                            },
                          )),
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEditTaskScreen(initialDate: _selectedDay),
          ),
        ),
        child: Container(
          height: 52.h,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF4C45D4),
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: Text('Add task',
              style: TextStyle(fontSize: 16.sp, color: Colors.white)),
        ),
      ),
    );
  }
}
