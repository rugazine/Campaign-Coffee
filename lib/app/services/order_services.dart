import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  static const String baseUrl ='https://campaign.rplrus.com/api';

  static Future<Map<String, dynamic>> checkout({
    required String paymentMethod,
    required String address,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.post(
      Uri.parse('$baseUrl/checkout'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'payment_method': paymentMethod,
        'address': address,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['data'] != null) {
      return data['data'];
    } else {
      throw Exception(data['data']?['message'] ?? 'Gagal checkout');
    }
  }

  static Future<Map<String, dynamic>> payOrder({required int orderId}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.post(
      Uri.parse('$baseUrl/payment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'order_id': orderId}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['data'] != null) {
      return data['data'];
    } else {
      throw Exception(data['data']?['message'] ?? 'Gagal mendapatkan snap token');
    }
  }
}