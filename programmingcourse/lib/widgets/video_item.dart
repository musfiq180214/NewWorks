import 'package:flutter/material.dart';

class VideoItem extends StatelessWidget {
  final String title;
  final String duration;

  const VideoItem({super.key, required this.title, required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            duration,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
