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
      page: () =>  HomePage(),
    ),
    GetPage(
      name: detail,
      page: () =>  DetailPage(),
    ),
    GetPage(
      name: bottomnav,
      page: () =>  BottomNav(),
    ),
    GetPage(
      name: menu,
      page: () =>  MenuPage(),
    ),
    GetPage(
      name: history,
      page: () =>  HistoryPage(),
    ),
    GetPage(
      name: profile,
      page: () =>  ProfilePage(),
    ),
    GetPage(
      name: order,
      page: () =>  OrderPage(),
    ),
  ];
}
