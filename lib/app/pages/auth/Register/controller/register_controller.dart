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

  // Field-specific error messages
  var usernameError = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var phoneError = ''.obs;

  // Clear all errors
  void clearErrors() {
    usernameError.value = '';
    emailError.value = '';
    passwordError.value = '';
    confirmPasswordError.value = '';
    phoneError.value = '';
  }

  @override
  void onInit() {
    super.onInit();

    // Add listeners to clear errors when user starts typing
    usernameController.addListener(() {
      if (usernameError.value.isNotEmpty) {
        usernameError.value = '';
      }
    });

    emailController.addListener(() {
      if (emailError.value.isNotEmpty) {
        emailError.value = '';
      }
    });

    passwordController.addListener(() {
      if (passwordError.value.isNotEmpty) {
        passwordError.value = '';
      }
    });

    confirmPasswordController.addListener(() {
      if (confirmPasswordError.value.isNotEmpty) {
        confirmPasswordError.value = '';
      }
    });

    phoneController.addListener(() {
      if (phoneError.value.isNotEmpty) {
        phoneError.value = '';
      }
    });
  }

  Future<void> register() async {
    // Clear previous errors
    clearErrors();

    // Validasi lokal
    bool hasError = false;

    if (usernameController.text.isEmpty) {
      usernameError.value = "Username tidak boleh kosong";
      hasError = true;
    }

    if (emailController.text.isEmpty) {
      emailError.value = "Email tidak boleh kosong";
      hasError = true;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = "Password tidak boleh kosong";
      hasError = true;
    }

    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = "Konfirmasi password tidak boleh kosong";
      hasError = true;
    }

    if (phoneController.text.isEmpty) {
      phoneError.value = "Nomor telepon tidak boleh kosong";
      hasError = true;
    }

    if (passwordController.text != confirmPasswordController.text) {
      confirmPasswordError.value =
          "Kata sandi dan konfirmasi kata sandi tidak cocok";
      hasError = true;
    }

    if (hasError) {
      return;
    }

    isLoading.value = true;

    try {
      final response = await http
          .post(
        Uri.parse('https://campaign.rplrus.com/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': usernameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'phone': phoneController.text.trim(),
        }),
      )
          .timeout(const Duration(seconds: 15), onTimeout: () {
        throw Exception('Koneksi ke server gagal. Silakan cek internet Anda.');
      });

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.body.isEmpty) {
        Get.snackbar('Gagal', 'Respons server kosong. Silakan coba lagi.',
            backgroundColor: Colors.red, colorText: Colors.white);
        return;
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        Get.snackbar(
          'Sukses',
          (data['data'] != null && data['data']['message'] != null)
              ? data['data']['message']
              : 'Registrasi berhasil! Silakan cek email Anda untuk verifikasi.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Future.delayed(const Duration(seconds: 1), () {
          Get.offAllNamed(AppRoutes.bottomnav);
        });
      } else if (response.statusCode == 422 || response.statusCode == 400) {
        // Handle validation errors (422 Unprocessable Entity atau 400 Bad Request)
        // Handle validation errors from server
        if (data['data'] != null && data['data']['errors'] != null) {
          final errors = data['data']['errors'];

          if (errors['name'] != null) {
            usernameError.value = errors['name'][0];
          }
          if (errors['email'] != null) {
            String emailErrorMsg = errors['email'][0];
            // Cek jika error tentang email sudah terdaftar
            if (emailErrorMsg
                    .toLowerCase()
                    .contains('has already been taken') ||
                emailErrorMsg.toLowerCase().contains('sudah digunakan') ||
                emailErrorMsg.toLowerCase().contains('already exists') ||
                emailErrorMsg.toLowerCase().contains('telah terdaftar')) {
              emailError.value = 'Email sudah terdaftar';
            } else {
              emailError.value = emailErrorMsg;
            }
          }
          if (errors['password'] != null) {
            passwordError.value = errors['password'][0];
          }
          if (errors['phone'] != null) {
            phoneError.value = errors['phone'][0];
          }
        } else if (data['message'] != null) {
          // Cek jika ada pesan error umum tentang email
          String message = data['message'].toString();
          if (message.toLowerCase().contains('email') &&
              (message.toLowerCase().contains('sudah') ||
                  message.toLowerCase().contains('taken') ||
                  message.toLowerCase().contains('exists'))) {
            emailError.value = 'Email sudah terdaftar';
          } else {
            // Fallback error message
            Get.snackbar('Gagal', 'Registrasi gagal. Silakan coba lagi.',
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        } else {
          // Fallback error message
          Get.snackbar('Gagal', 'Registrasi gagal. Silakan coba lagi.',
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      }
    } catch (e) {
      String errorMessage = e.toString().contains('timeout')
          ? 'Koneksi ke server gagal. Silakan cek internet Anda.'
          : 'Terjadi kesalahan saat mendaftar: ${e.toString()}.';
      Get.snackbar('Gagal', errorMessage,
          backgroundColor: Colors.red, colorText: Colors.white);
      print('Error during register: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
