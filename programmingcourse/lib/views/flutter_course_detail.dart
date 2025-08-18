import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/video.dart';
import '../providers/video_provider.dart';

class FlutterCourseDetail extends StatelessWidget {
  const FlutterCourseDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoProvider(),
      child: Builder(
        builder: (context) {
          final videoProvider = Provider.of<VideoProvider>(context, listen: false);

          // Set callback when playlist ends
          videoProvider.onPlaylistEnd = () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => ThankYouScreen()),
            );
          };

          return Scaffold(
            appBar: AppBar(
              title: Text('Flutter Course'),
              centerTitle: true,
            ),
            body: Consumer<VideoProvider>(
              builder: (context, videoProvider, _) {
                return Column(
                  children: [
                    // Video Player
                    if (videoProvider.controller != null)
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: YoutubePlayer(
                          key: ValueKey(videoProvider.currentVideo?.url),
                          controller: videoProvider.controller!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.blueAccent,
                          progressColors: ProgressBarColors(
                            playedColor: Colors.blue,
                            handleColor: Colors.blueAccent,
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 220,
                        color: Colors.black12,
                        child: Center(
                          child: Text(
                            'Select a video to play',
                            style: TextStyle(fontSize: 16, color: Colors.black54),
                          ),
                        ),
                      ),

                    Divider(),

                    // Video List
                    Expanded(
                      child: ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final video = videos[index];
                          final isPlaying =
                              videoProvider.currentVideo?.title == video.title;
                          return Container(
                            color: isPlaying ? Colors.blue.shade50 : null,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              title: Text(
                                video.title,
                                style: TextStyle(
                                  fontWeight: isPlaying
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(video.duration),
                              trailing: isPlaying
                                  ? Icon(Icons.play_arrow, color: Colors.blue)
                                  : null,
                              onTap: () {
                                videoProvider.playVideo(video, index: index);
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    // Controls
                    if (videoProvider.controller != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.skip_previous, size: 40),
                              color: videoProvider.currentIndex > 0
                                  ? Colors.blue
                                  : Colors.grey,
                              onPressed: videoProvider.currentIndex > 0
                                  ? videoProvider.playPrevious
                                  : null,
                            ),
                            IconButton(
                              icon: SizedBox(
                                width: 60,
                                height: 60,
                                child: Icon(
                                  videoProvider.controller!.value.isPlaying
                                      ? Icons.play_circle_filled
                                      : Icons.pause_circle_filled,
                                  size: 50,
                                  color: Colors.blue,
                                ),
                              ),
                              onPressed: () {
                                if (videoProvider.controller!.value.isPlaying) {
                                  videoProvider.pauseVideo();
                                } else {
                                  videoProvider.resumeVideo();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.skip_next, size: 40),
                              color: videoProvider.currentIndex < videos.length - 1
                                  ? Colors.blue
                                  : Colors.grey,
                              onPressed: videoProvider.currentIndex < videos.length - 1
                                  ? videoProvider.playNext
                                  : null,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events, size: 80, color: Colors.orange),
                  SizedBox(height: 20),
                  Text(
                    'Thanks!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'You have completed all videos in this course.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
