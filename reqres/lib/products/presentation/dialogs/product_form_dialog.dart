import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reqres/products/data/Product.dart';
import 'dart:typed_data';

class ProductFormDialog extends StatefulWidget {
  final Product? existing;

  const ProductFormDialog({super.key, this.existing});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _thumbFieldKey =
      GlobalKey<FormFieldState<String>>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _categoryCtrl;

  final ImagePicker _picker = ImagePicker();

  // We keep both a path (useful for mobile/native workflows) and bytes (for preview
  // on any platform). On mobile, XFile.path will be populated.
  String? _thumbnailPath;
  Uint8List? _thumbnailBytes;

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
    // If existing product already had a thumbnail string, keep it so the user can keep it.
    // Note: if the existing thumbnail was a network URL, we won't load bytes here.
    _thumbnailPath = widget.existing?.thumbnail;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      // Open gallery
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1600,
      );
      if (picked == null) return;

      // Read bytes for preview (works on mobile & web)
      final bytes = await picked.readAsBytes();

      setState(() {
        _thumbnailBytes = bytes;
        _thumbnailPath = picked.path; // mobile: actual filesystem path
      });

      // Update the FormField state (so validation / error text updates)
      _thumbFieldKey.currentState?.didChange(_thumbnailPath);
    } on PlatformException catch (e) {
      // Permission or platform error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: ${e.message}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to pick image: $e')));
      }
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      id: widget.existing?.id ?? 0,
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
      category: _categoryCtrl.text.trim(),
      thumbnail: _thumbnailPath ?? "", // returns path (or empty string)
    );

    Navigator.pop(context, product);
  }

  @override
  Widget build(BuildContext context) {
    // Compute a friendly file name for display if path exists
    final selectedFileName = (_thumbnailPath ?? "").isNotEmpty
        ? (_thumbnailPath!.split('/').isNotEmpty
              ? _thumbnailPath!.split('/').last
              : _thumbnailPath)
        : null;

    return AlertDialog(
      title: Text(widget.existing == null ? 'Add Product' : 'Edit Product'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter description' : null,
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              TextFormField(
                controller: _categoryCtrl,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter category' : null,
              ),
              const SizedBox(height: 12),

              // Thumbnail selection field (looks & behaves like a form field)
              FormField<String>(
                key: _thumbFieldKey,
                initialValue: _thumbnailPath ?? "",
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Select image' : null,
                builder: (state) {
                  return GestureDetector(
                    onTap: _pickImage,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Thumbnail',
                        errorText: state.errorText,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          tooltip: 'Pick image',
                          icon: const Icon(Icons.photo_library),
                          onPressed: _pickImage,
                        ),
                      ),
                      // child content shows preview (if any) and filename / hint
                      child: Row(
                        children: [
                          if (_thumbnailBytes != null) ...[
                            Container(
                              width: 72,
                              height: 72,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Image.memory(
                                _thumbnailBytes!,
                                fit: BoxFit.cover,
                                width: 72,
                                height: 72,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                selectedFileName ?? 'Selected image',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ] else if ((_thumbnailPath ?? "").isNotEmpty) ...[
                            // no bytes but have a path string (existing product); show filename text
                            Container(
                              width: 72,
                              height: 72,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(Icons.image_outlined),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                selectedFileName ?? _thumbnailPath!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ] else ...[
                            Expanded(
                              child: Text(
                                'Tap to select image from device',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }
}
