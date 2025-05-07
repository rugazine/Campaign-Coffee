import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:campaign_coffee/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>().obs;

  void setEmail(String value) => email.value = value;
  void setPassword(String value) => password.value = value;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    } else if (!GetUtils.isEmail(value)) {
      return 'Format email tidak valid';
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

        final response = await http.post(
          Uri.parse('https://campaign.rplrus.com/api/login'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'email': email.value,
            'password': password.value,
          }),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 200) {
          final token = data['token'];
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          Get.offAllNamed(AppRoutes.bottomnav);
        } else {
          Get.snackbar(
            'Login Gagal',
            data['message'] ?? 'Email atau password salah',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan: ${e.toString()}',
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
