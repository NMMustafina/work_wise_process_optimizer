import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/add_edit_task_screen.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/models/task_model.dart';

import '../../generated/assets.dart';

void showTaskActionsBottomSheet(BuildContext context, TaskModel model) {
  bool isChanged = false;
  bool isCompleted = model.isCompleted;

  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF323334),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
    ),
    isScrollControlled: true,
    builder: (bottomSheetContext) => StatefulBuilder(
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
                  'Mark when you complete the task',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              _actionButton(
                label: 'Completed',
                isHighlight: true,
                isActive: isCompleted,
                alignment: Alignment.center,
                onTap: () async {
                  isCompleted = !isCompleted;
                  final updated = TaskModel(
                    id: model.id,
                    title: model.title,
                    description: model.description,
                    date: model.date,
                    priority: model.priority,
                    reminder: model.reminder,
                    isCompleted: isCompleted,
                  );
                  final box = GetIt.I.get<Box<TaskModel>>();
                  await box.put(model.id, updated);
                  setStateBottom(() => isChanged = true);
                },
              ),
              SizedBox(height: 24.h),
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
                label: 'Edit Task',
                alignment: Alignment.centerLeft,
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddEditTaskScreen(task: model),
                    ),
                  );
                },
              ),
              _actionButton(
                label: 'Delete task',
                isDestructive: true,
                alignment: Alignment.centerLeft,
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  Future.delayed(Duration.zero, () {
                    showCupertinoDialog(
                      context: context,
                      builder: (alertContext) => CupertinoAlertDialog(
                        title: const Text('Delete task'),
                        content: const Text(
                            'Are you sure you want to delete this task?'),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(alertContext),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () async {
                              final box = GetIt.I.get<Box<TaskModel>>();
                              await box.delete(model.id);
                              if (alertContext.mounted) {
                                Navigator.pop(alertContext);
                              }
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(bottomSheetContext),
                      child: Text('Cancel',
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white)),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isChanged
                          ? () => Navigator.pop(bottomSheetContext)
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        backgroundColor: isChanged
                            ? const Color(0xFF4C45D4)
                            : Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                          side: const BorderSide(
                              color: Color(0xFF4C45D4), width: 1),
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

Widget _actionButton({
  required String label,
  required VoidCallback onTap,
  bool isDestructive = false,
  bool isHighlight = false,
  bool isActive = false,
  Alignment alignment = Alignment.centerLeft,
}) {
  Color borderColor = isDestructive
      ? Colors.red
      : isHighlight
          ? const Color(0xFFA7C960)
          : const Color(0xFF4C45D4);

  Color textColor = isDestructive ? Colors.red : Colors.white;

  Color backgroundColor = isHighlight
      ? (isActive ? const Color(0xFFA7C960) : Colors.transparent)
      : Colors.transparent;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      alignment: alignment,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Text(
        label,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 16.sp, color: textColor),
      ),
    ),
  );
}
