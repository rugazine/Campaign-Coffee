import 'package:get/get.dart';
import 'package:campaign_coffee/pages/cart/controllers/cart_controller.dart';

class OrderController extends GetxController {
  // Delivery method options
  final RxBool isDelivery = true.obs;

  // Get cart controller to access cart items
  final CartController cartController = Get.find<CartController>();

  // Calculate total price from cart items
  double get totalPrice => cartController.total;

  // Delivery address
  final RxString deliveryAddress = 'Jl. Kpg Sutoyo'.obs;
  final RxString deliveryAddressDetail =
      'Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai'.obs;

  // Pickup address
  final RxString pickupAddress = 'Campaign Coffee Shop'.obs;
  final RxString pickupAddressDetail =
      'Jl. Raya Serpong No. 8A, Serpong, Tangerang Selatan'.obs;

  // Payment method
  final RxString paymentMethod = 'Midtrans'.obs;

  // Toggle delivery method
  void toggleDeliveryMethod(bool isDeliverySelected) {
    isDelivery.value = isDeliverySelected;
  }

  // Update delivery address
  void updateDeliveryAddress(String address, String detail) {
    deliveryAddress.value = address;
    deliveryAddressDetail.value = detail;
  }

  // Update payment method
  void updatePaymentMethod(String method) {
    paymentMethod.value = method;
  }

  // Process order
  void processOrder() {
    // Implement order processing logic here
    // This could include API calls, validation, etc.
    print('Processing order with ${cartController.cartItems.length} items');
    print('Delivery method: ${isDelivery.value ? "Delivery" : "Pickup"}');
    print('Total price: Rp ${totalPrice.toStringAsFixed(0)}');
  }
}
