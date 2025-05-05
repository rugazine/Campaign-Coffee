import 'package:get/get.dart';
import '../model/product_model.dart';
import '../services/product_service.dart';

class MenuController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = 'Coffee'.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      error.value = '';
      final response = await _productService.getProducts();
      products.value = response;
    } catch (e) {
      error.value = e.toString();
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<ProductModel> get filteredProducts {
    return products.where((product) {
      final productCategory = product.category.toLowerCase();
      final selected = selectedCategory.value.toLowerCase();

      return productCategory == selected ||
          (selected == 'coffee' && productCategory == 'coffee') ||
          (selected == 'non coffee' && productCategory == 'non coffee') ||
          (selected == 'main course' && productCategory == 'main course') ||
          (selected == 'snack' && productCategory == 'snack');
    }).toList();
  }

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }
}
