import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryController extends GetxController {
  final historyItems = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistoryFromPrefs();
  }

  Future<void> loadHistoryFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString('history_items');
      if (historyJson != null) {
        final decodedHistory = json.decode(historyJson) as List;
        historyItems.value = List<Map<String, dynamic>>.from(decodedHistory);
      }
    } catch (e) {
      print('Error loading history: $e');
    }
  }

  Future<void> addToHistory(List<Map<String, dynamic>> items,
      String paymentMethod, double totalPrice) async {
    try {
      final now = DateTime.now();
      final orderHistory = {
        'date': '${now.day} ${_getMonthName(now.month)} ${now.year}',
        'time':
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
        'status': 'Processing',
        'order_id': '#ORD${now.millisecondsSinceEpoch.toString().substring(7)}',
        'payment_method': paymentMethod,
        'items': items,
        'total_price': totalPrice,
      };

      historyItems.insert(0, orderHistory);
      await _saveHistoryToPrefs();
    } catch (e) {
      print('Error adding to history: $e');
    }
  }

  Future<void> _saveHistoryToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = json.encode(historyItems.toList());
      await prefs.setString('history_items', historyJson);
    } catch (e) {
      print('Error saving history: $e');
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}
