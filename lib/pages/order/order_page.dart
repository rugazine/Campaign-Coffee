import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // Define main blue color constant for consistency
  static const mainBlue = Color.fromRGBO(8, 76, 172, 1);

  // Delivery method options
  final RxBool _isDelivery = true.obs;

  // Product quantities
  final RxInt _taroQuantity = 1.obs;
  final RxInt _matchaQuantity = 1.obs;

  // Calculate total price
  int get _totalPrice =>
      (_taroQuantity.value * 15000) + (_matchaQuantity.value * 16000);

  void _updateQuantity(RxInt quantity, bool isIncrement) {
    if (isIncrement) {
      quantity.value++;
    } else if (quantity.value > 1) {
      quantity.value--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Order',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 35,
              ),
              // Delivery Method Selection
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Obx(() => Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _isDelivery.value = true,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isDelivery.value
                                    ? mainBlue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Deliver',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: _isDelivery.value
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _isDelivery.value = false,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isDelivery.value
                                    ? mainBlue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Pick Up',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    color: !_isDelivery.value
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),

              const SizedBox(height: 24),

              // Delivery or Pickup Address
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isDelivery.value
                            ? 'Delivery Address'
                            : 'Pickup Address',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isDelivery.value
                                  ? 'Jl. Kpg Sutoyo'
                                  : 'Campaign Coffee Shop',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _isDelivery.value
                                  ? 'Kpg. Sutoyo No. 620, Bilzen, Tanjungbalai'
                                  : 'Jl. Raya Serpong No. 8A, Serpong, Tangerang Selatan',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            if (_isDelivery.value) ...[
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.edit_location_outlined,
                                    size: 16),
                                label: const Text('Edit Address'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black54,
                                  side: const BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  textStyle: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  )),

              // Order Items
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  // Taro Latte
                  _buildOrderItem(
                    'Taro Latte',
                    'Rp 15000',
                    'assets/images/taro_latte.jpg',
                    _taroQuantity,
                  ),
                  const SizedBox(height: 16),

                  // Matcha Latte
                  _buildOrderItem(
                    'Matcha Latte',
                    'Rp 16000',
                    'assets/images/matcha_latte.jpg',
                    _matchaQuantity,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Add Note Button
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.notes_outlined, size: 16),
                label: const Text('Add Note'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black54,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Discount Section

              const SizedBox(height: 24),

              // Payment Summary
              const Text(
                'Payment Summary',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Price',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                  Obx(() => Text(
                        'Rp. ${_totalPrice}',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ],
              ),

              const SizedBox(height: 24),

              // Payment Method
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.payment, color: mainBlue, size: 20),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Midtrans',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.keyboard_arrow_down, size: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: mainBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Order',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem(
      String name, String price, String imagePath, RxInt quantity) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Product Image
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: mainBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Quantity Controls
          Row(
            children: [
              // Decrease Button
              GestureDetector(
                onTap: () => _updateQuantity(quantity, false),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.remove, size: 16),
                ),
              ),

              // Quantity Display
              Obx(() => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${quantity.value}',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),

              // Increase Button
              GestureDetector(
                onTap: () => _updateQuantity(quantity, true),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(Icons.add, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
