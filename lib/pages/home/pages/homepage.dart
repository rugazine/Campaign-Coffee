import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:campaign_coffee/routes/app_routes.dart';
// import 'package:campaign_coffee/pages/home/pages/menu_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

// You can define the color as a constant at the top of the file
const mainBlue = Color.fromARGB(255, 8, 76, 172);
const fontPoppins = 'Poppins';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue Container for Welcome Section and Promo
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
                    // Welcome Section
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
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
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Ruga Zinedine',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Promo Section
                    SizedBox(
                      height: 160,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Row(
                          children: [
                            _buildPromoCard(),
                            const SizedBox(width: 16),
                            _buildPromoCard(),
                            const SizedBox(width: 16),
                            _buildPromoCard(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Section
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
                          onPressed: () => Get.to(() => const //MenuPage
                          ()),
                          child: const Text(
                            'See All',
                            style: TextStyle(
                                color: Colors.black, fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),

                    // Category Icons
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCategoryItem(
                          label: 'Coffee',
                        ),
                        _buildCategoryItem(
                          label: 'Non Coffee',
                        ),
                        _buildCategoryItem(
                          label: 'Snack',
                        ),
                        _buildCategoryItem(
                          label: 'Main Course',
                        ),
                      ],
                    ),

                    // Recommendation Section
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Our Reccommendation',
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

                    // Recommendation Grid
                    const SizedBox(height: 15),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15,
                      childAspectRatio: 0.75,
                      children: [
                        _buildProductCard(
                          image: 'assets/images/choco_choco.jpg',
                          name: 'Choco - Choco',
                          category: 'Chocolate',
                          price: 'Rp. 15000',
                        ),
                        _buildProductCard(
                          image: 'assets/images/matcha_latte.jpg',
                          name: 'Matcha Latte',
                          category: 'Matcha',
                          price: 'Rp. 15000',
                        ),
                        _buildProductCard(
                          image: 'assets/images/taro_latte.jpg',
                          name: 'Taro Latte',
                          category: 'Taro',
                          price: 'Rp. 15000',
                        ),
                        _buildProductCard(
                          image: 'assets/images/red_velvet.jpg',
                          name: 'Red Velvet',
                          category: 'Red Velvet',
                          price: 'Rp. 15000',
                        ),
                        _buildProductCard(
                          image: 'assets/images/choco_choco.jpg',
                          name: 'Choco - Choco',
                          category: 'Chocolate',
                          price: 'Rp. 15000',
                        ),
                        _buildProductCard(
                          image: 'assets/images/matcha_latte.jpg',
                          name: 'Matcha Latte',
                          category: 'Matcha',
                          price: 'Rp. 15000',
                        ),
                      ],
                    ),
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
        imagePath += 'noncoffee.svg';
        break;
      case 'non coffee':
        imagePath += 'coffee.svg';
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
        Get.to(() => //MenuPage
        (initialCategory: label));
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
              colorFilter: const ColorFilter.mode(mainBlue, BlendMode.srcIn),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: fontPoppins,
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
  }) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(AppRoutes.detail);
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
              child: Image.asset(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: fontPoppins,
                    ),
                  ),
                  Text(
                    category,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontFamily: fontPoppins,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 8, 76, 172),
                          fontFamily: fontPoppins,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 8, 76, 172),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
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
