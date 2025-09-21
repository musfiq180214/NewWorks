import 'package:amar_shoday/features/language/language_toggle_button.dart';
import 'package:amar_shoday/features/theme/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LandingPage2 extends StatefulWidget {
  const LandingPage2({super.key});

  @override
  State<LandingPage2> createState() => _LandingPage2State();
}

class _LandingPage2State extends State<LandingPage2> {
  int _navIndex = 0;

  final categories = List.generate(6, (i) => "Category ${i + 1}");
  final recommended = List.generate(8, (i) => "Product ${i + 1}");
  final grocery = ["Rice", "Oil", "Milk", "Bread", "Eggs"];
  final topSales = List.generate(6, (i) => "Top ${i + 1}");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("hello_welcome".tr()),
        actions: const [
          ThemeToggleButton(),
          // LanguageToggleButton(),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "search_hint".tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            // Promotion Tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text("promotion_tab".tr())),
              ),
            ),

            const SizedBox(height: 12),

            // Categories grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: categories.map((c) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 36,
                            child: Text(c.split(' ').last),
                          ),
                          const SizedBox(height: 8),
                          Text(c),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // Recommended
            _sectionWithHorizontalItems(
                "recommended_products".tr(), recommended),

            const SizedBox(height: 12),

            // Grocery Items
            _sectionWithHorizontalItems("grocery_items".tr(), grocery),

            const SizedBox(height: 12),

            // Advertisement banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.orange.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text("advertisement_banner".tr())),
              ),
            ),

            const SizedBox(height: 12),

            // Top Sales
            _sectionWithHorizontalItems("top_sales".tr(), topSales),
            const SizedBox(height: 30),
          ],
        ),
      ),

      // Bottom navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home), label: "home".tr()),
          BottomNavigationBarItem(
              icon: const Icon(Icons.category), label: "categories".tr()),
          BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_border), label: "favourite".tr()),
          BottomNavigationBarItem(
              icon: const Icon(Icons.more_horiz), label: "more".tr()),
        ],
      ),
    );
  }

  Widget _sectionWithHorizontalItems(String title, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(
                onPressed: () {},
                child: Text("view_all".tr()),
              )
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return SizedBox(
                width: 100,
                child: Column(
                  children: [
                    CircleAvatar(
                        radius: 36,
                        child: Text(item.toString().substring(0, 1))),
                    const SizedBox(height: 6),
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
