import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campaign_coffee/app/pages/cart/controllers/cart_controller.dart';
import 'package:campaign_coffee/app/pages/menu/services/product_service.dart';

class DetailController extends GetxController {
  final _selectedSugar = 'Normal'.obs;
  final _selectedTemperature = 'Ice'.obs;
  final _isFavorite = false.obs;
  final _price = 15000.obs;
  final _productName = 'Choco Choco'.obs;
  final _productImage = 'assets/images/choco_choco.jpg'.obs;
  final _productId = 0.obs;
  final _stock = 0.obs;
  final _description = 'A cappuccino is an approximately 150 ml (5 oz) beverage, with 25 ml of espresso coffee and 85ml of fresh milk foam...'.obs;

  String get selectedSugar => _selectedSugar.value;
  String get selectedTemperature => _selectedTemperature.value;
  bool get isFavorite => _isFavorite.value;
  int get price => _price.value;
  String get productName => _productName.value;
  String get productImage => _productImage.value;
  int get productId => _productId.value;
  int get stock => _stock.value;
  String get description => _description.value;
  bool get isOutOfStock => _stock.value <= 0;

  void setSugar(String sugar) {
    _selectedSugar.value = sugar;
  }

  void setTemperature(String temperature) {
    _selectedTemperature.value = temperature;
  }

  void toggleFavorite() {
    _isFavorite.value = !_isFavorite.value;
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final ProductService _productService = ProductService();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['id'] != null) {
      _productId.value = Get.arguments['id'];
      fetchProductDetail(_productId.value);
    }
  }

  void setProductData(
      String? name, dynamic productPrice, String? image, int? id,
      {int? stock, String? description}) {
    _productName.value = name ?? 'Choco Choco';
    _price.value = (productPrice is double)
        ? productPrice.toInt()
        : (productPrice ?? 15000);
    _productImage.value = image ?? 'assets/images/choco_choco.jpg';
    _productId.value = id ?? 0;
    _stock.value = stock ?? 0;
    _description.value = description ?? 'A cappuccino is an approximately 150 ml (5 oz) beverage, with 25 ml of espresso coffee and 85ml of fresh milk foam...';
  }

  Future<void> fetchProductDetail(int productId) async {
    try {
      _isLoading.value = true;
      final product = await _productService.getProductById(productId);

      setProductData(
        product.name,
        product.price,
        product.image,
        product.id,
        stock: product.stock,
        description: product.description,
      );
    } catch (e) {
      print('Error fetching product detail: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat detail produk: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> addToCart() async {
    try {
      if (isOutOfStock) {
        Get.snackbar(
          'Stok Habis',
          'Maaf, produk ini sedang tidak tersedia',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (!Get.isRegistered<CartController>()) {
        Get.put(CartController());
      }
      final cartController = Get.find<CartController>();

      print('Adding product to cart with ID: $_productId');
      Map<String, dynamic> product = {
        'product_id': _productId.value,
        'name': productName,
        'price': price, // harga produk asli
        'quantity': 1,
        'image': productImage,
        'sugar': selectedSugar, // pilihan user
        'temperature': selectedTemperature, // pilihan user
      };

      await cartController.addToCart(product);

      // Setelah berhasil tambah ke cart, reload cart dari server
      await cartController.loadCartFromPrefs();

      Get.offNamed('/menu');
    } catch (e) {
      print('Error in DetailController addToCart: $e');
      Get.snackbar(
        'Error',
        'Gagal menambahkan ke keranjang: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
