import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderSection extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const ReminderSection({
    super.key,
    required this.value,
    required this.onChanged,
    required this.selectedTime,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final initialDateTime = DateTime(
      0,
      0,
      0,
      selectedTime.hour,
      selectedTime.minute,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Turn on the reminder?',
              style: TextStyle(color: Colors.white),
            ),
            SquareSwitch(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Opacity(
          opacity: value ? 1.0 : 0.3,
          child: AbsorbPointer(
            absorbing: !value,
            child: SizedBox(
              height: 120.h,
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  brightness: Brightness.dark,
                  primaryColor: Color(0xFF57BAE1),
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  backgroundColor: Colors.transparent,
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialDateTime,
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newDateTime) {
                    onTimeChanged(TimeOfDay(
                      hour: newDateTime.hour,
                      minute: newDateTime.minute,
                    ));
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SquareSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SquareSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52.w,
        height: 28.h,
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: const Color(0xFF3A3A3C),
          borderRadius: BorderRadius.circular(6.r),
        ),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: value ? const Color(0xFF57BAE1) : const Color(0xFFD1D1D6),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}
