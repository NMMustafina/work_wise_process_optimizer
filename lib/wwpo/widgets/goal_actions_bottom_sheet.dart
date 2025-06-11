import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../generated/assets.dart';
import '../screens/add_edit_goal_screen.dart';
import '../screens/models/goal_model.dart';

void showGoalActionsBottomSheet(BuildContext context, GoalModel model) {
  GoalStatus tempSelected = model.status;

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF323334),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    isScrollControlled: true,
    builder: (_) => StatefulBuilder(
      builder: (context, setStateBottom) {
        return Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Assign Goal status:',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              ...[
                GoalStatus.inProgress,
                GoalStatus.notStarted,
                GoalStatus.completed
              ].map((status) {
                final isSelected = status == tempSelected;
                return GestureDetector(
                  onTap: () => setStateBottom(() => tempSelected = status),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF4C45D4)
                          : Colors.transparent,
                      border:
                          Border.all(color: const Color(0xFF4C45D4), width: 1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      _statusText(status),
                      style: TextStyle(fontSize: 16.sp, color: Colors.white),
                    ),
                  ),
                );
              }),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Text(
                    'Additional editing',
                    style: TextStyle(
                        fontSize: 16.sp, color: Colors.white.withOpacity(0.6)),
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                    Assets.iconsSett,
                    width: 20.w,
                    height: 20.h,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _actionButton(
                label: 'Edit goal',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditGoalScreen(goal: model),
                    ),
                  );
                },
              ),
              _actionButton(
                label: 'Delete a goal',
                isDestructive: true,
                onTap: () async {
                  final box = GetIt.I.get<Box<GoalModel>>();
                  showCupertinoDialog(
                    context: context,
                    builder: (_) => CupertinoAlertDialog(
                      title: const Text('Delete goal'),
                      content: const Text(
                          'Are you sure you want to delete this goal?'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.pop(context),
                        ),
                        CupertinoDialogAction(
                          isDestructiveAction: true,
                          onPressed: () async {
                            final box = GetIt.I.get<Box<GoalModel>>();
                            await box.delete(model.id);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final updated = model..status = tempSelected;
                        final box = GetIt.I.get<Box<GoalModel>>();
                        await box.put(model.id, updated);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4C45D4),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: const Icon(Icons.check, color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    ),
  );
}

String _statusText(GoalStatus status) {
  switch (status) {
    case GoalStatus.inProgress:
      return 'In progress';
    case GoalStatus.notStarted:
      return 'Very close';
    case GoalStatus.completed:
      return 'Completed';
  }
}

Widget _actionButton({
  required String label,
  required VoidCallback onTap,
  bool isDestructive = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDestructive ? Colors.red : const Color(0xFF4C45D4),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16.sp,
          color: isDestructive ? Colors.red : Colors.white,
        ),
      ),
    ),
  );
}
