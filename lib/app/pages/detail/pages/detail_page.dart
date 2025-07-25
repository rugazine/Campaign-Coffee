import 'package:campaign_coffee/app/pages/detail/controller/detail_controller.dart';
import 'package:campaign_coffee/app/pages/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic>? productData;
  const DetailPage({Key? key, this.productData}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final DetailController controller = Get.put(DetailController());

  @override
  void initState() {
    super.initState();
    Map<String, dynamic>? data = widget.productData;
    // Jika productData null, ambil dari Get.arguments
    if (data == null && Get.arguments != null) {
      if (Get.arguments is Map && Get.arguments['productData'] != null) {
        data = Map<String, dynamic>.from(Get.arguments['productData']);
      } else if (Get.arguments is Map<String, dynamic>) {
        data = Map<String, dynamic>.from(Get.arguments);
      }
    }
    if (data != null) {
      print('DATA DARI CART KE DETAIL: $data');
      controller.setProductData(
        data['name'] ?? 'Choco Choco',
        int.tryParse(data['price'].toString()) ?? 15000,
        (data['image'] == null || data['image'].toString().isEmpty)
            ? 'assets/images/choco_choco.jpg'
            : data['image'],
        int.tryParse(data['id'].toString()) ?? 0,
        stock: int.tryParse(data['stock'].toString()) ?? 0,
        description: data['description'] ?? 'Deskripsi produk tidak tersedia',
      );
      // Set sugar & temperature setelah setProductData
      if (data['sugar'] != null) controller.setSugar(data['sugar']);
      if (data['temperature'] != null)
        controller.setTemperature(data['temperature']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Detail',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        centerTitle: true,
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: controller.isFavorite ? Colors.red : Colors.black,
                ),
                onPressed: controller.toggleFavorite,
              )),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 250,
                      width: 330,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[100],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Obx(() => Stack(
                              children: [
                                Image.network(
                                  controller.productImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.error_outline,
                                              color: Colors.red, size: 48),
                                          SizedBox(height: 8),
                                          Text('Gagal memuat gambar',
                                              style:
                                                  TextStyle(color: Colors.grey))
                                        ],
                                      ),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                                if (controller.isOutOfStock)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey.withOpacity(0.7),
                                      ),
                                      child: const Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.block,
                                              color: Colors.red,
                                              size: 60,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'HABIS',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Obx(() => Text(
                          controller.productName,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: controller.isOutOfStock
                                  ? Colors.grey
                                  : Colors.black),
                        )),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ice/Hot',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Obx(() => Row(
                              children: [
                                Text(
                                  'Stok: ${controller.stock}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: controller.isOutOfStock
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                if (controller.isOutOfStock) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'Habis',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        const Text('4.8',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(' (230)',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Description',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Obx(() => Text(
                              controller.description,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: controller.isOutOfStock
                                      ? Colors.grey[300]
                                      : Colors.grey[400]),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Obx(() => _buildOptionSection(
                      'Sugar',
                      ['Less', 'Normal', 'Extra'],
                      controller.selectedSugar,
                      controller.setSugar,
                      isDisabled: controller.isOutOfStock)),
                  const SizedBox(height: 30),
                  Obx(() => _buildOptionSection('Temperature', ['Ice', 'Hot'],
                      controller.selectedTemperature, controller.setTemperature,
                      isDisabled: controller.isOutOfStock)),
                  const SizedBox(height: 30),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Obx(() => Text(
                                'Rp.${controller.price}',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: controller.isOutOfStock
                                        ? Colors.grey
                                        : const Color.fromARGB(
                                            255, 8, 76, 172)),
                              )),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            // Quantity selector
                            Obx(() => Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Minus button
                                    IconButton(
                                      onPressed: controller.isOutOfStock || controller.isMinQuantity
                                          ? null
                                          : controller.decrementQuantity,
                                      icon: Icon(
                                        Icons.remove_circle_outline,
                                        color: controller.isOutOfStock || controller.isMinQuantity
                                            ? Colors.grey[400]
                                            : const Color.fromARGB(255, 8, 76, 172),
                                        size: 28,
                                      ),
                                    ),
                                    // Quantity display
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: controller.isOutOfStock
                                              ? Colors.grey[300]!
                                              : const Color.fromARGB(255, 8, 76, 172),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        '${controller.quantity}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: controller.isOutOfStock
                                              ? Colors.grey[400]
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    // Plus button
                                    IconButton(
                                      onPressed: controller.isOutOfStock || controller.isMaxQuantity
                                          ? null
                                          : controller.incrementQuantity,
                                      icon: Icon(
                                        Icons.add_circle_outline,
                                        color: controller.isOutOfStock || controller.isMaxQuantity
                                            ? Colors.grey[400]
                                            : const Color.fromARGB(255, 8, 76, 172),
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 10),
                            // Add to cart button
                            Obx(() => ElevatedButton(
                                  onPressed: controller.isOutOfStock
                                      ? null
                                      : controller.addToCart,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: controller.isOutOfStock
                                        ? Colors.grey[300]
                                        : const Color.fromARGB(255, 8, 76, 172),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    controller.isOutOfStock
                                        ? 'Stok Habis'
                                        : 'Add To Cart',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: controller.isOutOfStock
                                          ? Colors.grey[600]
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionSection(String title, List<String> options,
      String selected, Function(String) onSelect,
      {bool isDisabled = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDisabled ? Colors.grey : Colors.black)),
          const SizedBox(height: 20),
          Row(
            children: options.map((label) {
              bool isSelected = selected == label;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: isDisabled ? null : () => onSelect(label),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDisabled
                          ? Colors.grey[200]
                          : isSelected
                              ? const Color.fromARGB(255, 8, 76, 172)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDisabled
                            ? Colors.grey[300]!
                            : isSelected
                                ? const Color.fromARGB(255, 8, 76, 172)
                                : Colors.grey[300]!,
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isDisabled
                            ? Colors.grey[400]
                            : isSelected
                                ? Colors.white
                                : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
