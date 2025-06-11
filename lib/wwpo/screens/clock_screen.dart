import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/add_edit_expense_screen.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/settings_screen.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/widgets/expense_history_section.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/widgets/working_hours_section.dart';

class ClockScreen extends StatelessWidget {
  const ClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Optimization expenses',
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: SvgPicture.asset(
              'assets/icons/sett.svg',
              width: 24.w,
              height: 24.h,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 80.h),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkingHoursSection(),
                ExpenseHistorySection(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddEditExpenseScreen(),
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 52.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: const Color(0xFF4C45D4),
          ),
          child: Text(
            'Add expense',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
