import 'package:flutter/material.dart';
import 'package:reqres/products/data/Product.dart';
import 'package:reqres/products/presentation/dialogs/product_form_dialog.dart';
import 'package:reqres/products/service/ProductService.dart';

class ProductViewPage extends StatefulWidget {
  final Product product;

  const ProductViewPage({super.key, required this.product});

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  late Product _product;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _onEdit() async {
    final result = await showDialog<Product>(
      context: context,
      builder: (_) => ProductFormDialog(existing: _product),
    );
    if (result == null) return;

    setState(() => _busy = true);
    try {
      final updated = await ProductService.updateProduct(
        result.copyWith(id: _product.id),
      );
      setState(() {
        _product = updated;
        _busy = false;
      });
      // Return to list with updated product so it can refresh
      if (mounted) {
        Navigator.pop(context, {'action': 'updated', 'product': updated});
      }
    } catch (e) {
      setState(() => _busy = false);
      _snack('Update failed: $e');
    }
  }

  Future<void> _onDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Delete "${_product.title}"?'),
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

    setState(() => _busy = true);
    try {
      await ProductService.deleteProduct(_product.id);
      if (!mounted) return;
      Navigator.pop(context, {'action': 'deleted', 'id': _product.id});
    } catch (e) {
      setState(() => _busy = false);
      _snack('Delete failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _busy,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_product.title),
          actions: [
            IconButton(
              onPressed: _onEdit,
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
            ),
            IconButton(
              onPressed: _onDelete,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  _product.thumbnail,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 250,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported, size: 60),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                _product.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Price + Category
              Row(
                children: [
                  Chip(label: Text("\$${_product.price.toStringAsFixed(2)}")),
                  const SizedBox(width: 8),
                  Chip(label: Text(_product.category)),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(_product.description, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 24),

              // Bottom actions (duplicate for visibility)
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _onEdit,
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _onDelete,
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    ),
                  ),
                ],
              ),
              if (_busy) ...[
                const SizedBox(height: 16),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
