import 'package:flutter/material.dart';
import '../../../core/utils/sizes.dart';

class ImageSlider extends StatelessWidget {
  final String imageUrl;

  const ImageSlider({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.imageWidth,
      height: AppSizes.imageHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(imageUrl, fit: BoxFit.cover),
    );
  }
}
