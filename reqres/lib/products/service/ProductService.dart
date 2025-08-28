import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reqres/products/data/Product.dart';

class ProductService {
  static const base = 'https://dummyjson.com';

  static Future<List<Product>> fetchProducts() async {
    final res = await http.get(Uri.parse('$base/products?limit=50'));
    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final List list = decoded['products'] ?? [];
      return list.map((e) => Product.fromJson(e)).toList();
    }
    throw Exception('Failed to load products (${res.statusCode})');
  }

  static Future<Product> addProduct(Product p) async {
    final res = await http.post(
      Uri.parse('$base/products/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (res.statusCode == 200 || res.statusCode == 201) {
      final created = Product.fromJson(jsonDecode(res.body));
      return created.copyWith(thumbnail: p.thumbnail);
    }
    throw Exception('Add failed (${res.statusCode})');
  }

  static Future<Product> updateProduct(Product p) async {
    final res = await http.patch(
      Uri.parse('$base/products/${p.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (res.statusCode == 200) {
      final updated = Product.fromJson(jsonDecode(res.body));
      return updated.copyWith(thumbnail: p.thumbnail);
    }
    throw Exception('Update failed (${res.statusCode})');
  }

  static Future<void> deleteProduct(int id) async {
    final res = await http.delete(Uri.parse('$base/products/$id'));
    if (res.statusCode != 200) {
      throw Exception('Delete failed (${res.statusCode})');
    }
  }
}
