import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/apartment_model.dart';
import '../provider/apartment_sort_provider.dart';

class PostApartmentScreen extends ConsumerStatefulWidget {
  const PostApartmentScreen({super.key});

  @override
  ConsumerState<PostApartmentScreen> createState() =>
      _PostApartmentScreenState();
}

class _PostApartmentScreenState extends ConsumerState<PostApartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _imageCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final newApartment = Apartment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      image: _imageCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
    );

    ref.read(apartmentListProvider.notifier).addApartment(newApartment);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Apartment posted!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Post Apartment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter title" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _imageCtrl,
                decoration: const InputDecoration(labelText: "Image URL"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter image url" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: "Description"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Enter description" : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                ],
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter price";
                  if (double.tryParse(v) == null) return "Invalid number";
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: Text(_loading ? "Posting..." : "Post"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
