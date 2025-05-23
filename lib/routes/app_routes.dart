import 'package:campaign_coffee/app/pages/bottomnav/bottom_nav.dart';
import 'package:campaign_coffee/app/pages/cart/cart_page.dart';
import 'package:get/get.dart';
import '../app/pages/auth/auth/auth_page.dart';
import '../app/pages/auth/Login/login_page.dart';
import '../app/pages/auth/Register/register_page.dart';
import '../app/pages/home/pages/homepage.dart';
import '../app/pages/detail/pages/detail_page.dart';
import '../app/pages/menu/pages/menu_page.dart';
import '../app/pages/history/history_page.dart';
import '../app/pages/profile/pages/profile_page.dart';
import '../app/pages/order/order_page.dart';
import '../app/pages/splash/splash_screen.dart';
import '../app/pages/profile/pages/help/help_page.dart';

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
  static const String splash = '/splash';
  static const String help = '/help';
    static const String cart = '/cart';


  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: auth,
      page: () => AuthPage(),
    ),
    GetPage(
      name: login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: home,
      page: () => HomePage(),
    ),
    GetPage(
      name: detail,
      page: () => DetailPage(),
    ),
    GetPage(
      name: help,
      page: () => const HelpPage(),
    ),
    GetPage(
      name: bottomnav,
      page: () => BottomNav(),
    ),
    GetPage(
      name: menu,
      page: () => MenuPage(),
    ),
    GetPage(
      name: history,
      page: () => HistoryPage(),
    ),
    GetPage(
      name: profile,
      page: () => ProfilePage(),
    ),
    GetPage(
      name: order,
      page: () => OrderPage(),
    ),
    GetPage(
      name: cart,
      page: () => CartPage(),
    ),
  ];
}
