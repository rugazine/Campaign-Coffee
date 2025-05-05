import 'dart:convert';
import 'package:campaign_coffee/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  var isLoading = false.obs;

  Future<void> register() async {
    isLoading.value = true;

    final url = Uri.parse('https://37b8-103-164-229-141.ngrok-free.app/api/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'name': usernameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'password_confirmation': confirmPasswordController.text,
          'phone_number': phoneController.text,
        },
      );

      final data = json.decode(response.body);
      print('Response: $data');

      if ((response.statusCode == 200 || response.statusCode == 201) &&
    (data['message']?.toString().toLowerCase().contains("success") ?? false)) {
  Get.snackbar(
    'Success',
    data['message'] ?? 'Account created successfully',
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );

  Future.delayed(const Duration(seconds: 1), () {
    Get.offAllNamed(AppRoutes.bottomnav);
  });
} else {
  Get.snackbar(
    'Register Failed',
    data['message'] ?? 'Unknown error',
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

    } catch (e) {
      // ❌ Error koneksi / parsing
      Get.snackbar(
        'Error',
        'Failed to connect to server',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}