import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/models/goal_model.dart';

class GoalFilterButtons extends StatelessWidget {
  final GoalStatus? selectedFilter;
  final ValueChanged<GoalStatus?> onFilterChanged;

  const GoalFilterButtons({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  Color _getActiveTextColor(GoalStatus? status) {
    switch (status) {
      case GoalStatus.inProgress:
        return const Color(0xFFFF4629);
      case GoalStatus.notStarted:
        return const Color(0xFFE7C91F);
      case GoalStatus.completed:
        return const Color(0xFFA7C960);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton('All goals', null),
        _buildButton('In progress', GoalStatus.inProgress),
        _buildButton('Close', GoalStatus.notStarted),
        _buildButton('Completed', GoalStatus.completed),
      ],
    );
  }

  Widget _buildButton(String title, GoalStatus? value) {
    final isSelected = selectedFilter == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => onFilterChanged(value),
        child: Container(
          height: 56.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF323334) : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF57BAE1)
                  : Colors.white.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? _getActiveTextColor(value) : Colors.white,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }
}
