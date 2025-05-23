import 'package:get/get.dart';
import '../model/product_model.dart';
import '../services/product_service.dart';

class MenuController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString selectedCategory = 'Coffee'.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  List<ProductModel> get filteredProducts {
    if (searchQuery.isNotEmpty) {
      final searchResults = products.where((product) {
        return product.name
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            product.description
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase());
      }).toList();

      if (searchResults.isNotEmpty) {
        // Update category if search finds product in different category
        final firstResult = searchResults.first;
        if (firstResult.category.toLowerCase() !=
            selectedCategory.value.toLowerCase()) {
          selectedCategory.value = firstResult.category;
        }
        return searchResults;
      }
    }

    // If no search query or no results, filter by selected category
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

  void setSelectedCategory(String category) {
    selectedCategory.value = category;
  }
}
