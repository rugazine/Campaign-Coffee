import 'package:campaign_coffee/app/pages/auth/Login/controller/login_controller.dart';
import 'package:campaign_coffee/app/pages/cart/controllers/cart_controller.dart';
import 'package:campaign_coffee/app/pages/home/controllers/detail_controller.dart';
import 'package:campaign_coffee/app/pages/home/controllers/home_controller.dart';
import 'package:campaign_coffee/app/pages/order/controllers/order_controller.dart';
import 'package:campaign_coffee/app/pages/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DetailController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => OrderController());
    Get.lazyPut(() => ProfileController());
  }
}
