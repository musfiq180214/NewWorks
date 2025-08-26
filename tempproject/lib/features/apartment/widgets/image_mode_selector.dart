import 'package:flutter/material.dart';

enum ImageInputMode { url, upload }

class ImageModeSelector extends StatelessWidget {
  final ImageInputMode mode;
  final ValueChanged<ImageInputMode?> onChanged;

  const ImageModeSelector({
    super.key,
    required this.mode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<ImageInputMode>(
            title: const Text("Image URL"),
            value: ImageInputMode.url,
            groupValue: mode,
            onChanged: onChanged,
          ),
        ),
        Expanded(
          child: RadioListTile<ImageInputMode>(
            title: const Text("Upload"),
            value: ImageInputMode.upload,
            groupValue: mode,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
