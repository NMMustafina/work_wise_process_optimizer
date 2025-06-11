import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'models/working_hours_model.dart';

class EditWorkingHoursScreen extends StatefulWidget {
  const EditWorkingHoursScreen({super.key});

  @override
  State<EditWorkingHoursScreen> createState() => _EditWorkingHoursScreenState();
}

class _EditWorkingHoursScreenState extends State<EditWorkingHoursScreen> {
  final TextEditingController _hoursController = TextEditingController();
  List<DateTime> _availableDates = [];
  int _currentIndex = 0;
  bool isFormValid = false;
  bool hasChanged = false;
  double? _initialValue;

  Box<WorkingHoursModel> get _box => GetIt.I.get<Box<WorkingHoursModel>>();

  @override
  void initState() {
    super.initState();
    final allDates = _box.values
        .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b));

    _availableDates = allDates;

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    _currentIndex = _availableDates.indexWhere((d) => d == todayDate);
    if (_currentIndex == -1) _currentIndex = _availableDates.length - 1;

    _loadCurrentDay();
    _hoursController.addListener(_validate);
  }

  void _loadCurrentDay() {
    final day = _availableDates[_currentIndex];
    final entry = _box.values.firstWhere(
      (e) => _isSameDay(e.date, day),
      orElse: () => WorkingHoursModel(id: '', date: day, hours: 0),
    );
    _initialValue = entry.hours;
    _hoursController.text = _initialValue! % 1 == 0
        ? _initialValue!.toInt().toString()
        : _initialValue.toString();
    hasChanged = false;
    isFormValid = _initialValue != 0;
    setState(() {});
  }

  void _validate() {
    final text = _hoursController.text.trim();
    final value = double.tryParse(text);
    final valid = value != null && value > 0 && value <= 24;
    setState(() {
      isFormValid = valid;
      hasChanged = valid && value != _initialValue;
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _save() async {
    final day = _availableDates[_currentIndex];
    final value = double.tryParse(_hoursController.text) ?? 0;

    final existingKey = _box.keys.firstWhere(
      (key) => _isSameDay(_box.get(key)?.date ?? DateTime(2000), day),
      orElse: () => null,
    );

    final model = WorkingHoursModel(
      id: existingKey ?? const Uuid().v4(),
      date: day,
      hours: value,
    );

    await _box.put(model.id, model);
    _initialValue = value;
    hasChanged = false;
    _validate();
  }

  void _changeDay(int direction) {
    final newIndex = _currentIndex + direction;
    if (newIndex >= 0 && newIndex < _availableDates.length) {
      setState(() {
        _currentIndex = newIndex;
        _loadCurrentDay();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_availableDates.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No data available")),
      );
    }

    final currentDate = _availableDates[_currentIndex];
    final formattedDay = DateFormat('EEEE').format(currentDate);
    final formattedDate = DateFormat('dd.MM.yyyy').format(currentDate);
    final text = _hoursController.text.trim();
    final double? value = double.tryParse(text);
    final bool hasError = value != null && value > 24;

    final String? prevDay = _currentIndex > 0
        ? DateFormat('EEEE').format(_availableDates[_currentIndex - 1])
        : null;
    final String? nextDay = _currentIndex < _availableDates.length - 1
        ? DateFormat('EEEE').format(_availableDates[_currentIndex + 1])
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E20),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E20),
        title: const Text('Edit tracker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            prevDay ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap:
                                _currentIndex > 0 ? () => _changeDay(-1) : null,
                            child: Icon(
                              Icons.chevron_left,
                              size: 32,
                              color: _currentIndex > 0
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Text(
                      formattedDay,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            nextDay ?? '',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: _currentIndex < _availableDates.length - 1
                                ? () => _changeDay(1)
                                : null,
                            child: Icon(
                              Icons.chevron_right,
                              size: 32,
                              color: _currentIndex < _availableDates.length - 1
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              'Date for working hours',
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                formattedDate,
                style: TextStyle(
                    fontSize: 16.sp, color: Colors.white.withOpacity(0.5)),
              ),
            ),
            SizedBox(height: 24.h),
            const Text(
              'Enter the number of working hours per day',
              style: TextStyle(color: Colors.white),
            ),
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: isFormValid && hasChanged ? _save : null,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 52.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: isFormValid && hasChanged
                ? const Color(0xFF4C45D4)
                : const Color(0xFF2E297F),
          ),
          child: Text(
            'Save',
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
