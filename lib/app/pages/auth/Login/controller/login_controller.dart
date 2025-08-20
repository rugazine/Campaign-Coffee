import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:campaign_coffee/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:campaign_coffee/app/pages/cart/controllers/cart_controller.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>().obs;

  // Field-specific error messages
  var emailError = ''.obs;
  var passwordError = ''.obs;

  // Clear all errors
  void clearErrors() {
    emailError.value = '';
    passwordError.value = '';
  }

  void setEmail(String value) {
    email.value = value;
    // Clear error when user starts typing
    if (emailError.value.isNotEmpty) {
      emailError.value = '';
    }
  }

  void setPassword(String value) {
    password.value = value;
    // Clear error when user starts typing
    if (passwordError.value.isNotEmpty) {
      passwordError.value = '';
    }
  }

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
    // Clear previous errors
    clearErrors();

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
          // Ambil token dari data['data']['token']
          final token = data['data']?['token'] ?? '';
          if (token == null || token == '') {
            throw Exception('Token tidak ditemukan di response');
          }
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          // Muat cart untuk user yang baru login
          final cartController = Get.find<CartController>();
          await cartController.loadCartFromPrefs();

          Get.offAllNamed(AppRoutes.bottomnav);
        } else {
          // Handle login errors
          if (data['data'] != null && data['data']['errors'] != null) {
            final errors = data['data']['errors'];

            if (errors['email'] != null) {
              emailError.value = errors['email'][0];
            }
            if (errors['password'] != null) {
              passwordError.value = errors['password'][0];
            }
          } else if (data['message'] != null) {
            // Check if it's a general login error
            String message = data['message'].toString();
            if (message.toLowerCase().contains('email') ||
                message.toLowerCase().contains('password') ||
                message.toLowerCase().contains('credentials')) {
              emailError.value = 'Email atau password salah';
            } else {
              emailError.value = message;
            }
          } else {
            emailError.value = 'Email atau password salah';
          }
        }
      } catch (e) {
        emailError.value = 'Terjadi kesalahan: ${e.toString()}';
      } finally {
        isLoading.value = false;
      }
    }
  }
}
