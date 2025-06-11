import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../screens/models/goal_model.dart';
import 'goal_actions_bottom_sheet.dart';

class GoalCard extends StatelessWidget {
  final GoalModel model;

  const GoalCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.title,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Deadline: ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                TextSpan(
                  text: model.deadline != null
                      ? DateFormat('dd.MM.yy').format(model.deadline!)
                      : '-',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF57BAE1),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Status: ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                TextSpan(
                  text: _statusText(model.status),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: _statusColor(model.status),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: () => showGoalActionsBottomSheet(context, model),
            child: Container(
              height: 40.h,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4C45D4)),
                borderRadius: BorderRadius.circular(12.r),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Change status',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _statusText(GoalStatus status) {
    switch (status) {
      case GoalStatus.notStarted:
        return 'Very close';
      case GoalStatus.inProgress:
        return 'In progress';
      case GoalStatus.completed:
        return 'Completed';
    }
  }

  Color _statusColor(GoalStatus status) {
    switch (status) {
      case GoalStatus.notStarted:
        return const Color(0xFFE7C91F);
      case GoalStatus.inProgress:
        return const Color(0xFFFF4629);
      case GoalStatus.completed:
        return const Color(0xFFA7C960);
    }
  }
}
