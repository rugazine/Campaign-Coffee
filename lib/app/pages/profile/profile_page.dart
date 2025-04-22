import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/profile_controller.dart';

const mainBlue = Color.fromRGBO(8, 76, 172, 1);

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: mainBlue, size: 26),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/profilepage.png'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: mainBlue.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Obx(() => CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                AssetImage(controller.profileImage.value),
                          )),
                    ),
                    const SizedBox(height: 16),
                    Obx(() => Text(
                          controller.name.value,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        )),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          controller.email.value,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                          ),
                        )),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => Get.toNamed('/edit-profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                        shadowColor: mainBlue.withOpacity(0.5),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildProfileItem(
                Icons.location_on_outlined,
                'Addresses',
                controller.manageAddresses,
              ),
              _buildProfileItem(
                Icons.help_outline,
                'Help Center',
                controller.openHelpCenter,
              ),
              _buildProfileItem(
                Icons.settings_outlined,
                'Settings',
                controller.openSettings,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
