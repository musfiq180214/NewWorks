import 'package:flutter/material.dart';
import 'package:programmingcourse/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoProvider extends ChangeNotifier {
  Video? _currentVideo;
  YoutubePlayerController? _controller;
  int _currentIndex = -1;
  bool _isDisposed = false;

  Video? get currentVideo => _currentVideo;
  YoutubePlayerController? get controller => _controller;
  int get currentIndex => _currentIndex;

  /// Callback for when the playlist ends
  /// 
  VoidCallback? onPlaylistEnd;

  /// Play selected video
  void playVideo(Video video, {int? index}) {
    if (_controller != null) {
      final oldController = _controller!;
      oldController.removeListener(_videoListener);
      Future.microtask(() => oldController.dispose());
    }

    _currentVideo = video;
    if (index != null) _currentIndex = index;

    final videoId = YoutubePlayer.convertUrlToId(video.url);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      )..addListener(_videoListener);
    }

    notifyListeners();
  }

  /// Listener to detect end of video
  void _videoListener() {
    if (_controller == null || _isDisposed) return;

    if (_controller!.value.playerState == PlayerState.ended) {
      if (_currentIndex < videos.length - 1) {
        Future.microtask(() {
          playNext();
        });
      } else {
        // Last video ended
        if (onPlaylistEnd != null) {
          Future.microtask(() => onPlaylistEnd!());
        }
      }
    }
  }

  /// Play next video
  void playNext() {
    if (_currentIndex < videos.length - 1) {
      playVideo(videos[_currentIndex + 1], index: _currentIndex + 1);
    }
  }

  /// Play previous video
  void playPrevious() {
    if (_currentIndex > 0) {
      playVideo(videos[_currentIndex - 1], index: _currentIndex - 1);
    }
  }

  /// Pause current video
  void pauseVideo() {
    _controller?.pause();
    notifyListeners();
  }

  /// Resume current video
  void resumeVideo() {
    _controller?.play();
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    super.dispose();
  }
}
