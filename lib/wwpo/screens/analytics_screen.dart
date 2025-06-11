import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/settings_screen.dart';

import '../../generated/assets.dart';
import '../screens/models/expense_model.dart';
import '../screens/models/incoomm_model.dart';
import '../screens/models/working_hours_model.dart';
import '../widgets/analytics_bar_chart.dart';
import '../widgets/analytics_double_bar_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late DateTime selectedMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    selectedMonth = DateTime(now.year, now.month);
  }

  void _changeMonth(int offset) {
    setState(() {
      selectedMonth = DateTime(
        selectedMonth.year,
        selectedMonth.month + offset,
      );
    });
  }

  String get formattedMonth => DateFormat('MMMM yyyy').format(selectedMonth);

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
          'Analytics',
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
              Assets.iconsSett,
              width: 24.w,
              height: 24.h,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (_, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => _changeMonth(-1),
                          child: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
                        ),
                        Text(
                          formattedMonth,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () => _changeMonth(1),
                          child: const Icon(Icons.arrow_forward_ios,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 24.h),
                        child: ListenableBuilder(
                          listenable: Listenable.merge([
                            GetIt.I.get<Box<IncoommModel>>().listenable(),
                            GetIt.I.get<Box<WorkingHoursModel>>().listenable(),
                            GetIt.I.get<Box<ExpenseModel>>().listenable(),
                          ]),
                          builder: (_, __) {
                            return Column(
                              children: [
                                AnalyticsBarChart(selectedMonth: selectedMonth),
                                SizedBox(height: 24.h),
                                AnalyticsDoubleBarChart(
                                    selectedMonth: selectedMonth),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
