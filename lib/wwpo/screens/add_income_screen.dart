import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'models/incoomm_model.dart';

class AddIncomwefweeScree extends StatefulWidget {
  const AddIncomwefweeScree({super.key, this.incoommModel});

  final IncoommModel? incoommModel;

  @override
  State<AddIncomwefweeScree> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomwefweeScree> {
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool isFormValid = false;

  @override
  void initState() {
    super.initState();

    if (widget.incoommModel != null) {
      _amountController.text = widget.incoommModel!.amounntt.toString();
      _selectedDate = widget.incoommModel!.daatee;
    }

    _amountController.addListener(_validateFrrvorm);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _validateFrrvorm() {
    final isValid = _amountController.text.trim().isNotEmpty;
    if (isFormValid != isValid) {
      setState(() {
        isFormValid = isValid;
      });
    }
  }

  void _showCupertinoDatePicker(BuildContext context) {
    DateTime tempPickedDate = _selectedDate;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 280.h,
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = tempPickedDate;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 240.h,
              child: CupertinoDatePicker(
                initialDateTime: _selectedDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime newDate) {
                  tempPickedDate = newDate;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateFormewfgwe() async {
    if (isFormValid) {
      try {
        final incId =
            widget.incoommModel?.id ?? DateTime.now().toIso8601String();
        final addIncc = IncoommModel(
          id: incId,
          amounntt: double.tryParse(_amountController.text) ?? 0,
          daatee: _selectedDate,
        );

        final box = GetIt.I.get<Box<IncoommModel>>();
        await box.put(incId, addIncc);

        Navigator.pop(context, addIncc);
      } catch (e) {
        print('Error saving income: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('dd.MM.yyyy').format(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E20),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E20),
        title: Text(
          'Add Income',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            _showLeaveCewfwfonfirmation();
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Specify the amount of income',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              alignment: Alignment.centerLeft,
              height: 56.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2E),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Text(
                    '\$ ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      cursorColor: Color(0xFF57BAE1),
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Specify the date of the expense',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            GestureDetector(
              onTap: () => _showCupertinoDatePicker(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                width: double.infinity,
                child: Text(
                  dateFormatted,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: isFormValid
            ? () {
                _validateFormewfgwe();
              }
            : null,
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 52.h,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: isFormValid
                ? const Color(0xFF4C45D4)
                : const Color(0xFF4C45D4).withOpacity(0.4),
          ),
          child: Text(
            widget.incoommModel != null ? 'Save' : 'Add',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showLeaveCewfwfonfirmation() async {
    final result = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text(widget.incoommModel != null
            ? 'Leave the page'
            : 'Return to the main screen'),
        content: Text(widget.incoommModel != null
            ? 'This income changes will not be saved'
            : 'Your income will not be added'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel', style: TextStyle(color: Colors.blue)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: false,
            child:  Text(widget.incoommModel != null ? 'Leave':'Return', style: TextStyle(color: Colors.blue)),
            onPressed: () {
              Navigator.of(context).pop(true);
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
