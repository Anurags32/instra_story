import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      Get.toNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Story",
          style: TextStyle(
            fontSize: 100,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}
