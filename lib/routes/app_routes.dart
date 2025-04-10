import 'package:campaign_coffee/pages/bottomnav/bottom_nav.dart';
import 'package:get/get.dart';
import '../pages/auth/auth_page.dart';
import '../pages/auth/Login/login_page.dart';
import '../pages/auth/Register/register_page.dart';
import '../pages/home/pages/homepage.dart';
import '../pages/home/pages/detail_page.dart';
import '../pages/home/pages/menu_page.dart';
import '../pages/history/history_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/order/order_page.dart';

class AppRoutes {
  static const String auth = '/auth';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String detail = '/detail';
  static const String bottomnav = '/bottomnav';
  static const String menu = '/menu';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String order = '/order';

  static final routes = [
    GetPage(
      name: auth,
      page: () => const AuthPage(),
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: register,
      page: () => const RegisterPage(),
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: detail,
      page: () => const DetailPage(),
    ),
    GetPage(
      name: bottomnav,
      page: () => const BottomNav(),
    ),
    GetPage(
      name: menu,
      page: () => const MenuPage(),
    ),
    GetPage(
      name: history,
      page: () => const HistoryPage(),
    ),
    GetPage(
      name: profile,
      page: () => const ProfilePage(),
    ),
    GetPage(
      name: order,
      page: () => const OrderPage(),
    ),
  ];
}
