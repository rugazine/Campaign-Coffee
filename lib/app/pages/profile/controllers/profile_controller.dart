import 'package:campaign_coffee/app/pages/profile/pages/help/help_page.dart';
import 'package:campaign_coffee/app/pages/profile/pages/settings_page.dart';
import 'package:campaign_coffee/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class ProfileController extends GetxController {
  // Observable user data
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString profileImage = ''.obs;

  // Observable notification settings
  final RxBool notificationsEnabled = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // Method to update profile information
  Future<void> updateProfile({
    String? newName,
    String? newEmail,
    String? newPhone,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.offAllNamed('/auth');
        return;
      }

      final response = await http.post(
        Uri.parse('https://campaign.rplrus.com/api/user/update'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': newName ?? name.value,
          'email': newEmail ?? email.value,
          'phone': newPhone,
        }),
      );

      if (response.statusCode == 200) {
        if (newName != null) name.value = newName;
        if (newEmail != null) email.value = newEmail;
        Get.snackbar(
          'Sukses',
          'Profil berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Gagal memperbarui profil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFE57373),
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
    }
  }

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }

  Future<void> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        Get.offAllNamed('/auth');
        return;
      }

      final response = await http.get(
        Uri.parse('https://campaign.rplrus.com/api/user'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        name.value = data['name'] ?? '';
        email.value = data['email'] ?? '';
        profileImage.value = data['avatar'] ?? 'assets/images/Rhope.png';
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil data profil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color(0xFFE57373),
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
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.offAllNamed('/auth');
  }

  void managePaymentMethods() {
    Get.toNamed('/payment-methods');
  }

  void manageAddresses() {
    Get.toNamed('/addresses');
  }

  void openStoreLocation() {
    // Navigasi ke halaman alamat toko
    Get.toNamed(AppRoutes.storeAddress);
  }

  void openHelpCenter() {
    Get.to(() => const HelpPage());
  }

  void openSettings() {
    Get.put(ProfileController());
    Get.to(() => const SettingsPage());
  }
}
