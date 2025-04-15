import 'package:get/get.dart';

class HomeController extends GetxController {
  // State untuk nama user
  final userName = 'Ruga Zinedine'.obs;

  // State untuk promo cards
  final promoCards = [
    {
      'title': 'Buy one get\none FREE',
      'image': 'assets/images/banner.png',
    },
    {
      'title': 'Buy one get\none FREE',
      'image': 'assets/images/banner.png',
    },
    {
      'title': 'Buy one get\none FREE',
      'image': 'assets/images/banner.png',
    },
  ].obs;

  // State untuk kategori
  final categories = [
    'Coffee',
    'Non Coffee',
    'Snack',
    'Main Course',
  ].obs;

  // State untuk rekomendasi produk
  final recommendedProducts = [
    {
      'image': 'assets/images/choco_choco.jpg',
      'name': 'Choco - Choco',
      'category': 'Chocolate',
      'price': 'Rp. 15000',
    },
    {
      'image': 'assets/images/matcha_latte.jpg',
      'name': 'Matcha Latte',
      'category': 'Matcha',
      'price': 'Rp. 15000',
    },
    {
      'image': 'assets/images/taro_latte.jpg',
      'name': 'Taro Latte',
      'category': 'Taro',
      'price': 'Rp. 15000',
    },
    {
      'image': 'assets/images/red_velvet.jpg',
      'name': 'Red Velvet',
      'category': 'Red Velvet',
      'price': 'Rp. 15000',
    },
    {
      'image': 'assets/images/choco_choco.jpg',
      'name': 'Choco - Choco',
      'category': 'Chocolate',
      'price': 'Rp. 15000',
    },
    {
      'image': 'assets/images/matcha_latte.jpg',
      'name': 'Matcha Latte',
      'category': 'Matcha',
      'price': 'Rp. 15000',
    },
  ].obs;
}
