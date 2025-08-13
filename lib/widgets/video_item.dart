import 'package:flutter/material.dart';

class VideoItem extends StatelessWidget {
  final String title;
  final String duration;

  const VideoItem({super.key, required this.title, required this.duration});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(duration),
      trailing: const Icon(Icons.play_circle_fill, color: Colors.blue),
    );
  }
}
