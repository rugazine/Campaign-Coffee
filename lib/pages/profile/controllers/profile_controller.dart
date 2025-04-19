import 'package:campaign_coffee/pages/profile/settings_page.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Observable user data
  final RxString name = 'Stephen Ruga'.obs;
  final RxString email = 'stephenruga@gmail.com'.obs;
  final RxString profileImage = 'assets/images/kyrie.jpg'.obs;

  // Observable notification settings
  final RxBool notificationsEnabled = true.obs;

  // Method to update profile information
  void updateProfile(
      {String? newName, String? newEmail, String? newProfileImage}) {
    if (newName != null) name.value = newName;
    if (newEmail != null) email.value = newEmail;
    if (newProfileImage != null) profileImage.value = newProfileImage;
  }

  // Method to toggle notifications
  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }

  // Method to handle logout
  void logout() {
    // TODO: Implement actual logout logic
    Get.offAllNamed('/auth'); // Navigate to auth page after logout
  }

  // Method to handle payment methods
  void managePaymentMethods() {
    // TODO: Implement payment methods management
    Get.toNamed('/payment-methods');
  }

  // Method to handle addresses
  void manageAddresses() {
    // TODO: Implement addresses management
    Get.toNamed('/addresses');
  }

  // Method to handle help center
  void openHelpCenter() {
    // TODO: Implement help center
    Get.toNamed('/help-center');
  }

  // Method to handle settings
  void openSettings() {
  Get.put(ProfileController());
  Get.to(() => const SettingsPage());
  }
}
