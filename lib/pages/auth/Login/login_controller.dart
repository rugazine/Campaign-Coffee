import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campaign_coffee/routes/app_routes.dart';

class LoginController extends GetxController {
  final username = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>().obs;

  void setUsername(String value) => username.value = value;
  void setPassword(String value) => password.value = value;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username tidak boleh kosong';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    return null;
  }

  Future<void> login() async {
    if (formKey.value.currentState?.validate() ?? false) {
      try {
        isLoading.value = true;
        // Simulasi delay login
        await Future.delayed(const Duration(seconds: 2));

        // Verifikasi kredensial
        if (username.value == 'ruga' && password.value == 'ruga') {
          Get.offAllNamed(AppRoutes.bottomnav);
        } else {
          Get.snackbar(
            'Error',
            'Username atau password salah',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal login: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
