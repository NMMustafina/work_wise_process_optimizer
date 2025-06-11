import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/models/expense_model.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final ExpenseModel? expense;

  const AddEditExpenseScreen({super.key, this.expense});

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  bool isFormValid = false;
  bool hasChanged = false;

  final List<String> categories = [
    'Transport',
    'Materials',
    'Software',
    'Training',
    'Services',
    'Public utilities',
    'Advertisement',
    'Rent',
    'Automation Services',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _selectedDate = widget.expense!.date;
      _selectedCategory = widget.expense!.category;
    }
    _amountController.addListener(_validateForm);
  }

  void _validateForm() {
    final valid =
        _amountController.text.trim().isNotEmpty && _selectedCategory != null;
    final changed = _amountController.text.trim() !=
            (widget.expense?.amount.toString() ?? '') ||
        _selectedDate != widget.expense?.date ||
        _selectedCategory != widget.expense?.category;

    setState(() {
      isFormValid = valid;
      hasChanged = changed;
    });
  }

  void _showDatePicker() {
    DateTime tempDate = _selectedDate;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300.h,
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF57BAE1),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() => _selectedDate = tempDate);
                      _validateForm();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF57BAE1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 0),
            Expanded(
              child: CupertinoTheme(
                data: const CupertinoThemeData(
                  brightness: Brightness.dark,
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: _selectedDate,
                  onDateTimeChanged: (DateTime newDate) {
                    tempDate = newDate;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveExpense() async {
    final id = widget.expense?.id ?? DateTime.now().toIso8601String();
    final model = ExpenseModel(
      id: id,
      amount: double.tryParse(_amountController.text) ?? 0,
      date: _selectedDate,
      category: _selectedCategory!,
    );
    final box = GetIt.I.get<Box<ExpenseModel>>();
    await box.put(id, model);
    Navigator.pop(context);
  }

  Future<bool> _onWillPop() async {
    if (widget.expense == null && !_amountController.text.trim().isEmpty) {
      return await _showLeaveAlert();
    } else if (widget.expense != null && hasChanged) {
      return await _showLeaveAlert();
    }
    return true;
  }

  Future<bool> _showLeaveAlert() async {
    final res = await showCupertinoDialog<bool>(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text('Leave the page'),
        content: const Text('Your expense changes will not be saved'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    return res ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E20),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF1E1E20),
          title: Text(isEditing ? 'Edit expense' : 'Add expense'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              final canLeave = await _onWillPop();
              if (canLeave) Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Specify the amount of the expense',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 8.h),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: InputDecoration(
                  prefixText: '\$ ',
                  filled: true,
                  fillColor: const Color(0xFF2C2C2E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              const Text('Specify the date of the expense',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: _showDatePicker,
                child: Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: const Color(0xFF2C2C2E),
                  ),
                  child: Text(
                    DateFormat('dd.MM.yyyy').format(_selectedDate),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              const Text('Select an expense category',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 8.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: categories.map((cat) {
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCategory = cat);
                      _validateForm();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF57BAE1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: const Color(0xFF57BAE1)),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: GestureDetector(
          onTap: isFormValid && (isEditing ? hasChanged : true)
              ? _saveExpense
              : null,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 52.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: isFormValid && (isEditing ? hasChanged : true)
                  ? const Color(0xFF4C45D4)
                  : const Color(0xFF2E297F),
            ),
            child: Text(
              isEditing ? 'Save' : 'Add',
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
