import 'package:get/get.dart';

class DetailController extends GetxController {
  // Observable state variables
  final _selectedSugar = 'Normal'.obs;
  final _selectedTemperature = 'Ice'.obs;
  final _isFavorite = false.obs;

  // Getters
  String get selectedSugar => _selectedSugar.value;
  String get selectedTemperature => _selectedTemperature.value;
  bool get isFavorite => _isFavorite.value;

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

  void addToCart() {
    // TODO: Implement cart functionality
    Get.snackbar(
      'Success',
      'Item added to cart',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
