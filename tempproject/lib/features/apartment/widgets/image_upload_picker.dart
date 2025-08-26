import 'dart:io';
import 'package:flutter/material.dart';

class ImageUploadPicker extends StatelessWidget {
  final File? pickedImage;
  final VoidCallback onPickImage;

  const ImageUploadPicker({
    super.key,
    required this.pickedImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onPickImage,
          icon: const Icon(Icons.photo_library),
          label: const Text("Choose from Gallery"),
        ),
        const SizedBox(height: 8),
        pickedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  pickedImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : const Text("No image selected"),
      ],
    );
  }
}
