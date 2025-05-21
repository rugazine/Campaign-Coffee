import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromPrefs();
  }

  Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(
          'token'); // Perhatikan token key ini, jangan sampai beda dengan token di saveCartToAPI
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

  // Clear cart dan prefs
  Future<void> clearCart() async {
    cartItems.clear();
    final userId = await getUserId();
    if (userId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('cart_items_$userId');
    }
  }

  void addToCart(Map<String, dynamic> product) {
    int existingIndex = cartItems.indexWhere((item) =>
        item['name'] == product['name'] &&
        item['sugar'] == product['sugar'] &&
        item['temperature'] == product['temperature']);

    if (existingIndex != -1) {
      // Jika sudah ada, update quantity dengan copy map (untuk trigger reaktif)
      final updatedItem = Map<String, dynamic>.from(cartItems[existingIndex]);
      updatedItem['quantity'] = (updatedItem['quantity'] ?? 1) + 1;
      cartItems[existingIndex] = updatedItem;
    } else {
      // Baru, pastikan ada quantity
      final newItem = Map<String, dynamic>.from(product);
      newItem['quantity'] = 1;
      cartItems.add(newItem);
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
      final currentItem = cartItems[index];
      int currentQty = currentItem['quantity'] ?? 1;

      if (increment) {
        final updatedItem = Map<String, dynamic>.from(currentItem);
        updatedItem['quantity'] = currentQty + 1;
        cartItems[index] = updatedItem;
      } else if (currentQty > 1) {
        final updatedItem = Map<String, dynamic>.from(currentItem);
        updatedItem['quantity'] = currentQty - 1;
        cartItems[index] = updatedItem;
      } else {
        // Kalau quantity sudah 1 dan dikurangi, hapus item
        removeItem(index);
        return; // skip saveCartToPrefs dan refresh karena sudah di removeItem
      }

      saveCartToPrefs();
      cartItems.refresh();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < cartItems.length) {
      cartItems.removeAt(index);
      saveCartToPrefs();
      cartItems.refresh();
    }
  }

  double get total {
    return cartItems.fold(
      0,
      (sum, item) {
        final price = item['price'];
        final quantity = item['quantity'] ?? 1;
        double priceDouble = 0;

        if (price is int) {
          priceDouble = price.toDouble();
        } else if (price is double) {
          priceDouble = price;
        }

        return sum + (priceDouble * quantity);
      },
    );
  }

  Future<void> saveCartToAPI(Map<String, dynamic> product) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString(
          'token'); // Disini juga pake 'token' supaya konsisten dengan getUserId

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
