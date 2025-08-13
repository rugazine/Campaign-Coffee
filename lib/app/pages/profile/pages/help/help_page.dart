import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

const mainBlue = Color.fromRGBO(8, 76, 172, 1);

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildHelpItem(IconData icon, String title, String url) {
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
        onTap: () => _launchUrl(url),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bantuan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: mainBlue,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: mainBlue),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            _buildHelpItem(
              Icons.chat_outlined,
              'WhatsApp',
              'https://wa.me/082225556116',
            ),
            _buildHelpItem(
              Icons.camera_alt_outlined,
              'Instagram',
              'https://www.instagram.com/campaign.coffee',
            ),
            _buildHelpItem(
              Icons.email_outlined,
              'Email',
              'mailto:campaigncoff@gmail.com',
            ),
            _buildHelpItem(
              Icons.phone_outlined,
              'Telepon',
              'tel:+6282225556116',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
