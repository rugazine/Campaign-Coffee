import 'package:campaign_coffee/app/pages/profile/settings_page.dart';
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

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }

  void logout() {
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
