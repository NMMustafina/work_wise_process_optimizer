import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/models/expense_model.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/models/goal_model.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/models/incoomm_model.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/models/task_model.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/screens/models/working_hours_model.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/services/notification_service.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/wwpo_board.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/wwpo_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await NotificationService.init();

  Hive.registerAdapter(IncoommModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(WorkingHoursModelAdapter());
  Hive.registerAdapter(GoalStatusAdapter());
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(TaskModelAdapter());

  final incomeBox = await Hive.openBox<IncoommModel>('incc');
  final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
  final workBox = await Hive.openBox<WorkingHoursModel>('working_hours');
  final goalBox = await Hive.openBox<GoalModel>('goals');
  final taskBox = await Hive.openBox<TaskModel>('tasks');

  GetIt.I.registerSingleton<Box<IncoommModel>>(incomeBox);
  GetIt.I.registerSingleton<Box<ExpenseModel>>(expenseBox);
  GetIt.I.registerSingleton<Box<WorkingHoursModel>>(workBox);
  GetIt.I.registerSingleton<Box<GoalModel>>(goalBox);
  GetIt.I.registerSingleton<Box<TaskModel>>(taskBox);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'AntiqueLedger - Precious Opus',
        theme: ThemeData(
          brightness: Brightness.dark,
          appBarTheme: const AppBarTheme(
            backgroundColor: WWPOColor.bg,
            iconTheme: IconThemeData(
              color: WWPOColor.white,
            ),
          ),
          scaffoldBackgroundColor: WWPOColor.bg,
          fontFamily: 'Inter',
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}
