import 'package:flutter/material.dart';
import 'package:programmingcourse/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoProvider extends ChangeNotifier {
  Video? _currentVideo;
  YoutubePlayerController? _controller;
  int _currentIndex = -1;

  Video? get currentVideo => _currentVideo;
  YoutubePlayerController? get controller => _controller;
  int get currentIndex => _currentIndex;

  void playVideo(Video video, {int? index}) {
    // Dispose old controller before switching
    _controller?.pause();
    _controller?.dispose();

    _currentVideo = video;
    if (index != null) {
      _currentIndex = index;
    }

    final videoId = YoutubePlayer.convertUrlToId(video.url);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    }

    notifyListeners();
  }

  void playNext() {
    if (_currentIndex < videos.length - 1) {
      playVideo(videos[_currentIndex + 1], index: _currentIndex + 1);
    }
  }

  void playPrevious() {
    if (_currentIndex > 0) {
      playVideo(videos[_currentIndex - 1], index: _currentIndex - 1);
    }
  }

  void pauseVideo() {
    _controller?.pause();
    notifyListeners();
  }

  void resumeVideo() {
    _controller?.play();
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
