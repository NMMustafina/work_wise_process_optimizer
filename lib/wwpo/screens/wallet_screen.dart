import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

import 'add_income_screen.dart';
import 'models/incoomm_model.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E20),
        title: Text(
          'My income',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        actions: [
          SvgPicture.asset('assets/icons/settings.svg'),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ValueListenableBuilder(
              valueListenable: GetIt.I.get<Box<IncoommModel>>().listenable(),
              builder: (context, Box<IncoommModel> box, _) {
                final totalAmount = box.values.fold<double>(
                  0,
                      (sum, item) => sum + (item.amounntt ?? 0),
                );

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                    SliverToBoxAdapter(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          color: const Color(0xFF4C45D4).withAlpha(127),
                        ),
                        child: Column(
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(DateTime.now()),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'From the last replenishment date: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    color: Colors.white.withAlpha(153),
                                  ),
                                ),
                                Text(
                                  box.isNotEmpty
                                      ? DateFormat('dd.MM.yy')
                                      .format(box.values.last.daatee)
                                      : 'none',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    color: box.isNotEmpty
                                        ? const Color(0xFF57BAE1)
                                        : Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '\$ ${totalAmount.toStringAsFixed(0)}.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 28.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '00',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 28.sp,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                    SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Income history',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: box.isNotEmpty
                                ? () {
                              _showSortBottomSheet(context, null,
                                      (selectedIndex) {
                                    print(
                                        "Выбрана сортировка: $selectedIndex");
                                  });
                            }
                                : null,
                            child: box.isNotEmpty
                                ? SvgPicture.asset(
                              'assets/icons/filter.svg',
                            )
                                : SvgPicture.asset(
                              'assets/icons/inactive.svg',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                    box.isEmpty
                        ? SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 30.h),
                          child: Text(
                            'There have been no incomes yet',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.6)),
                          ),
                        ),
                      ),
                    )
                        : SliverList.builder(
                      itemCount: box.length,
                      itemBuilder: (BuildContext context, int index) {
                        final incommm = box.getAt(index);
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: GestureDetector(
                            onTap: () {
                              _showIncomeOpewwetions(context, incommm!, index);
                            },

                            child: SizedBox(
                              height: 56.h,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/income.svg'),
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
                                        '${incommm?.amounntt}.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '00',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20.sp,
                                          color: Colors.white
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    DateFormat('dd.MM.yy').format(
                                        incommm?.daatee ??
                                            DateTime.now()),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      color: Color(0xFF57BAE1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddIncomwefweeScree(),
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
            color: Color(0xFF4C45D4),
          ),
          child: Text(
            'Add income',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showSortBottomSheet(
      BuildContext context, int? selectedIndex, Function(int) onSelected) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF323334),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      isScrollControlled: true,
      builder: (_) {
        final List<String> sortOptions = [
          'Sort by date (new)',
          'Sort by date (old)',
          'Sort by income (high)',
          'Sort by income (low)',
        ];

        int? tempSelectedIndex = selectedIndex;

        return StatefulBuilder(
          builder: (context, setState) {
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
                    final isSelected = index == tempSelectedIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          tempSelectedIndex = index;
                        });
                      },
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
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  }),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: tempSelectedIndex != null
                              ? () {
                            onSelected(tempSelectedIndex!);
                            Navigator.pop(context);
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tempSelectedIndex != null
                                ? const Color(0xFF5A4CE5)
                                : Colors.transparent,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              side: BorderSide(
                                color: const Color(0xFF5A4CE5).withOpacity(0.5),
                                width: 1.5,
                              ),
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
        );
      },
    );
  }


  void _showIncomeOpewwetions(BuildContext context, IncoommModel income, int index) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddIncomwefweeScree(incoommModel: income),
                  ),
                );
              },
              child: const Text(
                'Edit income',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, income, index);
              },
              child: const Text(
                'Delete income',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        );
      },
    );
  }
  void _showDeleteConfirmation(BuildContext context, IncoommModel income, int index) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete income'),
          content: const Text('Are you sure you want to delete this income?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Delete'),
              onPressed: () async {
                final box = GetIt.I.get<Box<IncoommModel>>();
                await box.deleteAt(index);
                Navigator.pop(context);

              },
            ),
          ],
        );
      },
    );
  }

}
