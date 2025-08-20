import 'package:get/get.dart';
import '../../menu/model/product_model.dart';
import '../../menu/services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class HomeController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxString userName = ''.obs;

  final RxList<Map<String, dynamic>> promoCards = <Map<String, dynamic>>[].obs;
  final RxList<ProductModel> recommendedProducts = <ProductModel>[].obs;

  // Carousel controller
  late PageController pageController;
  final RxInt currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(viewportFraction: 0.85);

    // Add listener for page changes
    pageController.addListener(() {
      if (pageController.page != null) {
        currentPage.value = pageController.page!.round();
      }
    });

    fetchUserName();
    fetchPromos();
    fetchFeaturedProducts();
    fetchRecommendedProducts();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
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

  Future<void> fetchPromos() async {
    try {
      final response = await http
          .get(Uri.parse('https://campaign.rplrus.com/api/promotions'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] is List) {
          promoCards.value = List<Map<String, dynamic>>.from(
            data['data'].map((promo) => {
                  'title': promo['title'] ?? '',
                  'image': promo['image'] != null
                      ? promo['image']
                      : 'assets/images/banner.png',
                }),
          );
        }
      }
    } catch (e) {
      print('Error fetching promos: $e');
    }
  }

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

  Future<void> fetchRecommendedProducts() async {
    try {
      final response = await _productService.getProducts();
      // Ambil 4 produk teratas sebagai rekomendasi
      recommendedProducts.value = response.take(6).toList();
    } catch (e) {
      print('Error fetching recommended products: $e');
    }
  }
}
