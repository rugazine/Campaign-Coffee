import 'package:campaign_coffee/app/pages/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campaign_coffee/app/pages/menu/pages/menu_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:campaign_coffee/app/pages/detail/pages/detail_page.dart';

const mainBlue = Color.fromARGB(255, 8, 76, 172);
const fontPoppins = 'Poppins';

class HomePage extends GetView<HomeController> {
  HomePage({super.key}) {
    Get.put(HomeController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: mainBlue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(
                                    Icons.waving_hand_outlined,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Welcome',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                    controller.userName.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // PROMO
                    SizedBox(
                      height: 160,
                      child: Obx(() => controller.promoCards.isEmpty
                          ? const Center(
                              child: Text('No promo available',
                                  style: TextStyle(color: Colors.white)))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              itemCount: controller.promoCards.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) {
                                final promo = controller.promoCards[index];
                                return Container(
                                  width: 304,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    image: promo['image'] != null &&
                                            promo['image']
                                                .toString()
                                                .startsWith('http')
                                        ? DecorationImage(
                                            image: NetworkImage(promo['image']),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(promo['tag'] ?? '',
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold)),
                                        const SizedBox(height: 4),
                                        Text(promo['title'] ?? '',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextButton(
                          onPressed: () => Get.to(() => MenuPage()),
                          child: const Text(
                            'See All',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: controller.categories
                              .map((category) => _buildCategoryItem(
                                    label: category,
                                  ))
                              .toList(),
                        )),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Our Recommendation',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'See All',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Obx(() => controller.recommendedProducts.isEmpty
                        ? const Center(child: Text('No recommendation'))
                        : GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                            childAspectRatio: 0.65,
                            children: controller.recommendedProducts
                                .map((product) => _buildProductCard(
                                      image: product.image ?? '',
                                      name: product.name,
                                      category: product.category,
                                      price:
                                          'Rp ${product.price.toStringAsFixed(0)}',
                                      id: product.id,
                                      stock: product.stock,
                                      description: product.description,
                                    ))
                                .toList(),
                          )),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      width: 304,
      height: 130,
      decoration: BoxDecoration(
        color: Colors.brown[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.asset(
                'assets/images/banner.png',
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: mainBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Promo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: fontPoppins,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Buy one get\none FREE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontPoppins,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required String label,
  }) {
    String imagePath = 'assets/images/';
    switch (label.toLowerCase()) {
      case 'coffee':
        imagePath += 'coffee.svg';
        break;
      case 'non coffee':
        imagePath += 'noncoffee.svg';
        break;
      case 'snack':
        imagePath += 'snack.svg';
        break;
      case 'main course':
        imagePath += 'mainc.svg';
        break;
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => MenuPage(initialCategory: label));
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(
              imagePath,
              width: 24,
              height: 24,
              color: mainBlue, // Changed from colorFilter to color
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String image,
    required String name,
    required String category,
    required String price,
    int? id,
    required int stock,
    String? description,
  }) {
    final bool isOutOfStock = stock <= 0;
    
    return GestureDetector(
      onTap: isOutOfStock ? null : () {
        Get.to(() => DetailPage(productData: {
              'id': id,
              'name': name,
              'price': int.parse(price.replaceAll(RegExp(r'[^0-9]'), '')),
              'image': image,
              'stock': stock,
              'description': description,
            }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  Image.network(
                    image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: const Center(
                          child: Icon(Icons.broken_image,
                              size: 40, color: Colors.grey)),
                    ),
                  ),
                  if (isOutOfStock)
                    Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.white.withOpacity(0.8),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.block,
                              color: Colors.red,
                              size: 30,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'HABIS',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: fontPoppins,
                      color: isOutOfStock ? Colors.grey[500] : Colors.black,
                    ),
                  ),
                  Text(
                    isOutOfStock ? 'Stok habis' : category,
                    style: TextStyle(
                      color: isOutOfStock ? Colors.red[400] : Colors.grey[600],
                      fontSize: 12,
                      fontFamily: fontPoppins,
                      fontWeight: isOutOfStock ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isOutOfStock ? Colors.grey[500] : const Color.fromARGB(255, 8, 76, 172),
                          fontFamily: fontPoppins,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isOutOfStock ? Colors.grey[400] : const Color.fromARGB(255, 8, 76, 172),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isOutOfStock ? Icons.block : Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
