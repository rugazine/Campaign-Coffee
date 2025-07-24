import 'package:campaign_coffee/app/pages/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:campaign_coffee/app/pages/detail/pages/detail_page.dart';
import 'package:campaign_coffee/app/pages/menu/controllers/menu_controller.dart'
    as custom;

class MenuPage extends StatefulWidget {
  final String? initialCategory;

  const MenuPage({
    super.key,
    this.initialCategory,
  });

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  static const mainBlue = Color.fromARGB(255, 8, 76, 172);

  final custom.MenuController menuController = Get.put(custom.MenuController());

  final List<Map<String, dynamic>> categories = [
    {'icon': 'assets/images/coffee.svg', 'label': 'Coffee'},
    {'icon': 'assets/images/noncoffee.svg', 'label': 'Non Coffee'},
    {'icon': 'assets/images/snack.svg', 'label': 'Snack'},
    {'icon': 'assets/images/mainc.svg', 'label': 'Main Course'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      menuController.setSelectedCategory(widget.initialCategory!);
    }
  }

  void _onCategoryTap(String category) {
    menuController.setSelectedCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: GetX<CartController>(builder: (controller) {
          return controller.cartItems.isNotEmpty
              ? FloatingActionButton(
                  backgroundColor: mainBlue,
                  onPressed: () {
                    Get.offAllNamed('/bottomnav');
                    Get.find<RxInt>().value = 1;
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${controller.cartItems.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink();
        }),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/menus.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Color.fromARGB(255, 5, 5, 5)),
                      onPressed: () {
                        Get.offAllNamed('/bottomnav');
                        Get.find<RxInt>().value = 0; // Set home tab as active
                      },
                    ),
                    Container(
                      width: 270,
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon:
                              Icon(Icons.search, color: Colors.grey[600]),
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 9),
                        ),
                        onChanged: (value) =>
                            menuController.setSearchQuery(value),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 100,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      categories.length,
                      (index) {
                        final category = categories[index];
                        final isSelected = category['label'] ==
                            menuController.selectedCategory.value;

                        return Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 40 : 0,
                            right: 24,
                          ),
                          child: GestureDetector(
                            onTap: () => _onCategoryTap(category['label']),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: isSelected
                                        ? mainBlue
                                        : Colors.grey[100],
                                  ),
                                  child: SvgPicture.asset(
                                    category['icon'],
                                    colorFilter: ColorFilter.mode(
                                      isSelected ? Colors.white : mainBlue,
                                      BlendMode.srcIn,
                                    ),
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category['label'],
                                  style: TextStyle(
                                    color: isSelected ? mainBlue : Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: menuController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : menuController.error.isNotEmpty
                        ? Center(child: Text(menuController.error.value))
                        : menuController.filteredProducts.isEmpty
                            ? const Center(
                                child: Text('Tidak ada produk tersedia'))
                            : ListView.builder(
                                padding: const EdgeInsets.all(16.0),
                                itemCount:
                                    menuController.filteredProducts.length,
                                itemBuilder: (context, index) {
                                  final product =
                                      menuController.filteredProducts[index];
                                  final bool isOutOfStock = product.stock <= 0;

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      elevation: 3,
                                      child: InkWell(
                                        onTap: isOutOfStock
                                            ? null
                                            : () => Get.to(
                                                () => DetailPage(productData: {
                                                      'id': product.id,
                                                      'name': product.name,
                                                      'price': product.price,
                                                      'image': product.image,
                                                      'stock': product.stock,
                                                      'description': product.description,
                                                    })),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    width: 55,
                                                    height: 55,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          product.image ??
                                                              'https://via.placeholder.com/150',
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  if (isOutOfStock)
                                                    Container(
                                                      width: 55,
                                                      height: 55,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: Colors.grey
                                                            .withOpacity(0.7),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.block,
                                                          color: Colors.red,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product.name,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: isOutOfStock
                                                            ? Colors.grey[500]
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      isOutOfStock
                                                          ? 'Stok habis'
                                                          : product.description,
                                                      style: TextStyle(
                                                        color: isOutOfStock
                                                            ? Colors.red[400]
                                                            : Colors.grey[600],
                                                        fontSize: 10,
                                                        fontWeight: isOutOfStock
                                                            ? FontWeight.w500
                                                            : FontWeight.normal,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Rp${product.price}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                      color: isOutOfStock
                                                          ? Colors.grey[500]
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
