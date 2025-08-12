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
  final RxString deliveryAddressDetail =
      'Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai'.obs;
  final RxString pickupAddress = 'Campaign Coffee Shop'.obs;
  final RxString pickupAddressDetail =
      'Jl. Raya Serpong No. 8A, Serpong, Tangerang Selatan'.obs;
  final RxString paymentMethod = 'Midtrans'.obs;
  final RxList<Map<String, dynamic>> orderHistory =
      <Map<String, dynamic>>[].obs;

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

  Future<void> checkoutAndPay(BuildContext context) async {
<<<<<<< HEAD
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
=======
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final checkoutBody = {
      'payment_method': paymentMethod.value,
      'address': isDelivery.value ? deliveryAddressDetail.value : pickupAddressDetail.value,
      'order_type': isDelivery.value ? 'delivery' : 'pickup',
    };
    print('Checkout Body: $checkoutBody');
    final checkoutRes = await http.post(
      Uri.parse('https://campaign.rplrus.com/api/checkout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(checkoutBody),
    );
    final checkoutData = jsonDecode(checkoutRes.body);
    print('Checkout Response: ${checkoutRes.statusCode}, Body: ${checkoutRes.body}');

    if (checkoutRes.statusCode != 200) {
      throw Exception('Checkout gagal: ${checkoutRes.body}');
    }

    final data = checkoutData['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Data tidak ditemukan dalam respons: ${checkoutRes.body}');
    }
    final midtransOrderId = data['midtrans_order_id'];
    final snapToken = data['snap_token'];

    if (snapToken == null || snapToken.isEmpty) {
      throw Exception('Snap token tidak ditemukan: ${checkoutRes.body}');
    }

    print('Checkout initiated - Midtrans Order ID: $midtransOrderId, Snap Token: $snapToken, Address: ${checkoutBody['address']}, Order Type: ${checkoutBody['order_type']}');
>>>>>>> c9f7cf4e598b2ac527d2e3a1918497102da5d28a

    final checkoutDetails = {
      'midtrans_order_id': midtransOrderId,
      'address': checkoutBody['address'],
      'order_type': checkoutBody['order_type'],
    };

    final result = await MidtransDialog.showPaymentDialog(context, snapToken);
    print('Payment dialog result: $result'); // Tambahkan logging untuk memverifikasi hasil

    if (result == 'success') {
      final confirmBody = {
        'midtrans_order_id': checkoutDetails['midtrans_order_id'],
        'status': 'settlement',
        'payment_method': paymentMethod.value,
<<<<<<< HEAD
        'address': isDelivery.value
            ? deliveryAddressDetail.value
            : pickupAddressDetail.value,
        'order_type': isDelivery.value ? 'delivery' : 'pickup',
      };
      print('Checkout Body: $checkoutBody');
      final checkoutRes = await http.post(
        Uri.parse('https://campaign.rplrus.com/api/checkout'),
=======
        'address': checkoutDetails['address'],
        'order_type': checkoutDetails['order_type'],
      };
      print('Confirm Payment Body: $confirmBody'); // Tambahkan logging untuk memverifikasi body
      final confirmRes = await http.post(
        Uri.parse('https://campaign.rplrus.com/api/confirm-payment'),
>>>>>>> c9f7cf4e598b2ac527d2e3a1918497102da5d28a
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(confirmBody),
      );
<<<<<<< HEAD
      final checkoutData = jsonDecode(checkoutRes.body);
      print(
          'Checkout Response: ${checkoutRes.statusCode}, Body: ${checkoutRes.body}');

      if (checkoutRes.statusCode != 200) {
        throw Exception('Checkout gagal: ${checkoutRes.body}');
      }

      final data = checkoutData['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw Exception(
            'Data tidak ditemukan dalam respons: ${checkoutRes.body}');
      }
      final midtransOrderId = data['midtrans_order_id'];
      final snapToken = data['snap_token'];

      if (snapToken == null || snapToken.isEmpty) {
        throw Exception('Snap token tidak ditemukan: ${checkoutRes.body}');
      }

      print(
          'Checkout initiated - Midtrans Order ID: $midtransOrderId, Snap Token: $snapToken, Address: ${checkoutBody['address']}, Order Type: ${checkoutBody['order_type']}');

      final checkoutDetails = {
        'midtrans_order_id': midtransOrderId,
        'address': checkoutBody['address'],
        'order_type': checkoutBody['order_type'],
      };

      final result = await MidtransDialog.showPaymentDialog(context, snapToken);
      print(
          'Payment dialog result: $result'); // Tambahkan logging untuk memverifikasi hasil

      if (result == 'success') {
        final confirmBody = {
          'midtrans_order_id': checkoutDetails['midtrans_order_id'],
          'status': 'settlement',
          'payment_method': paymentMethod.value,
          'address': checkoutDetails['address'],
          'order_type': checkoutDetails['order_type'],
        };
        print(
            'Confirm Payment Body: $confirmBody'); // Tambahkan logging untuk memverifikasi body
        final confirmRes = await http.post(
          Uri.parse('https://campaign.rplrus.com/api/confirm-payment'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(confirmBody),
        );
        print(
            'Confirm Payment Response: ${confirmRes.statusCode}, Body: ${confirmRes.body}');

        if (confirmRes.statusCode == 200) {
          final confirmData = jsonDecode(confirmRes.body);
          final orderId =
              confirmData['order_id'] ?? confirmData['data']['order_id'];
          await cartController.clearCart();

          // Show success popup
          Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Payment Successful',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Pesanan Anda telah berhasil dikonfirmasi!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                      Get.offAllNamed('/bottomnav');
                      Get.find<RxInt>().value = 2;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            barrierDismissible: false,
          );
        } else {
          throw Exception('Konfirmasi pembayaran gagal: ${confirmRes.body}');
        }
      } else if (result == 'closed') {
        // User closed the dialog, check payment status from server
        try {
          final statusRes = await http.get(
            Uri.parse(
                'https://campaign.rplrus.com/api/check-payment-status/${checkoutDetails['midtrans_order_id']}'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          );

          if (statusRes.statusCode == 200) {
            final statusData = jsonDecode(statusRes.body);
            final paymentStatus =
                statusData['status'] ?? statusData['data']?['status'];

            if (paymentStatus == 'settlement' ||
                paymentStatus == 'capture' ||
                paymentStatus == 'success') {
              // Payment was successful, confirm the order
              final confirmBody = {
                'midtrans_order_id': checkoutDetails['midtrans_order_id'],
                'status': 'settlement',
                'payment_method': paymentMethod.value,
                'address': checkoutDetails['address'],
                'order_type': checkoutDetails['order_type'],
              };

              final confirmRes = await http.post(
                Uri.parse('https://campaign.rplrus.com/api/confirm-payment'),
                headers: {
                  'Authorization': 'Bearer $token',
                  'Content-Type': 'application/json',
                },
                body: jsonEncode(confirmBody),
              );

              if (confirmRes.statusCode == 200) {
                await cartController.clearCart();

                // Show success popup
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Payment Successful',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Pesanan Anda telah berhasil dikonfirmasi!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Get.back(); // Close dialog
                            Get.offAllNamed('/bottomnav');
                            Get.find<RxInt>().value = 2;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 12),
                          ),
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  barrierDismissible: false,
                );
                return;
              }
            }
          }

          // If we reach here, payment status is unclear
          await cartController.loadCartFromPrefs();
          Get.snackbar(
            'Info',
            'Status pembayaran sedang diverifikasi. Silakan cek riwayat pesanan Anda.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
          );
        } catch (e) {
          print('Error checking payment status: $e');
          await cartController.loadCartFromPrefs();
          Get.snackbar(
            'Info',
            'Tidak dapat memverifikasi status pembayaran. Silakan cek riwayat pesanan Anda.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      } else if (result == 'failed' || result == null) {
        await cartController.loadCartFromPrefs();
        Get.snackbar(
          'Peringatan',
          result == 'failed'
              ? 'Pembayaran gagal, keranjang tetap ada.'
              : 'Pembayaran dibatalkan, keranjang tetap ada.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: result == 'failed' ? Colors.red : Colors.yellow,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Checkout error: $e');
      Get.snackbar('Error', 'Terjadi kesalahan: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
=======
      print('Confirm Payment Response: ${confirmRes.statusCode}, Body: ${confirmRes.body}');

      if (confirmRes.statusCode == 200) {
        final confirmData = jsonDecode(confirmRes.body);
        final orderId = confirmData['order_id'] ?? confirmData['data']['order_id'];
        await cartController.clearCart();
        Get.offAllNamed('/bottomnav');
        Get.find<RxInt>().value = 2;
        Get.snackbar('Sukses', 'Pesanan berhasil dibuat', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        throw Exception('Konfirmasi pembayaran gagal: ${confirmRes.body}');
      }
    } else if (result == 'failed' || result == null) {
      await cartController.loadCartFromPrefs();
      Get.snackbar(
        'Peringatan',
        result == 'failed' ? 'Pembayaran gagal, keranjang tetap ada.' : 'Pembayaran dibatalkan, keranjang tetap ada.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: result == 'failed' ? Colors.red : Colors.yellow,
        colorText: Colors.white,
      );
>>>>>>> c9f7cf4e598b2ac527d2e3a1918497102da5d28a
    }
  } catch (e) {
    print('Checkout error: $e');
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
      print('API GET ORDER HISTORY: statusCode=' +
          response.statusCode.toString());
      print('API GET ORDER HISTORY BODY: ' + response.body.toString());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('API GET ORDER HISTORY PARSED: ' + data.toString());
        List<OrderModel> orders = [];
        if (data is List) {
          orders = (data as List).map((e) => OrderModel.fromJson(e)).toList();
        } else if (data is Map<String, dynamic> && data.containsKey('data')) {
          orders = (data['data'] as List)
              .map((e) => OrderModel.fromJson(e))
              .toList();
        }
<<<<<<< HEAD
        orderHistory.value = orders
            .map((e) => {
                  'id': e.id,
                  'total_price': e.totalPrice,
                  'status': e.status,
                  'order_type': e.orderType,
                  'payment_method': e.paymentMethod,
                  'created_at': e.createdAt,
                  'items': e.items
                      .map((item) => {
                            'id': item.id,
                            'product_id': item.productId,
                            'product_name': item.productName,
                            'product_image': item.productImage,
                            'price': item.price,
                            'quantity': item.quantity,
                            'size': item.size,
                            'sugar': item.sugar,
                            'temperature': item.temperature,
                          })
                      .toList(),
                })
            .toList();
=======
        orderHistory.value = orders.map((e) => {
          'id': e.id,
          'total_price': e.totalPrice,
          'status': e.status,
          'order_type': e.orderType,
          'payment_method': e.paymentMethod,
          'created_at': e.createdAt,
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
>>>>>>> c9f7cf4e598b2ac527d2e3a1918497102da5d28a
      }
    } catch (e) {
      print('Error fetching order history: $e');
    }
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> c9f7cf4e598b2ac527d2e3a1918497102da5d28a
