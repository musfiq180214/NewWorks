import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reqres/products/data/Product.dart';

class ProductFormPage extends StatefulWidget {
  final Product? existing;

  const ProductFormPage({super.key, this.existing});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _thumbCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title ?? "");
    _descCtrl = TextEditingController(text: widget.existing?.description ?? "");
    _priceCtrl = TextEditingController(
      text: widget.existing != null ? widget.existing!.price.toString() : "",
    );
    _categoryCtrl = TextEditingController(
      text: widget.existing?.category ?? "",
    );
    _thumbCtrl = TextEditingController(text: widget.existing?.thumbnail ?? "");
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _categoryCtrl.dispose();
    _thumbCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: widget.existing?.id ?? 0,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
      category: _categoryCtrl.text.trim(),
      thumbnail: _thumbCtrl.text.trim(),
    );

    Navigator.pop(context, product);
  }

  Future<void> _pasteIntoThumb() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      final text = data?.text?.trim();
      if (text != null && text.isNotEmpty) {
        _thumbCtrl
          ..text = text
          ..selection = TextSelection.collapsed(offset: _thumbCtrl.text.length);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existing == null ? 'Add Product' : 'Edit Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter description' : null,
              ),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) => v == null || double.tryParse(v) == null
                    ? 'Enter price'
                    : null,
              ),
              TextFormField(
                controller: _categoryCtrl,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter category' : null,
              ),
              TextFormField(
                controller: _thumbCtrl,
                decoration: InputDecoration(
                  labelText: 'Thumbnail URL',
                  suffixIcon: IconButton(
                    tooltip: 'Paste',
                    icon: const Icon(Icons.paste),
                    onPressed: _pasteIntoThumb,
                  ),
                ),
                keyboardType: TextInputType.url,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter thumbnail URL' : null,
              ),
              const SizedBox(height: 20),
              FilledButton(onPressed: _submit, child: const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
