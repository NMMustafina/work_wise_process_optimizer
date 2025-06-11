import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/models/goal_model.dart';

class AddEditGoalScreen extends StatefulWidget {
  final GoalModel? goal;

  const AddEditGoalScreen({super.key, this.goal});

  @override
  State<AddEditGoalScreen> createState() => _AddEditGoalScreenState();
}

class _AddEditGoalScreenState extends State<AddEditGoalScreen> {
  final TextEditingController _titleController = TextEditingController();
  late DateTime? _selectedDate;
  late DateTime _initialDate;
  bool isFormValid = false;
  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initialDate = DateTime.now().add(const Duration(days: 7));
    _selectedDate = widget.goal?.deadline ?? _initialDate;

    if (widget.goal != null) {
      _titleController.text = widget.goal!.title;
    }

    _titleController.addListener(_validateForm);
  }

  void _validateForm() {
    final valid = _titleController.text.trim().isNotEmpty;
    final changed =
        _titleController.text.trim() != (widget.goal?.title ?? '') ||
            _selectedDate != widget.goal?.deadline;

    setState(() {
      isFormValid = valid;
      hasChanges = changed;
    });
  }

  void _showDatePicker() {
    DateTime temp = _selectedDate ?? _initialDate;
    final today = DateTime.now();

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
                      setState(() => _selectedDate = temp);
                      _validateForm();
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
                data: const CupertinoThemeData(brightness: Brightness.dark),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  minimumDate: DateTime(today.year, today.month, today.day),
                  onDateTimeChanged: (value) => temp = value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveGoal() async {
    final id = widget.goal?.id ?? DateTime.now().toIso8601String();
    final newGoal = GoalModel(
      id: id,
      title: _titleController.text.trim(),
      deadline: _selectedDate,
      status: widget.goal?.status ?? GoalStatus.inProgress,
      createdAt: widget.goal?.createdAt ?? DateTime.now(),
    );

    final box = GetIt.I.get<Box<GoalModel>>();
    await box.put(id, newGoal);
    Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    if (widget.goal == null && _titleController.text.trim().isNotEmpty) {
      return await _showLeaveAlert(isEditing: false);
    } else if (widget.goal != null && hasChanges) {
      return await _showLeaveAlert(isEditing: true);
    }
    return true;
  }

  Future<bool> _showLeaveAlert({required bool isEditing}) async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Leave the page'),
        content: Text(isEditing
            ? 'Your goal changes will not be saved'
            : 'Your goal will not be added'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.goal != null;
    final formattedDate = _selectedDate != null
        ? DateFormat('dd.MM.yyyy').format(_selectedDate!)
        : '';

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E20),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF1E1E20),
          elevation: 0,
          title: Text(isEditing ? 'Edit goal' : 'Add goal'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final canLeave = await _onWillPop();
              if (canLeave) Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter the goal name',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp)),
              SizedBox(height: 8.h),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'For example: Reduce costs by 20%',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14.sp,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF2C2C2E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text('Specify the deadline date (optional)',
                  style: TextStyle(color: Colors.white, fontSize: 14.sp)),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _showDatePicker,
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap:
              isFormValid && (isEditing ? hasChanges : true) ? _saveGoal : null,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 52.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: isFormValid && (isEditing ? hasChanges : true)
                  ? const Color(0xFF4C45D4)
                  : const Color(0xFF2E297F),
            ),
            child: Text(
              isEditing ? 'Save' : 'Add',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
