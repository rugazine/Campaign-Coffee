import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campaign_coffee/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _checkToken();
  }

  Future<void> _checkToken() async {
    // Untuk sementara, selalu arahkan ke halaman auth/login
    // meskipun sudah ada token, untuk mempermudah testing
    await Future.delayed(const Duration(seconds: 3));

    // Selalu arahkan ke auth page
      Get.offAllNamed(AppRoutes.auth);
    
    // Kode asli (dikomentari untuk sementara):
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    // 
    // await Future.delayed(const Duration(seconds: 3));
    // 
    // if (token != null) {
    //   Get.offAllNamed(AppRoutes.bottomnav);
    // } else {
    //   Get.offAllNamed(AppRoutes.auth);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splashimage.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
