/// A single lesson video.
class VideoModel {
  const VideoModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.url,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'بدون عنوان',
      // Falls back to the duration when no description was written.
      desc:
          json['description']?.toString() ?? json['duration']?.toString() ?? '',
      url: json['video_url']?.toString() ?? json['url']?.toString() ?? '',
    );
  }

  final String id;
  final String title;
  final String desc;
  final String url;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': desc,
      'video_url': url,
    };
  }
}