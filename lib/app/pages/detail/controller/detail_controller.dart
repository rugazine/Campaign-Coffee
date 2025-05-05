import 'package:get/get.dart';
import 'package:campaign_coffee/app/pages/cart/controllers/cart_controller.dart';

class DetailController extends GetxController {
  final _selectedSugar = 'Normal'.obs;
  final _selectedTemperature = 'Ice'.obs;
  final _isFavorite = false.obs;
  final _price = 15000.obs;
  final _productName = 'Choco Choco'.obs;
  final _productImage = 'assets/images/choco_choco.jpg'.obs;

  String get selectedSugar => _selectedSugar.value;
  String get selectedTemperature => _selectedTemperature.value;
  bool get isFavorite => _isFavorite.value;
  int get price => _price.value;
  String get productName => _productName.value;
  String get productImage => _productImage.value;

  void setSugar(String sugar) {
    _selectedSugar.value = sugar;
  }

  void setTemperature(String temperature) {
    _selectedTemperature.value = temperature;
  }

  void toggleFavorite() {
    _isFavorite.value = !_isFavorite.value;
  }

  void setProductData(String name, dynamic productPrice, String image) {
    _productName.value = name;
    _price.value = (productPrice is double)
        ? productPrice.toInt()
        : (productPrice ?? 15000);
    _productImage.value = image;
  }

  void addToCart() {
    final CartController cartController = Get.find<CartController>();

    Map<String, dynamic> product = {
      'id': 9, // Later you can pass real id if needed
      'name': productName,
      'price': price,
      'quantity': 1,
      'image': productImage,
      'sugar': selectedSugar,
      'temperature': selectedTemperature,
    };

    cartController.addToCart(product);
  }
}
