import 'dart:async';
import 'package:amar_shoday/features/search_results/search_results_page.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LandingPage2 extends StatefulWidget {
  const LandingPage2({super.key});

  @override
  State<LandingPage2> createState() => _LandingPage2State();
}

class _LandingPage2State extends State<LandingPage2>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  // Floating cart
  Offset cartPosition = const Offset(300, 425);
  late final AnimationController _cartAnimationController;
  late Animation<Offset> _cartAnimation;

  final categories = const [
    "Groceries",
    "Meat",
    "Vegetable",
    "Dairy",
    "Cosmetics",
    "Medicine"
  ];
  final recommended = const [
    "Soyabin Oil",
    "Rice",
    "Local Onion",
    "Milk Powder"
  ];
  final grocery = const [
    "Chola Boot",
    "Rice",
    "Haleem Mix",
    "Maggie",
  ];
  final topSales = const [
    "Aarong Milk",
    "Maggie Noodles",
    "Radhuni Chilli",
    "Local Onion",
  ];

  final Map<String, String> categoryImages = const {
    "Groceries": "assets/groceries.png",
    "Meat": "assets/meat.png",
    "Vegetable": "assets/veg.png",
    "Dairy": "assets/dairy.png",
    "Cosmetics": "assets/cosmetics.png",
    "Medicine": "assets/medicine.png",
  };

  final Map<String, String> recommendedImages = const {
    "Soyabin Oil": "assets/soyabin_oil.png",
    "Rice": "assets/rice.png",
    "Local Onion": "assets/local_onion.png",
  };

  final Map<String, String> groceryImages = const {
    "Chola Boot": "assets/chola_boot.png",
    "Rice": "assets/rice.png",
    "Haleem Mix": "assets/radhuni_halim_mix.png",
    "Maggie": "assets/maggie.png",
  };

  final Map<String, String> topSaleImages = const {
    "Aarong Milk": "assets/aarong_milk.png",
    "Maggie Noodles": "assets/maggie.png",
    "Radhuni Chilli": "assets/radhuni_chilli.png",
    "Local Onion": "assets/local_onion.png",
  };

  final PageController _promoController = PageController();
  final PageController _adController = PageController();
  Timer? _promoTimer;
  Timer? _adTimer;
  int _adPage = 0;

  final int _adCount = 3;

  @override
  void initState() {
    super.initState();

    _startAutoScroll(_promoController, 4, (timer) => _promoTimer = timer);
    _startAdAutoScroll();
    _adController.addListener(() {
      if (_adController.hasClients && _adController.page != null) {
        int newPage = _adController.page!.round();
        if (newPage != _adPage) setState(() => _adPage = newPage);
      }
    });

    _cartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _cartAnimationController.addListener(() {
      setState(() {
        cartPosition = _cartAnimation.value;
      });
    });
  }

  void _startAutoScroll(PageController controller, int pageCount,
      void Function(Timer) assignTimer) {
    int page = 0;
    assignTimer(Timer.periodic(const Duration(seconds: 3), (_) {
      if (controller.hasClients) {
        page++;
        if (page >= pageCount) page = 0;
        controller.animateToPage(
          page,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }));
  }

  void _startAdAutoScroll() {
    _adTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_adController.hasClients) {
        _adPage++;
        if (_adPage >= _adCount) _adPage = 0;
        _adController.animateToPage(
          _adPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _adTimer?.cancel();
    _promoController.dispose();
    _adController.dispose();
    _cartAnimationController.dispose();
    super.dispose();
  }

  void _navigateToSearchResults() {
    String query = _searchController.text.trim();
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultsPage(searchQuery: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Container(
                    color: Colors.indigo.shade900,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset("assets/location_icon.png",
                                width: 20, height: 20),
                            const SizedBox(width: 4),
                            const Text("Bosila, Dhaka",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14)),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            if (context.locale.languageCode == 'en') {
                              context.setLocale(const Locale('bn', 'BD'));
                            } else {
                              context.setLocale(const Locale('en', 'US'));
                            }
                          },
                          icon: const Icon(Icons.language, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade900,
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(24)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${'hello'.tr()}\n${'welcome_to_amar_shoday'.tr()}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: IconButton(
                                icon: Image.asset('assets/bell_icon.png',
                                    width: 40, height: 40),
                                onPressed: () {},
                                iconSize: 15,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: _buildBody(),
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24)),
            child: BottomNavigationBar(
              backgroundColor: Colors.indigo.shade900,
              currentIndex: _navIndex,
              onTap: (i) => setState(() => _navIndex = i),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home), label: "home".tr()),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.category), label: "categories".tr()),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.favorite_border),
                    label: "favourite".tr()),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.more_horiz), label: "more".tr()),
              ],
            ),
          ),
        ),

        // 🛒 Floating draggable cart
        Positioned(
          left: cartPosition.dx,
          top: cartPosition.dy,
          child: Draggable(
            feedback: _floatingCart(),
            childWhenDragging: const SizedBox.shrink(),
            onDragEnd: (details) {
              double dx = details.offset.dx.clamp(0.0, screenSize.width - 60);
              double dy = details.offset.dy.clamp(
                  0.0, screenSize.height - 60 - kBottomNavigationBarHeight);

              _cartAnimation = Tween<Offset>(
                begin: cartPosition,
                end: Offset(dx, dy),
              ).animate(CurvedAnimation(
                parent: _cartAnimationController,
                curve: Curves.elasticOut,
              ));

              _cartAnimationController.forward(from: 0);
            },
            child: _floatingCart(),
          ),
        ),
      ],
    );
  }

  Widget _floatingCart() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cart tapped!")),
        );
      },
      child: Image.asset(
        "assets/empty.png",
        width: 60,
        height: 60,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildPromotion(),
          const SizedBox(height: 16),
          _buildCategoriesSection(),
          const SizedBox(height: 16),
          _sectionWithHorizontalItems("recommended_products".tr(), recommended,
              itemImages: recommendedImages, bordered: true),
          _sectionWithHorizontalItems("grocery_items".tr(), grocery,
              itemImages: groceryImages, bordered: true),
          const SizedBox(height: 12),
          _buildAds(),
          _buildSectionTitle("top_sales".tr()),
          _buildTopSales(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.indigo.shade900,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search_by_product_brand'.tr(),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _navigateToSearchResults(),
                  ),
                ),
                GestureDetector(
                  onTap: _navigateToSearchResults,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'search'.tr(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title, {
    Color textColor = Colors.black,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.bold,
    String? fontFamily,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontFamily: fontFamily,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "view_all".tr(),
              style: TextStyle(
                color: textColor,
                decoration: TextDecoration.underline,
                fontFamily: fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotion() {
    return Stack(
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.indigo.shade900,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle(
              "promotion".tr(),
              textColor: Colors.white,
              fontSize: 20,
            ),
            SizedBox(
              height: 160,
              child: PageView(
                controller: _promoController,
                children: [
                  const Image(image: AssetImage("assets/Promotion1.png")),
                  _promoCard("GET YOUR\n GROCERIES\n DELIVERED\n IN MINUTES"),
                  _promoCard("Discount up to 50% on\n Fresh Vegetables"),
                  _promoCard("Shop Now & Get\n Free Delivery"),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("categories".tr(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
        ),
        _buildCategories(),
      ],
    );
  }

  Widget _buildAds() {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: PageView(
            controller: _adController,
            children: [
              const Image(image: AssetImage("assets/super_sale.png")),
              _adBanner("Ad Banner 2"),
              _adBanner("Ad Banner 3"),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_adCount, (index) {
            bool isActive = index == _adPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 16 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: isActive ? Colors.blue : Colors.grey,
                borderRadius: BorderRadius.circular(5),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTopSales() {
    return Container(
      color: Colors.white,
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: topSales.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final name = topSales[index];
          final imgPath = topSaleImages[name];
          return SizedBox(
            width: 100,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.orange.shade300,
                  child: ClipOval(
                    child: imgPath != null
                        ? Image.asset(
                            imgPath,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              name[0],
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 6),
                Flexible(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final name = categories[index];
        final imgPath = categoryImages[name];
        return Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue.shade100,
              child: ClipOval(
                child: imgPath != null
                    ? Image.asset(
                        imgPath,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: Text(
                          name[0],
                          style: const TextStyle(
                              fontSize: 18, color: Colors.white),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(name),
          ],
        );
      },
    );
  }

  Widget _promoCard(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        borderRadius: BorderRadius.circular(13),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Center(
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }

  Widget _adBanner(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Center(
        child: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _sectionWithHorizontalItems(String title, List items,
      {Map<String, String>? itemImages, bool bordered = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        Container(
          color: Colors.white,
          height: 140, // increased height to accommodate bigger images
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              final imgPath = itemImages?[item];
              return Container(
                width: 100,
                decoration: bordered
                    ? BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                      )
                    : null,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (imgPath != null)
                      Image.asset(
                        imgPath,
                        width: 60, // increased from 36
                        height: 60, // increased from 36
                        fit: BoxFit.contain,
                      )
                    else
                      Text(item.toString().substring(0, 1),
                          style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      item.toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
