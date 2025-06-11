import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class TaskFormFields extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final DateTime selectedDate;
  final VoidCallback onDateTap;
  final String selectedPriority;
  final ValueChanged<String> onPriorityChanged;

  const TaskFormFields({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.selectedDate,
    required this.onDateTap,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter the task name',
            style: TextStyle(color: Colors.white)),
        SizedBox(height: 8.h),
        TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'For example: reply to a message',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: const Color(0xFF2C2C2E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        const Text('Task description (optional)',
            style: TextStyle(color: Colors.white)),
        SizedBox(height: 8.h),
        TextField(
          controller: descriptionController,
          maxLines: 6,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter here...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: const Color(0xFF2C2C2E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        const Text('Priority', style: TextStyle(color: Colors.white)),
        SizedBox(height: 8.h),
        Row(
          children: ['Low', 'Medium', 'High'].map((level) {
            final isSelected = selectedPriority == level;
            final baseColor = level == 'Low'
                ? const Color(0xFF7C9447)
                : level == 'Medium'
                    ? const Color(0xFF82731F)
                    : const Color(0xFF8F3225);

            return Expanded(
              child: GestureDetector(
                onTap: () => onPriorityChanged(level),
                child: Container(
                  height: 52.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: isSelected ? baseColor : baseColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    level,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : baseColor.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 20.h),
        const Text('Select a date for the task',
            style: TextStyle(color: Colors.white)),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onDateTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: const Color(0xFF2C2C2E),
            ),
            child: Text(
              DateFormat('dd.MM.yyyy').format(selectedDate),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
