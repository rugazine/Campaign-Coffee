import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:campaign_coffee/routes/app_routes.dart';

class CartController extends GetxController {
  final cartItems = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromPrefs();
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token from SharedPreferences: $token');
    return token;
  }

  Future<void> checkAuth() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Silakan login terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      Get.toNamed(AppRoutes.login);
      return;
    }
  }

  Future<void> clearCart() async {
    cartItems.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cart_items');
    // Hapus cart di backend juga
    try {
      final token = await getToken();
      if (token != null) {
        final response = await http.delete(
          Uri.parse('https://campaign.rplrus.com/api/cart'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print('Clear Cart (server) Response: ${response.statusCode}');
        print('Clear Cart (server) Body: ${response.body}');
      }
    } catch (e) {
      print('Error clearing cart on server: ${e.toString()}');
    }
  }

  Future<void> loadCartFromPrefs() async {
    try {
      final token = await getToken();
      if (token == null) {
        cartItems.clear();
        return;
      }

      final response = await http.get(
        Uri.parse('https://campaign.rplrus.com/api/cart'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Load Cart Response: ${response.statusCode}');
      print('Load Cart Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          cartItems.value = List<Map<String, dynamic>>.from(data);
        } else if (data is Map<String, dynamic> && data.containsKey('data')) {
          cartItems.value = List<Map<String, dynamic>>.from(data['data']);
        } else {
          cartItems.value = [];
        }
      } else if (response.statusCode == 401) {
        cartItems.clear();
        Get.toNamed(AppRoutes.login);
      }
    } catch (e) {
      print('Error loading cart: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat keranjang',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    try {
      final token = await getToken();
      if (token == null) {
        Get.snackbar(
          'Perhatian',
          'Silakan login terlebih dahulu',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        Get.toNamed(AppRoutes.login);
        return;
      }

      print('Product data received: $product');
      final requestBody = {
        'product_id': product['product_id'],
        'quantity': product['quantity'] ?? 1,
        'sugar': product['sugar'] ?? 'Normal',
        'temperature': product['temperature'] ?? 'Ice',
      };
      print('Sending request to API: $requestBody');

      final response = await http.post(
        Uri.parse('https://campaign.rplrus.com/api/cart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('Add to Cart Response: ${response.statusCode}');
      print('Add to Cart Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        await loadCartFromPrefs(); // Refresh cart data from server
      } else {
        throw Exception(json.decode(response.body)['message'] ??
            'Gagal menambahkan ke keranjang');
      }
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Gagal menambahkan ke keranjang: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  double get total {
    return cartItems.fold(
      0.0,
      (sum, item) {
        final price = item['product']?['price'] ?? item['price'] ?? '0';
        final quantity = item['quantity'] ?? 1;
        return sum + (double.parse(price.toString()) * quantity);
      },
    );
  }

  Future<void> updateQuantity(int index, bool increment) async {
    try {
      final token = await getToken();
      if (token == null) {
        Get.toNamed(AppRoutes.login);
        return;
      }

      final item = cartItems[index];
      final product = item['product'] ?? item;
      final int productId = int.tryParse(product['id'].toString()) ?? 0;
      final int currentQty = int.tryParse(item['quantity'].toString()) ?? 1;
      final int newQuantity = increment ? currentQty + 1 : currentQty - 1;

      if (newQuantity <= 0) {
        await removeItem(index);
        return;
      }

      // Ganti dari PUT ke POST
      final response = await http.post(
        Uri.parse('https://campaign.rplrus.com/api/cart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'product_id': productId,
          'quantity': newQuantity,
          'sugar': item['sugar'] ?? 'Normal',
          'temperature': item['temperature'] ?? 'Ice',
        }),
      );

      print('Update Quantity Response: ${response.statusCode}');
      print('Update Quantity Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await loadCartFromPrefs(); // Refresh cart from server
      } else if (response.statusCode == 401) {
        Get.toNamed(AppRoutes.login);
      }
    } catch (e) {
      print('Error updating quantity: $e');
      Get.snackbar(
        'Error',
        'Gagal mengubah jumlah',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> removeItem(int index) async {
    try {
      final token = await getToken();
      if (token == null) {
        Get.toNamed(AppRoutes.login);
        return;
      }

      final item = cartItems[index];
      final response = await http.delete(
        Uri.parse('https://campaign.rplrus.com/api/cart/${item['id']}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print('Remove Item Response: ${response.statusCode}');
      print('Remove Item Body: ${response.body}');

      if (response.statusCode == 200) {
        await loadCartFromPrefs(); // Refresh cart from server
      } else if (response.statusCode == 401) {
        Get.toNamed(AppRoutes.login);
      }
    } catch (e) {
      print('Error removing item: $e');
      Get.snackbar(
        'Error',
        'Gagal menghapus item',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
