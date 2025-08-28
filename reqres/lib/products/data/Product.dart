/* ============================ DATA ============================ */

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.thumbnail,
  });

  Product copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? thumbnail,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  factory Product.fromJson(Map<String, dynamic> j) {
    return Product(
      id: j['id'] is int ? j['id'] : int.tryParse(j['id'].toString()) ?? 0,
      title: j['title']?.toString() ?? '',
      description: j['description']?.toString() ?? '',
      price: double.tryParse(j['price'].toString()) ?? 0,
      category: j['category']?.toString() ?? 'general',
      thumbnail: j['thumbnail']?.toString().isNotEmpty == true
          ? j['thumbnail']
          : 'https://via.placeholder.com/300x200?text=No+Image',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'thumbnail': thumbnail,
    };
  }
}
