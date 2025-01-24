import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:get/get.dart';
import '../MainMenu Screen/MainMenu.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to MenuScreen after 3 seconds using GetX
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => MenuScreen(data: [],));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                30.verticalSpace,
                Image.asset(
                  'assets/images/pig.png',
                  width: 600.r,
                  height: 500.r,
                ),
                20.verticalSpace,
                LoadingAnimationWidget.dotsTriangle(
                  color: Colors.white,
                  size: 40.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
