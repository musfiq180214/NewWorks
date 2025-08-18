import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// -----------------------
// Video State
// -----------------------
class VideoState {
  final bool isPlaying;

  VideoState({this.isPlaying = true});

  VideoState copyWith({bool? isPlaying}) =>
      VideoState(isPlaying: isPlaying ?? this.isPlaying);
}

// -----------------------
// Video Controller
// -----------------------
class VideoController extends StateNotifier<VideoState> {
  late YoutubePlayerController ytController;

  VideoController() : super(VideoState()) {
    ytController = YoutubePlayerController(
      initialVideoId: '2t6Bt04EyLw', // Video ID
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: true,
      ),
    );
  }

  void playPause() {
    if (ytController.value.isPlaying) {
      ytController.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      ytController.play();
      state = state.copyWith(isPlaying: true);
    }
  }

  @override
  void dispose() {
    ytController.dispose();
    super.dispose();
  }
}

// -----------------------
// Provider
// -----------------------
final videoProvider =
    StateNotifierProvider<VideoController, VideoState>((ref) {
  return VideoController();
});

// -----------------------
// Main App
// -----------------------
void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod YouTube Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: VideoPage(),
    );
  }
}

// -----------------------
// Video Page
// -----------------------
class VideoPage extends ConsumerWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(videoProvider.notifier);
    final state = ref.watch(videoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("YouTube Video Player")),
      body: Center(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: controller.ytController,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.red,
            onReady: () {
              controller.ytController.play();
            },
          ),
          builder: (context, player) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400,
                  child: player,
                ),
                const SizedBox(height: 30),
                IconButton(
                  icon: Icon(
                    state.isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 60,
                    color: Colors.blue,
                  ),
                  onPressed: () => controller.playPause(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
