import 'package:get/get.dart';
import 'package:campaign_coffee/pages/cart/controllers/cart_controller.dart';

class DetailController extends GetxController {
  // Observable state variables
  final _selectedSugar = 'Normal'.obs;
  final _selectedTemperature = 'Ice'.obs;
  final _isFavorite = false.obs;
  final _price = 15000.obs;
  final _productName = 'Choco Choco'.obs;
  final _productImage = 'assets/images/choco_choco.jpg'.obs;

  // Getters
  String get selectedSugar => _selectedSugar.value;
  String get selectedTemperature => _selectedTemperature.value;
  bool get isFavorite => _isFavorite.value;
  int get price => _price.value;
  String get productName => _productName.value;
  String get productImage => _productImage.value;

  // Methods to update state
  void setSugar(String sugar) {
    _selectedSugar.value = sugar;
  }

  void setTemperature(String temperature) {
    _selectedTemperature.value = temperature;
  }

  void toggleFavorite() {
    _isFavorite.value = !_isFavorite.value;
  }

  // Mengatur data produk
  void setProductData(String name, int productPrice, String image) {
    _productName.value = name;
    _price.value = productPrice;
    _productImage.value = image;
  }

  void addToCart() {
    // Dapatkan instance CartController
    final CartController cartController = Get.find<CartController>();

    // Buat objek produk untuk ditambahkan ke keranjang
    Map<String, dynamic> product = {
      'name': productName,
      'price': price,
      'quantity': 1,
      'image': productImage,
      'sugar': selectedSugar,
      'temperature': selectedTemperature,
    };

    // Tambahkan ke keranjang
    cartController.addToCart(product);
  }
}
