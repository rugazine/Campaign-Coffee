// import 'package:campaign_coffee/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  late String selectedCategory;

  // Define mainBlue color constant
  static const mainBlue = Color.fromARGB(255, 8, 76, 172);

  final List<Map<String, dynamic>> categories = [
    {'icon': 'assets/images/coffee.svg', 'label': 'Coffee'},
    {'icon': 'assets/images/noncoffee.svg', 'label': 'Non Coffee'},
    {'icon': 'assets/images/snack.svg', 'label': 'Snack'},
    {'icon': 'assets/images/mainc.svg', 'label': 'Main Course'},
  ];

  final List<Map<String, dynamic>> menuItems = [
    {
      'name': 'Taro Latte',
      'description': 'a latte recipe that is made with taro root, milk, and',
      'price': 'Rp15000',
      'image': 'assets/images/taro_latte.jpg',
    },
    {
      'name': 'Matcha Latte',
      'description': 'green tea latte recipe with',
      'price': 'Rp15000',
      'image': 'assets/images/matcha_latte.jpg',
    },
    {
      'name': 'Choco Choco',
      'description': 'with chocolate powder, milk',
      'price': 'Rp15000',
      'image': 'assets/images/choco_choco.jpg',
    },
    {
      'name': 'Red Velvet',
      'description': 'a latte recipe that is made with red velvet, milk',
      'price': 'Rp15000',
      'image': 'assets/images/red_velvet.jpg',
    },
    {
      'name': 'Matcha Oat',
      'description': 'green tea latte recipe with',
      'price': 'Rp15000',
      'image': 'assets/images/matcha_latte.jpg',
    },
    {
      'name': 'Taro Oat',
      'description': 'with taro root, milk, and',
      'price': 'Rp15000',
      'image': 'assets/images/taro_latte.jpg',
    },
    {
      'name': 'Taro Latte',
      'description': 'a latte recipe that is made with taro root, milk, and',
      'price': 'Rp15000',
      'image': 'assets/images/taro_latte.jpg',
    },
    {
      'name': 'Matcha Latte',
      'description': 'green tea latte recipe with',
      'price': 'Rp15000',
      'image': 'assets/images/matcha_latte.jpg',
    },
    {
      'name': 'Choco Choco',
      'description': 'with chocolate powder, milk',
      'price': 'Rp15000',
      'image': 'assets/images/choco_choco.jpg',
    },
    {
      'name': 'Red Velvet',
      'description': 'a latte recipe that is made with red velvet, milk',
      'price': 'Rp15000',
      'image': 'assets/images/red_velvet.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.initialCategory ?? 'Non Coffee';
  }

  // Update the category selection handler
  void _onCategoryTap(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // Search Bar
            SizedBox(
              height: 50,
            ),
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

            // Categories
            SizedBox(
              height: 100,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    categories.length,
                    (index) {
                      final category = categories[index];
                      final isSelected = category['label'] == selectedCategory;

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
                                  color:
                                      isSelected ? mainBlue : Colors.grey[100],
                                ),
                                child: SvgPicture.asset(
                                  category['icon'],
                                  colorFilter: ColorFilter.mode(
                                      isSelected ? Colors.white : mainBlue,
                                      BlendMode.srcIn),
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

            // Menu Items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      elevation: 3,
                      child: InkWell(
                        onTap: () => 
                        Get.toNamed
                        // (AppRoutes.detail)
                        ,
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Product Image
                              Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(item['image']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Title and Description
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['description'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 10,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Price and Add Button
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    item['price'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
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
  }
}
