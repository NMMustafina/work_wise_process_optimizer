import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../screens/add_edit_expense_screen.dart';
import '../screens/models/expense_model.dart';

class ExpenseHistorySection extends StatefulWidget {
  const ExpenseHistorySection({super.key});

  @override
  State<ExpenseHistorySection> createState() => _ExpenseHistorySectionState();
}

class _ExpenseHistorySectionState extends State<ExpenseHistorySection> {
  int selectedSortIndex = 0;

  void _showSortBottomSheet() {
    final List<String> sortOptions = [
      'Sort by date (new)',
      'Sort by date (old)',
      'Sort by amount (high)',
      'Sort by amount (low)',
    ];
    int tempSelected = selectedSortIndex;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF323334),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateBottom) {
          return Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select the sort type',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                ...List.generate(sortOptions.length, (index) {
                  final isSelected = index == tempSelected;
                  return GestureDetector(
                    onTap: () => setStateBottom(() => tempSelected = index),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF5A4CE5)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                            color: const Color(0xFF5A4CE5), width: 0.5),
                      ),
                      width: double.infinity,
                      child: Text(
                        sortOptions[index],
                        style: TextStyle(fontSize: 16.sp, color: Colors.white),
                      ),
                    ),
                  );
                }),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel',
                            style: TextStyle(
                                fontSize: 16.sp, color: Colors.white)),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() => selectedSortIndex = tempSelected);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A4CE5),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            side: BorderSide(
                                color:
                                    const Color(0xFF5A4CE5).withOpacity(0.5)),
                          ),
                        ),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _showActions(ExpenseModel model) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AddEditExpenseScreen(expense: model)),
              );
            },
            child: const Text('Edit expense'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              showCupertinoDialog(
                context: context,
                builder: (_) => CupertinoAlertDialog(
                  title: const Text('Delete expense'),
                  content: const Text(
                      'Are you sure you want to delete this expense?'),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      onPressed: () async {
                        Navigator.pop(context);
                        final box = GetIt.I.get<Box<ExpenseModel>>();
                        await box.delete(model.id);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Delete expense'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ExpenseModel>>(
      valueListenable: GetIt.I.get<Box<ExpenseModel>>().listenable(),
      builder: (context, box, _) {
        final List<ExpenseModel> expenses = box.values.toList();

        switch (selectedSortIndex) {
          case 1:
            expenses.sort((a, b) => a.date.compareTo(b.date));
            break;
          case 2:
            expenses.sort((a, b) => b.amount.compareTo(a.amount));
            break;
          case 3:
            expenses.sort((a, b) => a.amount.compareTo(b.amount));
            break;
          default:
            expenses.sort((a, b) => b.date.compareTo(a.date));
        }

        final isSortActive = expenses.length > 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Expense history',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                GestureDetector(
                  onTap: isSortActive ? _showSortBottomSheet : null,
                  child: Container(
                    width: 52.w,
                    height: 52.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: SvgPicture.asset(
                      isSortActive
                          ? 'assets/icons/filter.svg'
                          : 'assets/icons/inactive.svg',
                      width: 52.w,
                      height: 52.h,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if (expenses.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: Text(
                    'There have been no expenses yet',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: expenses.length,
                itemBuilder: (context, i) {
                  final item = expenses[i];
                  return GestureDetector(
                    onTap: () => _showActions(item),
                    child: SizedBox(
                      height: 56.h,
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/icons/expense.svg'),
                          SizedBox(width: 24.w),
                          Text(
                            '\$',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: Colors.white.withAlpha(153),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                item.amount.toStringAsFixed(2),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('dd.MM.yy').format(item.date),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: const Color(0xFF57BAE1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
