import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campaign_coffee/app/pages/order/controllers/order_controller.dart';
import 'dart:async';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final OrderController orderController;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    orderController = Get.put(OrderController());
    orderController.fetchOrderHistory();
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      orderController.fetchOrderHistory();
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  String _getProductImage(String productName) {
    switch (productName.toLowerCase()) {
      case 'matcha latte':
        return 'assets/images/matcha_latte.jpg';
      case 'taro latte':
        return 'assets/images/taro_latte.jpg';
      case 'red velvet':
        return 'assets/images/red_velvet.jpg';
      case 'choco choco':
        return 'assets/images/choco_choco.jpg';
      default:
        return 'assets/images/coffee.png';
    }
  }

  String _formatDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return '-';
    try {
      final dt = DateTime.parse(dateTimeStr);
      final date =
          '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
      final time =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      return '$date $time';
    } catch (e) {
      return dateTimeStr;
    }
  }

  String getPaymentMethodLabel(String? method) {
    switch (method) {
      case 'qris':
        return 'QRIS';
      case 'gopay':
        return 'GoPay';
      case 'bank_transfer':
        return 'Transfer Bank';
      case 'shopeepay':
        return 'ShopeePay';
      case 'credit_card':
        return 'Kartu Kredit';
      case 'cstore':
        return 'Convenience Store';
      case 'midtrans':
      case '':
      case null:
        return 'Belum dibayar';
      default:
        return method!.capitalizeFirst ?? method;
    }
  }

  Widget _buildOrderTracking(String status) {
    // Define tracking stages
    List<Map<String, dynamic>> stages = [
      {
        'icon': Icons.receipt_outlined,
        'label': 'Pesanan\nDiterima',
        'status': ['pending', 'paid', 'processing', 'completed', 'delivered']
      },
      {
        'icon': Icons.coffee_maker_outlined,
        'label': 'Sedang\nDibuat',
        'status': ['processing', 'completed', 'delivered']
      },
      {
        'icon': Icons.delivery_dining,
        'label': 'Sedang\nDikirim',
        'status': ['delivered']
      },
      {
        'icon': Icons.home_outlined,
        'label': 'Pesanan\nSampai',
        'status': ['completed', 'delivered']
      },
    ];

    String currentStatus = status.toLowerCase();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Progress line
          Row(
            children: List.generate(stages.length * 2 - 1, (index) {
              if (index.isEven) {
                // Circle for stage
                int stageIndex = index ~/ 2;
                Map<String, dynamic> stage = stages[stageIndex];
                bool isActive = stage['status'].contains(currentStatus);
                bool isCompleted = false;

                // Check if this stage is completed based on current status
                if (currentStatus == 'completed' ||
                    currentStatus == 'delivered') {
                  isCompleted = stageIndex < stages.length;
                } else if (currentStatus == 'processing' && stageIndex <= 1) {
                  isCompleted = stageIndex == 0;
                } else if (currentStatus == 'paid' && stageIndex == 0) {
                  isCompleted = true;
                }

                Color iconColor;
                Color backgroundColor;

                if (isCompleted) {
                  iconColor = Colors.white;
                  backgroundColor = Colors.green;
                } else if (isActive) {
                  iconColor = Colors.white;
                  backgroundColor = const Color(0xFF084CAC);
                } else {
                  iconColor = Colors.grey[400]!;
                  backgroundColor = Colors.grey[200]!;
                }

                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    stage['icon'],
                    color: iconColor,
                    size: 24,
                  ),
                );
              } else {
                // Line between stages
                int prevStageIndex = (index - 1) ~/ 2;
                bool isLineCompleted = false;

                if (currentStatus == 'completed' ||
                    currentStatus == 'delivered') {
                  isLineCompleted = prevStageIndex < stages.length - 1;
                } else if (currentStatus == 'processing') {
                  isLineCompleted = prevStageIndex == 0;
                }

                return Expanded(
                  child: Container(
                    height: 3,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: isLineCompleted ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }
            }),
          ),
          const SizedBox(height: 12),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stages.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> stage = entry.value;
              bool isActive = stage['status'].contains(currentStatus);
              bool isCompleted = false;

              if (currentStatus == 'completed' ||
                  currentStatus == 'delivered') {
                isCompleted = index < stages.length;
              } else if (currentStatus == 'processing' && index <= 1) {
                isCompleted = index == 0;
              } else if (currentStatus == 'paid' && index == 0) {
                isCompleted = true;
              }

              return Expanded(
                child: Text(
                  stage['label'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    color: isActive || isCompleted
                        ? Colors.black87
                        : Colors.grey[600],
                    fontWeight: isActive || isCompleted
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        title: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                'History',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                'What you order',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/images/history.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Obx(() {
            // Urutkan historyItems berdasarkan created_at terbaru
            final historyItems = List<Map<String, dynamic>>.from(
                orderController.orderHistory)
              ..sort((a, b) {
                final aDate =
                    DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(2000);
                final bDate =
                    DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(2000);
                return bDate.compareTo(aDate);
              });
            if (historyItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Tidak ada riwayat transaksi',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: historyItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemBuilder: (context, index) {
                final item = historyItems[index];
                final orderItem =
                    (item['items'] != null && item['items'].isNotEmpty)
                        ? item['items'][0]
                        : null;
                // Status style
                String status = (item['status'] ?? '').toString().toLowerCase();
                Color statusColor;
                IconData statusIcon;
                switch (status) {
                  case 'completed':
                    statusColor = Colors.green;
                    statusIcon = Icons.check_circle;
                    break;
                  case 'processing':
                  case 'pending':
                    statusColor = Colors.orange;
                    statusIcon = Icons.pending;
                    break;
                  case 'cancelled':
                    statusColor = Colors.red;
                    statusIcon = Icons.cancel;
                    break;
                  case 'paid':
                    statusColor = Colors.blue;
                    statusIcon = Icons.info;
                    break;
                  case 'delivered':
                    statusColor = Colors.blueAccent;
                    statusIcon = Icons.local_shipping;
                    break;
                  default:
                    statusColor = Colors.grey;
                    statusIcon = Icons.info;
                }
                // Gambar produk
                String imageUrl =
                    orderItem != null ? (orderItem['product_image'] ?? '') : '';
                if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
                  // Clean the URL by removing control characters and whitespace
                  imageUrl = imageUrl
                      .replaceAll(RegExp(r'[\x00-\x1F\x7F-\x9F]'), '')
                      .trim();
                  if (imageUrl.isNotEmpty) {
                    imageUrl = 'https://campaign.rplrus.com/' +
                        imageUrl.replaceFirst(RegExp(r'^/'), '');
                  }
                }
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Order Details',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Status
                              Row(
                                children: [
                                  Icon(statusIcon,
                                      color: statusColor, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    (item['status'] ?? '')
                                            .toString()
                                            .capitalizeFirst ??
                                        '',
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Info order
                              Text('Order ID: #ORD${item['id']}',
                                  style: const TextStyle(
                                      fontSize: 14, fontFamily: 'Poppins')),
                              const SizedBox(height: 8),
                              // Tanggal Order
                              Builder(
                                builder: (context) {
                                  final dateStr = item['created_at'] ?? '';
                                  final dateTime = dateStr.isNotEmpty
                                      ? DateTime.tryParse(dateStr)
                                      : null;
                                  final formattedDate = dateTime != null
                                      ? '${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}'
                                      : '-';
                                  return Text('Date: $formattedDate',
                                      style: const TextStyle(
                                          fontSize: 14, fontFamily: 'Poppins'));
                                },
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Tipe Pesanan: ',
                                      style: TextStyle(
                                          fontSize: 14, fontFamily: 'Poppins')),
                                  if ((item['order_type'] ?? '')
                                          .toString()
                                          .isNotEmpty &&
                                      item['order_type'] != '-')
                                    Container(
                                      margin: const EdgeInsets.only(left: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(item['order_type'],
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                              fontFamily: 'Poppins')),
                                    )
                                  else
                                    const Text('-',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            color: Colors.grey)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Payment Method: ',
                                      style: TextStyle(
                                          fontSize: 14, fontFamily: 'Poppins')),
                                  Container(
                                    margin: const EdgeInsets.only(left: 4),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                        getPaymentMethodLabel(
                                            item['payment_method']),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                            fontFamily: 'Poppins')),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Order Tracking Section
                              const Text('Order Tracking',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Poppins')),
                              const SizedBox(height: 12),
                              _buildOrderTracking(item['status'] ?? ''),
                              const SizedBox(height: 16),
                              const Text('Order Items',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      fontFamily: 'Poppins')),
                              const SizedBox(height: 10),
                              // List item
                              ...((item['items'] ?? []) as List)
                                  .map((orderItem) => Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: (orderItem[
                                                              'product_image'] !=
                                                          null &&
                                                      orderItem['product_image']
                                                          .toString()
                                                          .isNotEmpty)
                                                  ? Builder(
                                                      builder: (context) {
                                                        String imgUrl = orderItem[
                                                                'product_image']
                                                            .toString();
                                                        if (!imgUrl.startsWith(
                                                            'http')) {
                                                          // Clean the URL by removing control characters and whitespace
                                                          imgUrl = imgUrl
                                                              .replaceAll(
                                                                  RegExp(
                                                                      r'[\x00-\x1F\x7F-\x9F]'),
                                                                  '')
                                                              .trim();
                                                          if (imgUrl
                                                              .isNotEmpty) {
                                                            imgUrl = 'https://campaign.rplrus.com/' +
                                                                imgUrl.replaceFirst(
                                                                    RegExp(
                                                                        r'^/'),
                                                                    '');
                                                          }
                                                        }
                                                        return imgUrl.isNotEmpty
                                                            ? Image.network(
                                                                imgUrl,
                                                                width: 50,
                                                                height: 50,
                                                                fit: BoxFit
                                                                    .cover,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Image
                                                                      .asset(
                                                                    _getProductImage(
                                                                        orderItem['product_name'] ??
                                                                            ''),
                                                                    width: 50,
                                                                    height: 50,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  );
                                                                },
                                                              )
                                                            : Image.asset(
                                                                _getProductImage(
                                                                    orderItem[
                                                                            'product_name'] ??
                                                                        ''),
                                                                width: 50,
                                                                height: 50,
                                                                fit: BoxFit
                                                                    .cover,
                                                              );
                                                      },
                                                    )
                                                  : Image.asset(
                                                      _getProductImage(orderItem[
                                                              'product_name'] ??
                                                          ''),
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      orderItem[
                                                              'product_name'] ??
                                                          '-',
                                                      style:
                                                          const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'Poppins')),
                                                  // Info detail: Temperature dan Sugar saja (tanpa Size)
                                                  Builder(
                                                    builder: (context) {
                                                      final temp = orderItem[
                                                                  'temperature']
                                                              ?.toString() ??
                                                          '-';
                                                      final sugar = orderItem[
                                                                  'sugar']
                                                              ?.toString() ??
                                                          '-';
                                                      return Text(
                                                          'Temperature: $temp • Sugar: $sugar',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[700],
                                                              fontFamily:
                                                                  'Poppins'));
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                    'Rp. ${orderItem['price']}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'Poppins')),
                                                Text(
                                                    'x${orderItem['quantity']}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontFamily: 'Poppins')),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Amount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: 'Poppins')),
                                  Text('Rp. ${item['total_price']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Color(0xFF084CAC),
                                          fontFamily: 'Poppins')),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF084CAC),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          color: Colors.white)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                          spreadRadius: 1,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 16),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon, size: 14, color: statusColor),
                              const SizedBox(width: 6),
                              Text(
                                (item['status'] ?? '')
                                        .toString()
                                        .capitalizeFirst ??
                                    '',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: statusColor,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '#ORD${item['id']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Gambar produk
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: imageUrl.isNotEmpty
                                        ? Image.network(imageUrl,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover, errorBuilder:
                                                (context, error, stackTrace) {
                                            print(
                                                'Error loading image: $imageUrl, Error: $error');
                                            return Image.asset(
                                              _getProductImage(orderItem != null
                                                  ? orderItem['product_name'] ??
                                                      ''
                                                  : ''),
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            );
                                          })
                                        : Image.asset(
                                            _getProductImage(orderItem != null
                                                ? orderItem['product_name'] ??
                                                    ''
                                                : ''),
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover),
                                  ),
                                  if (orderItem != null &&
                                      orderItem['quantity'] > 1)
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 8, 76, 172),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'x${orderItem['quantity']}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              // Info kiri (nama, tanggal, jam, size)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderItem != null
                                          ? orderItem['product_name'] ?? '-'
                                          : '-',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    // Tanggal dan jam dipisah
                                    Builder(
                                      builder: (context) {
                                        String dateStr = '-';
                                        String timeStr = '-';
                                        if (item['created_at'] != null &&
                                            item['created_at']
                                                .toString()
                                                .isNotEmpty) {
                                          try {
                                            final dt = DateTime.parse(
                                                item['created_at']);
                                            dateStr =
                                                '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}';
                                            timeStr =
                                                '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
                                          } catch (_) {}
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.calendar_today,
                                                    size: 13,
                                                    color: Colors.grey[600]),
                                                const SizedBox(width: 4),
                                                Text(dateStr,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[700],
                                                        fontFamily: 'Poppins')),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time,
                                                    size: 13,
                                                    color: Colors.grey[600]),
                                                const SizedBox(width: 4),
                                                Text(timeStr,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[500],
                                                        fontFamily: 'Poppins')),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    // Size
                                    if (orderItem != null &&
                                        (orderItem['size'] != null &&
                                            orderItem['size']
                                                .toString()
                                                .isNotEmpty))
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          'Size: ${orderItem['size']}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // Info kanan (harga & payment method)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Rp. ${orderItem != null ? orderItem['price'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]}.") : '-'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF084CAC),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  if (item['payment_method'] != null &&
                                      item['payment_method']
                                          .toString()
                                          .isNotEmpty)
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item['payment_method'],
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black87,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tap for details',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  size: 14, color: Colors.grey[600]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

// Tambahkan fungsi helper bulan Indonesia
String _monthName(int month) {
  const months = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];
  return months[month];
}
