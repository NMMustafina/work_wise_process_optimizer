import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:work_wise_process_optimizer_228t/wwpo/wwpo_botom.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardPageData> pages = [
    const _OnboardPageData(
      version: "0.1.2",
      imagePath: "assets/images/onBd1.png",
      title: "My Income",
      description: "Enter your income by specifying the amount and the date of receipt",
      buttonText: "Continue",
    ),
    const _OnboardPageData(
      version: "0.1.3",
      imagePath: "assets/images/onBd2.png",
      title: "Optimization expenses",
      description: "Record expenses aimed at improving your work efficiency with a work hours histogram",
      buttonText: "Continue",
    ),
    const _OnboardPageData(
      version: "0.1.4",
      imagePath: "assets/images/onBd3.png",
      title: "My Goals & Task calendar",
      description: "Set goals for cost reduction and workflow optimization",
      buttonText: "Continue",
    ),
    const _OnboardPageData(
      version: "0.1.5",
      imagePath: "assets/images/onBd4.png",
      title: "Analytics",
      description: "Visualize income and expense data with charts",
      buttonText: "Start",
    ),
  ];

  void _nextPage() {
    if (_currentPage < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const WwpoBtmBar()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: pages.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          final page = pages[index];
          final isLastPage = index == pages.length - 1;

          return Container(

            decoration: const BoxDecoration(
              gradient: LinearGradient(

                colors: [Color(0xFF0E0E0E), Color(0xFF1B1B1B)],

              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: Image.asset(
                        page.imagePath,
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      page.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    GestureDetector(
                      onTap: _nextPage,
                      child: Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4C45D4),
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          page.buttonText,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OnboardPageData {
  final String version;
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;

  const _OnboardPageData({
    required this.version,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
  });
}
