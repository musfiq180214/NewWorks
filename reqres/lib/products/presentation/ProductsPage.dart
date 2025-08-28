import 'package:flutter/material.dart';
import 'package:reqres/products/data/Product.dart';
import 'package:reqres/products/presentation/ProductFormPage.dart';
import 'package:reqres/products/presentation/product_view_page.dart';
import 'package:reqres/products/service/ProductService.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final list = await ProductService.fetchProducts();
      setState(() => products = list);
    } catch (e) {
      _snack('Error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _onAdd() async {
    final result = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => const ProductFormPage()),
    );
    if (result != null) {
      try {
        final created = await ProductService.addProduct(result);
        setState(() => products = [created, ...products]);
        _snack('Product added successfully!');
      } catch (e) {
        _snack('Add failed: $e');
      }
    }
  }

  Future<void> _onEdit(Product p) async {
    final result = await Navigator.push<Product>(
      context,
      MaterialPageRoute(builder: (_) => ProductFormPage(existing: p)),
    );
    if (result != null) {
      try {
        final updated = await ProductService.updateProduct(
          result.copyWith(id: p.id),
        );
        final idx = products.indexWhere((x) => x.id == p.id);
        if (idx != -1) {
          setState(() => products[idx] = updated);
        }
        _snack('Product updated successfully!');
      } catch (e) {
        _snack('Update failed: $e');
      }
    }
  }

  Future<void> _onDelete(Product p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Delete "${p.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ProductService.deleteProduct(p.id);
      setState(() => products.removeWhere((x) => x.id == p.id));
      _snack('Product deleted!');
    } catch (e) {
      _snack('Delete failed: $e');
    }
  }

  Widget _productCard(Product p) {
    return InkWell(
      onTap: () async {
        final res = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductViewPage(product: p)),
        );
        if (!mounted) return;

        if (res is Map) {
          final action = res['action'];
          if (action == 'updated' && res['product'] is Product) {
            final updated = res['product'] as Product;
            final idx = products.indexWhere((x) => x.id == updated.id);
            if (idx != -1) {
              setState(() => products[idx] = updated);
            }
            _snack('Product updated!');
          } else if (action == 'deleted' && res['id'] is int) {
            final id = res['id'] as int;
            setState(() => products.removeWhere((x) => x.id == id));
            _snack('Product deleted!');
          }
        }
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                p.thumbnail,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  color: Colors.grey.shade300,
                  alignment: Alignment.center,
                  child: const Icon(Icons.image_not_supported, size: 50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(label: Text('\$${p.price.toStringAsFixed(2)}')),
                      const SizedBox(width: 6),
                      Chip(label: Text(p.category)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _onEdit(p),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("Edit"),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _onDelete(p),
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text("Delete"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DummyJSON Shop")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, i) => _productCard(products[i]),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onAdd,
        icon: const Icon(Icons.add),
        label: const Text("Add Product"),
      ),
    );
  }
}
