import 'package:flutter/material.dart';
import 'package:programmingcourse/models/video.dart';
import 'package:programmingcourse/providers/video_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FlutterCourseDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VideoProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Course Detail'),
          centerTitle: true,
        ),
        body: Consumer<VideoProvider>(
          builder: (context, videoProvider, _) {
            return Column(
              children: [
                // Video Player
                if (videoProvider.controller != null)
                  YoutubePlayer(
                    key: ValueKey(videoProvider.currentVideo?.url), // Force rebuild on switch
                    controller: videoProvider.controller!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                  )
                else
                  Container(
                    height: 200,
                    color: Colors.black12,
                    child: Center(
                      child: Text(
                        'Select a video to play',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  ),

                Divider(height: 1),

                // Video List
                Expanded(
                  child: ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      final isPlaying =
                          videoProvider.currentVideo?.title == video.title;
                      return ListTile(
                        title: Text(
                          video.title,
                          style: TextStyle(
                            fontWeight:
                                isPlaying ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(video.duration),
                        trailing: isPlaying
                            ? Icon(Icons.play_arrow, color: Colors.blue)
                            : null,
                        onTap: () {
                          videoProvider.playVideo(video, index: index);
                        },
                      );
                    },
                  ),
                ),

                // Controls (Prev, Play/Pause, Next)
                if (videoProvider.controller != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Previous Button
                        IconButton(
                          icon: Icon(Icons.skip_previous, size: 40),
                          color: videoProvider.currentIndex > 0
                              ? Colors.blue
                              : Colors.grey,
                          onPressed: videoProvider.currentIndex > 0
                              ? videoProvider.playPrevious
                              : null,
                        ),

                        // Play/Pause Button
                        IconButton(
                          icon: SizedBox(
                            width: 60,
                            height: 60,
                            child: Icon(
                              videoProvider.controller!.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 50,
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

                        // Next Button
                        IconButton(
                          icon: Icon(Icons.skip_next, size: 40),
                          color:
                              videoProvider.currentIndex < videos.length - 1
                                  ? Colors.blue
                                  : Colors.grey,
                          onPressed:
                              videoProvider.currentIndex < videos.length - 1
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
      ),
    );
  }
}
