import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/services/notification_service.dart';

import '../widgets/reminder_section.dart';
import '../widgets/task_form_fields.dart';
import 'models/task_model.dart';

Future<void> openExactAlarmSettings() async {
  const intent = AndroidIntent(
    action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
  );
  await intent.launch();
}

class AddEditTaskScreen extends StatefulWidget {
  final TaskModel? task;
  final DateTime? initialDate;

  const AddEditTaskScreen({super.key, this.task, this.initialDate});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  String _priority = 'Medium';
  bool _reminder = false;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _selectedDate = widget.initialDate!;
    }
    if (widget.task != null) {
      _nameController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description ?? '';
      _selectedDate = widget.task!.date;
      _priority = widget.task!.priority;
      _reminder = widget.task!.reminder;
      _selectedTime = TimeOfDay.fromDateTime(widget.task!.date);
    }
    _nameController.addListener(_checkChanges);
    _descriptionController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final newName = _nameController.text;
    final newDesc = _descriptionController.text;
    final oldName = widget.task?.title ?? '';
    final oldDesc = widget.task?.description ?? '';
    final oldTime = widget.task?.date ?? DateTime.now();
    final changed = newName != oldName ||
        newDesc != oldDesc ||
        _priority != (widget.task?.priority ?? 'Medium') ||
        _selectedDate != DateTime(oldTime.year, oldTime.month, oldTime.day) ||
        _selectedTime != TimeOfDay.fromDateTime(oldTime) ||
        _reminder != (widget.task?.reminder ?? false);

    setState(() => _hasChanged = changed);
  }

  void _showDatePicker() {
    DateTime tempDate = _selectedDate;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300.h,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF57BAE1),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _selectedDate = tempDate);
                      _checkChanges();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF57BAE1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 0),
            Expanded(
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  brightness: Brightness.dark,
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTask() async {
    final id = widget.task?.id ?? DateTime.now().toIso8601String();

    final scheduledDate = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final task = TaskModel(
      id: id,
      title: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      date: scheduledDate,
      priority: _priority,
      reminder: _reminder,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    final box = GetIt.I.get<Box<TaskModel>>();
    await box.put(id, task);

    if (widget.task != null) {
      await NotificationService.cancelNotification(widget.task!.id);
    }

    if (_reminder && scheduledDate.isAfter(DateTime.now())) {
      try {
        await NotificationService.scheduleNotification(
          id: id.hashCode,
          title: task.title,
          body: task.description ?? '',
          scheduledDate: scheduledDate,
        );
      } catch (e) {
        debugPrint('Failed to schedule notification: $e');
        if (context.mounted) {
          final isExactAlarmError =
              e.toString().contains('exact_alarms_not_permitted');

          showCupertinoDialog(
            context: context,
            builder: (_) => CupertinoAlertDialog(
              title: Text(isExactAlarmError
                  ? 'Exact alarms disabled'
                  : 'Notification Error'),
              content: Text(
                isExactAlarmError
                    ? 'To receive reminders exactly on time, please allow exact alarms in system settings.'
                    : 'We could not schedule the reminder. Please ensure notification permissions and exact alarms are allowed.',
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                if (isExactAlarmError)
                  CupertinoDialogAction(
                    child: const Text('Open settings'),
                    onPressed: () {
                      Navigator.pop(context);
                      openExactAlarmSettings();
                    },
                  ),
              ],
            ),
          );
        }
      }
    }

    Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    if (_hasChanged) {
      final res = await showCupertinoDialog<bool>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Leave without saving?'),
          content: const Text('Your changes will be lost.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Leave'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );
      return res ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.task != null;
    final bool isFormValid = _nameController.text.trim().isNotEmpty;
    final bool canSave = isEditing ? _hasChanged && isFormValid : isFormValid;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: false,
        backgroundColor: const Color(0xFF1C1C1E),
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: const Color(0xFF1C1C1E),
          elevation: 0,
          centerTitle: true,
          title: Text(isEditing ? 'Edit task' : 'Add task'),
          leading: const BackButton(color: Colors.white),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TaskFormFields(
                  nameController: _nameController,
                  descriptionController: _descriptionController,
                  selectedDate: _selectedDate,
                  onDateTap: _showDatePicker,
                  selectedPriority: _priority,
                  onPriorityChanged: (val) {
                    setState(() {
                      _priority = val;
                      _checkChanges();
                    });
                  },
                ),
                SizedBox(height: 24.h),
                ReminderSection(
                  value: _reminder,
                  onChanged: (val) async {
                    if (val) {
                      final status = await Permission.notification.request();
                      if (status.isGranted) {
                        setState(() {
                          _reminder = true;
                          _checkChanges();
                        });
                      } else {
                        if (context.mounted) {
                          showCupertinoDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                              title: const Text('Permission denied'),
                              content: const Text(
                                'You need to enable notifications to receive reminders.',
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  child: const Text('OK'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    } else {
                      setState(() {
                        _reminder = false;
                        _checkChanges();
                      });
                    }
                  },
                  selectedTime: _selectedTime,
                  onTimeChanged: (newTime) {
                    setState(() {
                      _selectedTime = newTime;
                      _checkChanges();
                    });
                  },
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: canSave ? _saveTask : null,
          child: Container(
            height: 52.h,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color:
                  canSave ? const Color(0xFF4C45D4) : const Color(0xFF2E297F),
            ),
            alignment: Alignment.center,
            child: Text(
              isEditing ? 'Save' : 'Add',
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
