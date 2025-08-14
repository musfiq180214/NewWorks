class Video {
  final String title;
  final String url;
  final String duration;

  Video({
    required this.title,
    required this.url,
    required this.duration,
  });
}

// Sample video list
final List<Video> videos = [
  Video(
    title: "Flutter Login App",
    url: "https://youtu.be/yafX6haLWMA?si=ieSshFNh1m-zmoX8",
    duration: "20 min 50 sec",
  ),
  Video(
    title: "Flutter Folder Structure",
    url: "https://youtu.be/iWsfGf_UEXE?si=sHf92PdDQkKPq0BK",
    duration: "15 min 30 sec",
  ),
  Video(
    title: "Flutter Theme",
    url: "https://youtu.be/Q9FosAdX2U4?si=RmLY5OhiVCBDoS9L",
    duration: "18 min 20 sec",
  ),
  Video(
    title: "Native Splash Screen in Flutter",
    url: "https://youtu.be/4Aawfl6yOg4?si=qZgue0K9TfHikrxx",
    duration: "22 min 10 sec",
  ),
];
