// import 'package:flutter/material.dart';
// import '../widgets/video_item.dart';
// import 'video_player_page.dart';  // Import the video player

// class FlutterCourseDetail extends StatelessWidget {
//   const FlutterCourseDetail({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Appbar with back button, title centered, blue notification icon
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text('Flutter', style: TextStyle(color: Colors.black)),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 12),
//             child: Icon(Icons.notifications, color: Colors.blue),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image placeholder (clickable later)
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.network(
//                   'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrRQH-VwE2i1tPayFSVXkOhcSbwEUsOgbdww&s',
//                   height: 200,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Flutter Complete Course',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 6),
//               const Text('Created by Dear Programmer',
//                   style: TextStyle(fontSize: 14, color: Colors.grey)),
//               const SizedBox(height: 4),
//               const Text('55 Videos', style: TextStyle(fontSize: 12, color: Colors.grey)),
//               const SizedBox(height: 18),

//               // Tabs row (Videos / Description)
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       ),
//                       child: const Text('Videos'),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey.shade200,
//                         foregroundColor: Colors.black,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       ),
//                       child: const Text('Description'),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Videos list (4 items)
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const VideoPlayerPage(
//                         videoUrl: 'https://youtu.be/uvSrRBHtio8?si=1U0V5ap2ZQC-w9rE',
//                       ),
//                     ),
//                   );
//                 },
//                 child: const VideoItem(
//                   title: 'Introduction to Flutter',
//                   duration: '20 min 50 sec',
//                 ),
//               ),
//               const VideoItem(title: 'Installing Flutter on Windows', duration: '20 min 50 sec'),
//               const VideoItem(title: 'Setup Emulator on Windows', duration: '20 min 50 sec'),
//               const VideoItem(title: 'Creating Our First App', duration: '20 min 50 sec'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import '../widgets/video_item.dart';

// class FlutterCourseDetail extends StatefulWidget {
//   const FlutterCourseDetail({super.key});

//   @override
//   _FlutterCourseDetailState createState() => _FlutterCourseDetailState();
// }

// class _FlutterCourseDetailState extends State<FlutterCourseDetail> {
//   String? _currentVideoUrl;
//   YoutubePlayerController? _youtubeController;

//   void _loadVideo(String videoUrl) {
//     final videoId = YoutubePlayer.convertUrlToId(videoUrl);
//     if (videoId == null) {
//       // invalid url, do nothing or show error
//       return;
//     }

//     if (_youtubeController != null) {
//       _youtubeController!.dispose();
//     }

//     _youtubeController = YoutubePlayerController(
//       initialVideoId: videoId,
//       flags: const YoutubePlayerFlags(
//         autoPlay: true,
//         mute: false,
//         controlsVisibleAtStart: true,
//       ),
//     );

//     setState(() {
//       _currentVideoUrl = videoUrl;
//     });
//   }

//   @override
//   void dispose() {
//     _youtubeController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Appbar with back button, title centered, blue notification icon
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text('Flutter', style: TextStyle(color: Colors.black)),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.only(right: 12),
//             child: Icon(Icons.notifications, color: Colors.blue),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Video player or image placeholder at the top
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: _currentVideoUrl == null
//                     ? Image.network(
//                         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrRQH-VwE2i1tPayFSVXkOhcSbwEUsOgbdww&s',
//                         height: 200,
//                         width: double.infinity,
//                         fit: BoxFit.cover,
//                       )
//                     : YoutubePlayer(
//                         controller: _youtubeController!,
//                         showVideoProgressIndicator: true,
//                         progressIndicatorColor: Colors.blue,
//                         progressColors: const ProgressBarColors(
//                           playedColor: Colors.blue,
//                           handleColor: Colors.blueAccent,
//                         ),
//                       ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Flutter Complete Course',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 6),
//               const Text('Created by Dear Programmer',
//                   style: TextStyle(fontSize: 14, color: Colors.grey)),
//               const SizedBox(height: 4),
//               const Text('55 Videos', style: TextStyle(fontSize: 12, color: Colors.grey)),
//               const SizedBox(height: 18),

//               // Tabs row (Videos / Description)
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       ),
//                       child: const Text('Videos'),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey.shade200,
//                         foregroundColor: Colors.black,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                       ),
//                       child: const Text('Description'),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),

//               // Videos list - update GestureDetector to call _loadVideo with URLs
//               GestureDetector(
//                 onTap: () => _loadVideo('https://youtu.be/uvSrRBHtio8?si=1U0V5ap2ZQC-w9rE'),
//                 child: const VideoItem(
//                   title: 'Introduction to Flutter',
//                   duration: '20 min 50 sec',
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => _loadVideo('https://youtu.be/WEF_K8o5R6c'), // add actual URLs
//                 child: const VideoItem(
//                   title: 'Installing Flutter on Windows',
//                   duration: '20 min 50 sec',
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => _loadVideo('https://youtu.be/9j8kZp4FVxY'), // add actual URLs
//                 child: const VideoItem(
//                   title: 'Setup Emulator on Windows',
//                   duration: '20 min 50 sec',
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () => _loadVideo('https://youtu.be/I-0ghdB1Alw'), // add actual URLs
//                 child: const VideoItem(
//                   title: 'Creating Our First App',
//                   duration: '20 min 50 sec',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../widgets/video_item.dart';

class FlutterCourseDetail extends StatefulWidget {
  const FlutterCourseDetail({super.key});

  @override
  _FlutterCourseDetailState createState() => _FlutterCourseDetailState();
}

class _FlutterCourseDetailState extends State<FlutterCourseDetail> {
  String? _currentVideoUrl;
  YoutubePlayerController? _youtubeController;

  void _loadVideo(String videoUrl) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    if (videoId == null) {
      // Invalid URL, do nothing or show an error
      return;
    }

    if (_youtubeController != null) {
      _youtubeController!.dispose();
    }

    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: true,
      ),
    );

    setState(() {
      _currentVideoUrl = videoUrl;
    });
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar with back button, title centered, blue notification icon
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Flutter', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications, color: Colors.blue),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video player or image placeholder at the top
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _currentVideoUrl == null
                    ? Image.network(
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrRQH-VwE2i1tPayFSVXkOhcSbwEUsOgbdww&s',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : YoutubePlayer(
                        controller: _youtubeController!,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blue,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.blue,
                          handleColor: Colors.blueAccent,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Flutter Complete Course',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text('Created by Dear Programmer',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              const SizedBox(height: 4),
              const Text('55 Videos', style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 18),

              // Tabs row (Videos / Description)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Videos'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade200,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Description'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Videos list - click to load video above
              GestureDetector(
                onTap: () => _loadVideo('https://youtu.be/uvSrRBHtio8?si=1U0V5ap2ZQC-w9rE'),
                child: const VideoItem(
                  title: 'Introduction to Flutter',
                  duration: '20 min 50 sec',
                ),
              ),
              GestureDetector(
                onTap: () => _loadVideo('https://youtu.be/WEF_K8o5R6c'),
                child: const VideoItem(
                  title: 'Installing Flutter on Windows',
                  duration: '20 min 50 sec',
                ),
              ),
              GestureDetector(
                onTap: () => _loadVideo('https://youtu.be/9j8kZp4FVxY'),
                child: const VideoItem(
                  title: 'Setup Emulator on Windows',
                  duration: '20 min 50 sec',
                ),
              ),
              GestureDetector(
                onTap: () => _loadVideo('https://youtu.be/I-0ghdB1Alw'),
                child: const VideoItem(
                  title: 'Creating Our First App',
                  duration: '20 min 50 sec',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
