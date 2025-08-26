import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../domain/apartment_model.dart';
import '../provider/apartment_provider.dart';
import '../widgets/image_mode_selector.dart';
import '../widgets/image_upload_picker.dart';

class PostApartmentScreen extends ConsumerStatefulWidget {
  const PostApartmentScreen({super.key});

  @override
  ConsumerState<PostApartmentScreen> createState() =>
      _PostApartmentScreenState();
}

enum ApartmentType { forSale, toRent }

class _PostApartmentScreenState extends ConsumerState<PostApartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  ApartmentType _aptType = ApartmentType.forSale;

  bool _loading = false;
  ImageInputMode _mode = ImageInputMode.url;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _imageCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pasteImageUrl() async {
    final data = await Clipboard.getData('text/plain');
    if (!mounted) return;
    if (data?.text != null) {
      setState(() => _imageCtrl.text = data!.text!.trim());
    }
  }

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (!mounted) return;
      setState(() => _pickedImage = picked != null ? File(picked.path) : null);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_mode == ImageInputMode.upload && _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image before posting')));
      return;
    }
    setState(() => _loading = true);

    final newApartment = Apartment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      image: _mode == ImageInputMode.url
          ? _imageCtrl.text.trim()
          : "file://${_pickedImage!.path}",
      description: _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      type: _aptType == ApartmentType.forSale ? "For Sale" : "To Rent",
    );

    ref.read(apartmentListProvider.notifier).addApartment(newApartment);
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Apartment posted!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Apartment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleCtrl,
                  decoration: const InputDecoration(labelText: "Title"),
                  validator: (v) => (v?.isEmpty ?? true) ? "Enter title" : null,
                ),
                const SizedBox(height: 16),

                // ✅ New widget
                ImageModeSelector(
                  mode: _mode,
                  onChanged: (v) => setState(() => _mode = v!),
                ),

                if (_mode == ImageInputMode.url) ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _imageCtrl,
                          decoration:
                              const InputDecoration(labelText: "Image URL"),
                          validator: (v) => (v?.isEmpty ?? true)
                              ? "Enter image url"
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _pasteImageUrl,
                        child: const Text("Paste"),
                      ),
                    ],
                  ),
                ],

                if (_mode == ImageInputMode.upload) ...[
                  const SizedBox(height: 8),
                  // ✅ New widget
                  ImageUploadPicker(
                    pickedImage: _pickedImage,
                    onPickImage: _pickImage,
                  ),
                ],

                const SizedBox(height: 16),
                TextFormField(
                  controller: _descCtrl,
                  decoration: const InputDecoration(labelText: "Description"),
                  validator: (v) => (v?.isEmpty ?? true) ? "Enter description" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(labelText: "Price"),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                  ],
                  validator: (v) {
                    if (v?.isEmpty ?? true) return "Enter price";
                    if (double.tryParse(v!) == null) return "Invalid number";
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<ApartmentType>(
                        title: const Text("For Sale"),
                        value: ApartmentType.forSale,
                        groupValue: _aptType,
                        onChanged: (v) => setState(() => _aptType = v!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<ApartmentType>(
                        title: const Text("To Rent"),
                        value: ApartmentType.toRent,
                        groupValue: _aptType,
                        onChanged: (v) => setState(() => _aptType = v!),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: Text(_loading ? "Posting..." : "Post"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
