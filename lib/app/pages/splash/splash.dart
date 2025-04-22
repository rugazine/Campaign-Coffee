import 'package:campaign_coffee/app/pages/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Menginisialisasi controller
    final SplashViewController controller = Get.put(SplashViewController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/splashimage.jpg', // Gambar latar belakang
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}