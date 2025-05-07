import 'package:campaign_coffee/app/pages/profile/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
  void updateProfile(
      {String? newName, String? newEmail, String? newProfileImage}) {
    if (newName != null) name.value = newName;
    if (newEmail != null) email.value = newEmail;
    if (newProfileImage != null) profileImage.value = newProfileImage;
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
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        name.value = data['name'] ?? '';
        email.value = data['email'] ?? '';
        profileImage.value = data['avatar'] ?? 'assets/images/kyrie.jpg';
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

  void openHelpCenter() {
    Get.toNamed('/help-center');
  }

  void openSettings() {
    Get.put(ProfileController());
    Get.to(() => const SettingsPage());
  }
}
