import 'package:get/get.dart';

class CartController extends GetxController {
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

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

    Get.snackbar(
      'Berhasil',
      '${product["name"]} ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateQuantity(int index, bool increment) {
    if (increment) {
      cartItems[index]['quantity']++;
    } else if (cartItems[index]['quantity'] > 1) {
      cartItems[index]['quantity']--;
    }
  }

  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  double get total {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
    );
  }
}
