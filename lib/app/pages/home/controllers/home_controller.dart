import 'package:get/get.dart';
import '../../menu/model/product_model.dart';
import '../../menu/services/product_service.dart';

class HomeController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxString userName = 'John Doe'.obs;

  final RxList<String> categories =
      <String>['Coffee', 'Non Coffee', 'Snack', 'Main Course'].obs;

  final RxList<Map<String, dynamic>> promoCards = <Map<String, dynamic>>[
    {
      'title': 'Buy one get\none FREE',
      'tag': 'Promo',
      'image': 'assets/images/banner.png'
    },
    {
      'title': 'Special 50% OFF',
      'tag': 'Promo',
      'image': 'assets/images/banner.png'
    },
    {
      'title': 'New Menu\nDiscount 25%',
      'tag': 'Promo',
      'image': 'assets/images/banner.png'
    }
  ].obs;

  final RxList<Map<String, String>> recommendedProducts = <Map<String, String>>[
    {
      'image': 'assets/images/choco_choco.jpg',
      'name': 'Choco Choco',
      'category': 'Non Coffee',
      'price': 'Rp 15.000'
    },
    {
      'image': 'assets/images/matcha_latte.jpg',
      'name': 'Matcha Latte',
      'category': 'Non Coffee',
      'price': 'Rp 18.000'
    },
    {
      'image': 'assets/images/red_velvet.jpg',
      'name': 'Red Velvet',
      'category': 'Non Coffee',
      'price': 'Rp 20.000'
    },
    {
      'image': 'assets/images/taro_latte.jpg',
      'name': 'Taro Latte',
      'category': 'Non Coffee',
      'price': 'Rp 18.000'
    }
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedProducts();
  }

  Future<void> fetchFeaturedProducts() async {
  try {
    isLoading.value = true;
    error.value = '';
    final response = await _productService.getProducts();
    featuredProducts.value = response.take(5).toList(); 
  } catch (e) {
    error.value = e.toString();
  } finally {
    isLoading.value = false;
  }
}

}
