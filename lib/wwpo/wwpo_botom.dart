import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/analytics_screen.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/calendar_screen.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/clock_screen.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/target_screen.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/wallet_screen.dart';

class WwpoBtmBar extends StatefulWidget {
  const WwpoBtmBar({super.key, this.indexScr = 0});
  final int indexScr;

  @override
  State<WwpoBtmBar> createState() => _WwpoBtmBarState();
}

class _WwpoBtmBarState extends State<WwpoBtmBar> {
  late int _currentIndex;

  final List<Widget> screens = const [
    WalletScreen(),
    ClockScreen(),
    TargetScreen(),
    CalendarScreen(),
    AnalyticsScreen(),
  ];

  final List<String> activeIcons = [
    "assets/icons/wallet_act.svg",
    "assets/icons/clock_act.svg",
    "assets/icons/target_act.svg",
    "assets/icons/calendar_act.svg",
    "assets/icons/donut_act.svg",
  ];

  final List<String> inactiveIcons = [
    "assets/icons/wallet.svg",
    "assets/icons/clock.svg",
    "assets/icons/target.svg",
    "assets/icons/calendar.svg",
    "assets/icons/donut.svg",
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.indexScr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: Container(
        height: 80.h + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(activeIcons.length, (index) {
            final isSelected = _currentIndex == index;
            final iconPath =
                isSelected ? activeIcons[index] : inactiveIcons[index];

            return GestureDetector(
              onTap: () => setState(() => _currentIndex = index),
              child: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color:
                      isSelected ? const Color(0xFF5E5CE6) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    iconPath,
                    width: 24.w,
                    height: 24.h,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
