// ❗ Убедись, что все svg иконки: reminder.svg, notif_on.svg, notif_off.svg добавлены в pubspec.yaml

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/wwpo_dok.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/wwpo_moti.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/wwpo_url.dart';

import '../wwpo_color.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = false;
  bool showRequestDialog = false;
  bool showDeniedDialog = false;

  void _onReminderTap() {
    if (!notificationsEnabled) {
      setState(() => showRequestDialog = true);
    } else {
      setState(() => notificationsEnabled = false);
    }
  }

  void _denyAccess() {
    setState(() {
      showRequestDialog = false;
      showDeniedDialog = true;
    });
  }

  void _cancelDenied() {
    setState(() {
      showDeniedDialog = false;
      notificationsEnabled = false;
    });
  }

  void _confirmPermission() {
    setState(() {
      showRequestDialog = false;
      notificationsEnabled = true;
    });
  }

  void _goToSettings() {
    setState(() => showDeniedDialog = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF1C1C1E),
          appBar: AppBar(
            backgroundColor: const Color(0xFF1C1C1E),
            elevation: 0,
            title: Text('Settings', style: TextStyle(fontSize: 20.sp, color: Colors.white)),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 18.sp),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WwpoMotiiButT(
                  onPressed: () => wwpoUrl(context, WwpoDokum.ppol),
                  child: const _SettingsTile(icon: "assets/icons/privacy.svg", title: 'Privacy policy'),
                ),
                WwpoMotiiButT(
                  onPressed: () => wwpoUrl(context, WwpoDokum.tou),
                  child: const _SettingsTile(icon: "assets/icons/term.svg", title: 'Terms of Use'),
                ),
                WwpoMotiiButT(
                  onPressed: () => wwpoUrl(context, WwpoDokum.spt),
                  child: const _SettingsTile(icon: "assets/icons/support.svg", title: 'Support'),
                ),


                /// Reminders Row
                GestureDetector(
                  onTap: _onReminderTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/reminder.svg",
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "Reminders",
                            style: TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                        ),
                        Text(
                          notificationsEnabled ? "On" : "Off",
                          style: TextStyle(fontSize: 16.sp, color: Colors.white54),
                        ),
                        SizedBox(width: 8.w),
                        SvgPicture.asset(
                          notificationsEnabled
                              ? "assets/icons/reminder_on.svg"
                              : "assets/icons/reminder_off.svg",

                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String icon;
  final String title;

  const _SettingsTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          SvgPicture.asset(icon, ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
          ),
          Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r),color: WWPOColor.gray),
              padding: EdgeInsets.all(18.r),
              child: Icon(Icons.arrow_forward_ios,  color: Colors.white54)),
        ],
      ),
    );
  }
}


