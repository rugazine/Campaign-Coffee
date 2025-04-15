import 'package:get/get.dart';

class CartController extends GetxController {
  // Observable list untuk menyimpan item keranjang
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  // Menambahkan item ke keranjang
  void addToCart(Map<String, dynamic> product) {
    // Cek apakah produk sudah ada di keranjang
    int existingIndex = cartItems.indexWhere((item) =>
        item['name'] == product['name'] &&
        item['sugar'] == product['sugar'] &&
        item['temperature'] == product['temperature']);

    if (existingIndex != -1) {
      // Jika produk sudah ada, tambahkan quantity
      cartItems[existingIndex]['quantity']++;
    } else {
      // Jika produk belum ada, tambahkan ke keranjang
      cartItems.add(product);
    }

    // Tampilkan notifikasi
    Get.snackbar(
      'Berhasil',
      '${product["name"]} ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // Mengupdate quantity item
  void updateQuantity(int index, bool increment) {
    if (increment) {
      cartItems[index]['quantity']++;
    } else if (cartItems[index]['quantity'] > 1) {
      cartItems[index]['quantity']--;
    }
  }

  // Menghapus item dari keranjang
  void removeItem(int index) {
    cartItems.removeAt(index);
  }

  // Menghitung total harga
  double get total {
    return cartItems.fold(
      0,
      (sum, item) => sum + (item['price'] as int) * (item['quantity'] as int),
    );
  }
}
