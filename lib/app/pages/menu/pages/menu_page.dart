import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:campaign_coffee/app/pages/detail/pages/detail_page.dart';
import 'package:campaign_coffee/app/pages/menu/controllers/menu_controller.dart' as custom;

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

  final custom.MenuController menuController =
      Get.put(custom.MenuController());

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
                child: Container(
                  width: 320,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
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

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Material(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      elevation: 3,
                                      child: InkWell(
                                        onTap: () => Get.to(
                                            () => DetailPage(productData: {
                                                  'name': product.name,
                                                  'price': product.price,
                                                  'image': product.image,
                                                })),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 55,
                                                height: 55,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      product.image ??
                                                          'https://via.placeholder.com/150',
                                                    ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product.name,
                                                      style: const TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      product.description,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 10,
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
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
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
