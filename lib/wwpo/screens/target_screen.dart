import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../generated/assets.dart';
import '../screens/add_edit_goal_screen.dart';
import '../screens/models/goal_model.dart';
import '../screens/settings_screen.dart';
import '../widgets/goal_card.dart';
import '../widgets/goal_filter_buttons.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  GoalStatus? _selectedFilter;

  void _changeFilter(GoalStatus? status) {
    setState(() => _selectedFilter = status);
  }

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
          'My goals',
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ValueListenableBuilder<Box<GoalModel>>(
            valueListenable: GetIt.I.get<Box<GoalModel>>().listenable(),
            builder: (context, box, _) {
              final goals = box.values.toList();
              final filteredGoals = _selectedFilter == null
                  ? goals
                  : goals.where((g) => g.status == _selectedFilter).toList()
                ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

              return Column(
                children: [
                  GoalFilterButtons(
                    selectedFilter: _selectedFilter,
                    onFilterChanged: _changeFilter,
                  ),
                  SizedBox(height: 16.h),
                  Expanded(
                    child: filteredGoals.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 80.h),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    _selectedFilter == null
                                        ? 'assets/icons/star.svg'
                                        : 'assets/icons/search.svg',
                                    width: 96.w,
                                    height: 96.h,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    _selectedFilter == null
                                        ? 'The goals have not yet been set'
                                        : 'The appropriate status was not found',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    _selectedFilter == null
                                        ? 'Set goals to reduce financial costs and optimize working hours'
                                        : "You probably don't have any goals with this status",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: EdgeInsets.only(bottom: 80.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12.h),
                                  child: Text(
                                    'List of all tasks:',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  itemCount: filteredGoals.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) =>
                                      GoalCard(model: filteredGoals[index]),
                                ),
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddEditGoalScreen()),
        ),
        child: Container(
          height: 52.h,
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFF4C45D4),
            borderRadius: BorderRadius.circular(20.r),
          ),
          alignment: Alignment.center,
          child: Text(
            'Add a goal',
            style: TextStyle(fontSize: 16.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
