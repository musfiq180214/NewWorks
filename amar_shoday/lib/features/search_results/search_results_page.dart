import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class SearchResultsPage extends StatelessWidget {
  final String searchQuery;

  const SearchResultsPage({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Static list of search results (mock)
    final List<Map<String, String>> results = [
      {"name": "Soyabin Oil", "image": "assets/soyabin_oil.png"},
      {"name": "Rice", "image": "assets/rice.png"},
      {"name": "Local Onion", "image": "assets/local_onion.png"},
      {"name": "Maggie", "image": "assets/maggie.png"},
      {"name": "Chola Boot", "image": "assets/chola_boot.png"},
    ];

    // Filter results based on searchQuery (case-insensitive)
    final filteredResults = results
        .where((item) =>
            item["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("search_results".tr()),
        backgroundColor: Colors.indigo.shade900,
      ),
      body: filteredResults.isEmpty
          ? Center(
              child: Text(
                "no_results_found".tr(),
                style: const TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: filteredResults.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = filteredResults[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: item["image"] != null
                        ? Image.asset(
                            item["image"]!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : null,
                    title: Text(item["name"]!),
                    subtitle: Text("product_description".tr()),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Add navigation to product details later
                    },
                  ),
                );
              },
            ),
    );
  }
}
