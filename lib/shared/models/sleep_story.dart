class SleepStory {
  final String id;
  final String title;
  final String description;
  final String audioAsset;
  final int durationMinutes;
  final String? narrator;
  final String? imageAsset;
  final bool isPremium;

  const SleepStory({
    required this.id,
    required this.title,
    required this.description,
    required this.audioAsset,
    required this.durationMinutes,
    this.narrator,
    this.imageAsset,
    this.isPremium = false,
  });

  String get durationText => "$durationMinutes分钟";
}

class SleepStoryLibrary {
  SleepStoryLibrary._();

  static const List<SleepStory> stories = [
    SleepStory(
      id: "forest_cabin",
      title: "森林小屋",
      description: "想象你在一间温暖的森林小屋中，壁炉里火光跳动",
      audioAsset: "assets/audio/sleep_stories/forest_cabin.mp3",
      durationMinutes: 20,
      narrator: "林静",
    ),
    SleepStory(
      id: "ocean_sunset",
      title: "海边日落",
      description: "浪花轻拍沙滩，夕阳把天空染成橙红色",
      audioAsset: "assets/audio/sleep_stories/ocean_sunset.mp3",
      durationMinutes: 20,
      isPremium: true,
    ),
    SleepStory(
      id: "starry_night",
      title: "星空之旅",
      description: "踺在草地上仰望星空，银河横跨天际",
      audioAsset: "assets/audio/sleep_stories/starry_night.mp3",
      durationMinutes: 20,
      isPremium: true,
    ),
    SleepStory(
      id: "jiangnan_rain",
      title: "江南雨巷",
      description: "细雨滴答在青石板上，带你走进江南的梦境",
      audioAsset: "assets/audio/sleep_stories/jiangnan_rain.mp3",
      durationMinutes: 20,
      narrator: "林静",
    ),
    SleepStory(
      id: "snow_mountain",
      title: "雪山温泉",
      description: "在雪山环抱的温泉中放松身心",
      audioAsset: "assets/audio/sleep_stories/snow_mountain.mp3",
      durationMinutes: 20,
      isPremium: true,
    ),
  ];
}
