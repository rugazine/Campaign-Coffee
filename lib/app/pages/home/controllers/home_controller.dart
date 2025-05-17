import 'package:get/get.dart';
import '../../menu/model/product_model.dart';
import '../../menu/services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxString userName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
    fetchFeaturedProducts();
  }

  Future<void> fetchUserName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        final response = await http.get(
          Uri.parse('https://campaign.rplrus.com/api/user'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body);
          userName.value = userData['name'] ?? '';
        }
      }
    } catch (e) {
      print('Error fetching user name: $e');
    }
  }

  final RxList<String> categories =
      <String>['Coffee', 'Non Coffee', 'Snack', 'Main Course'].obs;

  final RxList<Map<String, dynamic>> promoCards = <Map<String, dynamic>>[
    {
      'title': 'Buy one get\none FREE',
      'tag': 'Promo',
      'image': 'assets/images/banner.png'
    },
    {
      'title': 'Special 50% OFF',
      'tag': 'Promo',
      'image': 'assets/images/banner.png'
    },
    {
      'title': 'New Menu\nDiscount 25%',
      'tag': 'Promo',
      'image': 'assets/images/banner.png'
    }
  ].obs;

  final RxList<Map<String, String>> recommendedProducts = <Map<String, String>>[
    {
      'image': 'assets/images/choco_choco.jpg',
      'name': 'Choco Choco',
      'category': 'Non Coffee',
      'price': 'Rp 15.000'
    },
    {
      'image': 'assets/images/matcha_latte.jpg',
      'name': 'Matcha Latte',
      'category': 'Non Coffee',
      'price': 'Rp 18.000'
    },
    {
      'image': 'assets/images/red_velvet.jpg',
      'name': 'Red Velvet',
      'category': 'Non Coffee',
      'price': 'Rp 20.000'
    },
    {
      'image': 'assets/images/taro_latte.jpg',
      'name': 'Taro Latte',
      'category': 'Non Coffee',
      'price': 'Rp 18.000'
    }
  ].obs;

  Future<void> fetchFeaturedProducts() async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await _productService.getProducts();
      featuredProducts.value = response.take(5).toList();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
