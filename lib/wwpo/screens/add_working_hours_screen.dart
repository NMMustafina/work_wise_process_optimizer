import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../screens/models/working_hours_model.dart';

class AddWorkingHoursScreen extends StatefulWidget {
  const AddWorkingHoursScreen({super.key});

  @override
  State<AddWorkingHoursScreen> createState() => _AddWorkingHoursScreenState();
}

class _AddWorkingHoursScreenState extends State<AddWorkingHoursScreen> {
  final TextEditingController _hoursController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool isFormValid = false;
  late final DateTime _initialDate;

  @override
  void initState() {
    super.initState();
    _initialDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    _selectedDate = _initialDate;
    _hoursController.addListener(_validateForm);
  }

  void _validateForm() {
    final text = _hoursController.text.trim();
    final double? value = double.tryParse(text);
    final valid = value != null && value > 0 && value <= 24;
    setState(() => isFormValid = valid);
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
                  onDateTimeChanged: (newDate) => tempDate = newDate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveHours() async {
    final id = DateTime.now().toIso8601String();
    final value = double.tryParse(_hoursController.text) ?? 0;

    final box = GetIt.I.get<Box<WorkingHoursModel>>();
    final model = WorkingHoursModel(id: id, date: _selectedDate, hours: value);
    await box.put(id, model);
    Navigator.pop(context);
  }

  Future<bool> _showLeaveAlert() async {
    final res = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Leave the page'),
        content: const Text('These working hours will not be added'),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    return res ?? false;
  }

  bool get _hasChanges {
    final inputNotEmpty = _hoursController.text.trim().isNotEmpty;
    final selectedDateOnly =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    return inputNotEmpty || selectedDateOnly != _initialDate;
  }

  @override
  Widget build(BuildContext context) {
    final text = _hoursController.text.trim();
    final double? value = double.tryParse(text);
    final bool hasError = value != null && value > 24;

    return WillPopScope(
      onWillPop: () async => !_hasChanges || await _showLeaveAlert(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E20),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF1E1E20),
          title: const Text('Set the time'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final canLeave = !_hasChanges || await _showLeaveAlert();
              if (canLeave) Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Specify the date of working hours',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _showDatePicker,
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: const Color(0xFF2C2C2E),
                  ),
                  child: Text(
                    DateFormat('dd.MM.yyyy').format(_selectedDate),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              const Text('Enter the number of working hours per day',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 8.h),
              TextField(
                controller: _hoursController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'For example: 8 hours',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14.sp,
                  ),
                  filled: true,
                  fillColor: hasError
                      ? const Color(0xFF8F3225)
                      : const Color(0xFF2C2C2E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/pencil.svg',
                      width: 96.w,
                      height: 96.h,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Why add working hours?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'You add your current working hours to further build statistics and track your working hours for the week',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: isFormValid ? _saveHours : null,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 52.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: isFormValid
                  ? const Color(0xFF4C45D4)
                  : const Color(0xFF2E297F),
            ),
            child: Text('Confirm',
                style: TextStyle(color: Colors.white, fontSize: 16.sp)),
          ),
        ),
      ),
    );
  }
}
