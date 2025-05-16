import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadCartFromPrefs();
  }

  Future<void> clearCart() async {
    cartItems.clear();
    final userId = await getUserId();
    if (userId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cart_items_$userId');
    }
  }

  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
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
          return userData['id'].toString();
        }
      }
      return null;
    } catch (e) {
      print('Error getting user ID: $e');
      return null;
    }
  }

  Future<void> saveCartToPrefs() async {
    final userId = await getUserId();
    if (userId != null) {
      final prefs = await SharedPreferences.getInstance();
      final String cartJson = jsonEncode(cartItems.toList());
      await prefs.setString('cart_items_$userId', cartJson);
    }
  }

  Future<void> loadCartFromPrefs() async {
    final userId = await getUserId();
    if (userId != null) {
      final prefs = await SharedPreferences.getInstance();
      final String? cartJson = prefs.getString('cart_items_$userId');
      if (cartJson != null) {
        final List<dynamic> decodedItems = jsonDecode(cartJson);
        cartItems.value = List<Map<String, dynamic>>.from(decodedItems);
      } else {
        cartItems.clear();
      }
    } else {
      cartItems.clear();
    }
  }

  void addToCart(Map<String, dynamic> product) {
    int existingIndex = cartItems.indexWhere((item) =>
        item['name'] == product['name'] &&
        item['sugar'] == product['sugar'] &&
        item['temperature'] == product['temperature']);

    if (existingIndex != -1) {
      cartItems[existingIndex]['quantity']++;
    } else {
      cartItems.add(product);
    }

    saveCartToPrefs();
    saveCartToAPI(product);
    Get.snackbar(
      'Berhasil',
      '${product["name"]} ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateQuantity(int index, bool increment) {
    if (index >= 0 && index < cartItems.length) {
      if (increment) {
        final updatedItem = Map<String, dynamic>.from(cartItems[index]);
        updatedItem['quantity']++;
        cartItems[index] = updatedItem;
      } else if (cartItems[index]['quantity'] > 1) {
        final updatedItem = Map<String, dynamic>.from(cartItems[index]);
        updatedItem['quantity']--;
        cartItems[index] = updatedItem;
      }
      saveCartToPrefs();
      cartItems.refresh();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      saveCartToPrefs();
    }
  }

  double get total {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
    );
  }

  Future<void> saveCartToAPI(Map<String, dynamic> product) async {
    try {
      // Mendapatkan token dari SharedPreferences atau sistem autentikasi
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse('https://campaign.rplrus.com/api/cart'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': token != null ? 'Bearer $token' : '',
        },
        body: jsonEncode({
          'product_id': product['id'] ?? 1,
          'quantity': product['quantity'] ?? 1,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Item berhasil disimpan ke API');
        print(response.body);
      } else if (response.statusCode == 401) {
        print('Autentikasi diperlukan untuk menyimpan ke keranjang');
        Get.snackbar(
          'Perhatian',
          'Silakan login untuk menyimpan item ke keranjang',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        print('Gagal menyimpan item ke API: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error saat menyimpan ke API: $e');
    }
  }
}
