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
    title: "Flutter Crash Course #1 - What is Flutter?",
    url: "https://youtu.be/j_rCDc_X-k8?si=cWYfp4DyOykwl0JQ",
    duration: "20 min 50 sec",
  ),
  Video(
    title: "FLutter Crash Course #2 - Installing on Windows",
    url: "https://youtu.be/DvZuJeTHWaw?si=6c8vS1xFrWQdawam",
    duration: "15 min 30 sec",
  ),
  Video(
    title: "Flutter Crash Course #3 - Installing on Mac",
    url: "https://youtu.be/BwKfjzxTGXI?si=u1KCuKafC25iXDVY",
    duration: "18 min 20 sec",
  ),
  Video(
    title: "Flutter Crash Course #4 - Making a New Flutter Project",
    url: "https://youtu.be/adNHZVBd284?si=twikSHm2KCj5x-yj",
    duration: "22 min 10 sec",
  ),
];
