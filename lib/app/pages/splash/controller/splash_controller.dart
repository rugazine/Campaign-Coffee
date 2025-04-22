import 'package:campaign_coffee/app/pages/auth/auth_page.dart';
import 'package:get/get.dart';

class SplashViewController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Menambahkan jeda sebelum berpindah ke WelcomeScreen
    Future.delayed(Duration(seconds: 1), () {
      Get.off(() => AuthPage()); // Navigate to Welcome Screen
    });
  }
}