import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campaign_coffee/app/pages/cart/controllers/cart_controller.dart';
import 'package:campaign_coffee/app/model/order_model.dart';
import 'package:campaign_coffee/app/services/order_services.dart';
import 'package:campaign_coffee/Midtrans/midtrans_dialog.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderController extends GetxController {
  final RxBool isDelivery = true.obs;
  final CartController cartController = Get.find<CartController>();

  double get totalPrice => cartController.total;

  final RxString deliveryAddress = 'Jl. Kpg Sutoyo'.obs;
  final RxString deliveryAddressDetail = 'Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai'.obs;
  final RxString pickupAddress = 'Campaign Coffee Shop'.obs;
  final RxString pickupAddressDetail = 'Jl. Raya Serpong No. 8A, Serpong, Tangerang Selatan'.obs;
  final RxString paymentMethod = 'Midtrans'.obs;
  final RxList<Map<String, dynamic>> orderHistory = <Map<String, dynamic>>[].obs;

  void toggleDeliveryMethod(bool isDeliverySelected) {
    isDelivery.value = isDeliverySelected;
  }

  void updateDeliveryAddress(String address, String detail) {
    deliveryAddress.value = address;
    deliveryAddressDetail.value = detail;
  }

  void updatePaymentMethod(String method) {
    paymentMethod.value = method;
  }

  // Checkout & Payment
  Future<String> getOrderStatus(int orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('https://campaign.rplrus.com/api/orders/$orderId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print('API GET ORDER STATUS [$orderId]: statusCode=' + response.statusCode.toString());
    print('API GET ORDER STATUS BODY: ' + response.body.toString());
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('API GET ORDER STATUS PARSED: ' + data.toString());
      if (data is Map<String, dynamic> && data.containsKey('status')) {
        return data['status'] ?? 'pending';
      } else if (data is Map<String, dynamic> && data.containsKey('data')) {
        return data['data']['status'] ?? 'pending';
      }
    }
    return 'pending';
  }

  Future<void> waitForOrderPaid(int orderId, {int maxTries = 30, int delaySeconds = 2}) async {
    // maxTries dinaikkan, delay dipercepat
    for (int i = 0; i < maxTries; i++) {
      final status = await getOrderStatus(orderId);
      print('Polling ke-${i + 1}: status order = ' + status.toString());
      if (status == 'paid' || status == 'settlement' || status == 'completed') {
        print('Order sudah paid/settlement/completed!');
        return;
      }
      await Future.delayed(Duration(seconds: delaySeconds));
    }
    throw Exception('Pembayaran belum selesai');
  }

  Future<void> waitForOrderPaidWithLoading(BuildContext context, int orderId, {int maxSeconds = 120}) async {
    // maxSeconds dinaikkan agar polling lebih lama
    final start = DateTime.now();
    bool isDialogOpen = false;
    // Tampilkan loading indicator
    Future.delayed(Duration.zero, () {
      isDialogOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    });
    try {
      while (DateTime.now().difference(start).inSeconds < maxSeconds) {
        final status = await getOrderStatus(orderId);
        print('Polling (loading) status order = ' + status.toString());
        if (status == 'paid' || status == 'settlement' || status == 'completed') {
          print('Order sudah paid/settlement/completed! (loading)');
          return;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
      throw Exception('Pembayaran belum selesai');
    } finally {
      if (isDialogOpen) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future<void> checkoutAndPay(BuildContext context) async {
    try {
      // 1. Checkout
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final checkoutBody = {
        'payment_method': paymentMethod.value,
        'address': isDelivery.value ? deliveryAddressDetail.value : pickupAddressDetail.value,
        'order_type': isDelivery.value ? 'delivery' : 'pickup',
      };
      print('DATA CHECKOUT DIKIRIM: ' + checkoutBody.toString());
      final checkoutRes = await http.post(
        Uri.parse('https://campaign.rplrus.com/api/checkout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(checkoutBody),
      );
      print('CHECKOUT STATUS: ' + checkoutRes.statusCode.toString());
      print('CHECKOUT BODY: ' + checkoutRes.body.toString());
      final checkoutData = jsonDecode(checkoutRes.body);
      final orderId = checkoutData['data']?['order_id'];

      // 2. Payment
      final paymentBody = {'order_id': orderId};
      print('DATA PAYMENT DIKIRIM: ' + paymentBody.toString());
      final paymentRes = await http.post(
        Uri.parse('https://campaign.rplrus.com/api/payment'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(paymentBody),
      );
      print('PAYMENT STATUS: ' + paymentRes.statusCode.toString());
      print('PAYMENT BODY: ' + paymentRes.body.toString());
      final paymentData = jsonDecode(paymentRes.body);
      final snapToken = paymentData['data']?['snap_token'] ?? '';
      if (snapToken == null || snapToken == '') {
        throw Exception('Snap token tidak ditemukan di response: ' + paymentRes.body.toString());
      }

      // 3. Buka dialog pembayaran Midtrans
      final result = await MidtransDialog.showPaymentDialog(context, snapToken);
      if (result == 'success') {
        try {
          await waitForOrderPaidWithLoading(context, orderId); // Polling status order dengan loading
          await cartController.clearCart();
          // Navigasi ke halaman history di bottom nav (indeks 2)
          Get.offAllNamed('/bottomnav');
          // Set indeks bottom navigation ke halaman history (indeks 2)
          Get.find<RxInt>().value = 2;
          Get.snackbar('Sukses', 'Pesanan berhasil dibuat', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
        } catch (_) {
          Get.snackbar('Pembayaran belum selesai', 'Silakan tunggu beberapa saat lalu cek kembali status pesanan.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
        }
        return;
      }
      // Jika user keluar dari pembayaran (back), cek status juga
      final status = await getOrderStatus(orderId);
      if (status == 'paid' || status == 'settlement' || status == 'completed') {
        await cartController.clearCart();
        // Navigasi ke halaman history di bottom nav (indeks 2)
        Get.offAllNamed('/bottomnav');
        // Set indeks bottom navigation ke halaman history (indeks 2)
        Get.find<RxInt>().value = 2;
        Get.snackbar('Sukses', 'Pesanan berhasil dibuat', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Pembayaran belum selesai', 'Silakan selesaikan pembayaran untuk pesanan ini.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.orange, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', 'Terjadi kesalahan: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<void> fetchOrderHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) return;
      final response = await http.get(
        Uri.parse('https://campaign.rplrus.com/api/orders'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print('API GET ORDER HISTORY: statusCode=' + response.statusCode.toString());
      print('API GET ORDER HISTORY BODY: ' + response.body.toString());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API GET ORDER HISTORY PARSED: ' + data.toString());
        List<OrderModel> orders = [];
        if (data is List) {
          orders = (data as List).map((e) => OrderModel.fromJson(e)).toList();
        } else if (data is Map<String, dynamic> && data.containsKey('data')) {
          orders = (data['data'] as List).map((e) => OrderModel.fromJson(e)).toList();
        }
        orderHistory.value = orders.map((e) => {
          'id': e.id,
          'total_price': e.totalPrice,
          'status': e.status,
          'order_type': e.orderType,
          'payment_method': e.paymentMethod,
          'created_at': e.createdAt, // <-- Perbaiki di sini
          'items': e.items.map((item) => {
            'id': item.id,
            'product_id': item.productId,
            'product_name': item.productName,
            'product_image': item.productImage,
            'price': item.price,
            'quantity': item.quantity,
            'size': item.size,
            'sugar': item.sugar,
            'temperature': item.temperature,
          }).toList(),
        }).toList();
      }
    } catch (e) {
      print('Error fetching order history: $e');
  }
}
}