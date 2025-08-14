import 'package:flutter/material.dart';
import '../widgets/category_button.dart';
import '../widgets/course_card.dart';
import 'flutter_course_detail.dart';
import 'package:simple_icons/simple_icons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Courses"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
        ],
      ),

      // Body
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Blue header
              Container(
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // icons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Icon(Icons.grid_view, color: Colors.white, size: 28),
                        Icon(Icons.notifications_none, color: Colors.white, size: 28),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hi, Programmer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Search bar (white) with controlled FocusNode
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              focusNode: _searchFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Search Here',
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Category buttons 2x3
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        CategoryButton(icon: Icons.category, label: 'Category'),
                        CategoryButton(icon: Icons.class_, label: 'Classes'),
                        CategoryButton(icon: Icons.card_giftcard, label: 'Free Course'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        CategoryButton(icon: Icons.storefront, label: 'BookStore'),
                        CategoryButton(icon: Icons.live_tv, label: 'Live Course'),
                        CategoryButton(icon: Icons.emoji_events, label: 'LeaderBoard'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // Courses header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Expanded(
                      child: Text(
                        'Courses',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Courses grid (2 columns)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Flutter card (tappable)
                        CourseCard(
                          title: 'Flutter',
                          icon: SimpleIcons.flutter,
                          iconColor: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => FlutterCourseDetail()),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        CourseCard(
                          title: 'React Native',
                          icon: SimpleIcons.react,
                          iconColor: Colors.cyan,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        CourseCard(
                          title: 'Python',
                          icon: SimpleIcons.python,
                          iconColor: Colors.amber,
                        ),
                        SizedBox(width: 12),
                        CourseCard(
                          title: 'C#',
                          icon: Icons.code,
                          iconColor: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}