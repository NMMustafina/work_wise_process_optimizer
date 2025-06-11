import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../screens/models/task_model.dart';
import 'task_actions_bottom_sheet.dart';

class AllTasksTab extends StatelessWidget {
  final List<TaskModel> tasks;

  const AllTasksTab({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: 80.h),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/check.svg',
                width: 96.w,
                height: 96.h,
              ),
              SizedBox(height: 12.h),
              Text(
                "You haven't added any tasks yet",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'You can add tasks via the "Add task" button or by clicking on the desired date in the calendar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final sorted = [...tasks];
    sorted.sort((a, b) =>
        a.isCompleted == b.isCompleted ? 0 : (a.isCompleted ? 1 : -1));

    return SafeArea(
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 80.h),
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          final task = sorted[index];
          return GestureDetector(
            onTap: () => showTaskActionsBottomSheet(context, task),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        if (task.description != null &&
                            task.description!.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: Text(
                              task.description!,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 13.sp,
                                height: 1.4,
                              ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Priority: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: task.priority,
                                  style: TextStyle(
                                    color: _priorityColor(task.priority),
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Container(
                    width: 24.sp,
                    height: 24.sp,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: task.isCompleted
                            ? const Color(0xFFA7C960)
                            : Colors.white,
                        width: 1,
                      ),
                    ),
                    child: task.isCompleted
                        ? Icon(
                            Icons.check,
                            size: 16.sp,
                            color: const Color(0xFFA7C960),
                          )
                        : null,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFFF4629);
      case 'Medium':
        return const Color(0xFFE7C91F);
      case 'Low':
        return const Color(0xFFA7C960);
      default:
        return Colors.white;
    }
  }
}
