/// A course entity shared by the home, course-details, my-courses and
/// my-favorites features.
///
/// It previously lived under `features/home/data/models`, which forced three
/// unrelated features to import the home feature's data layer. Promoting it to
/// `core/models` removes that coupling.
class CourseModel {
  const CourseModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.image,
    required this.price,
    this.category = '',
    this.rating = 0.0,
    this.instructorName = '',
    this.lessonsCount = 0,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'عنوان غير متوفر',
      desc: json['description']?.toString() ?? '',
      image: json['image_url']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      category: json['category']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      instructorName: json['instructor_name']?.toString() ?? '',
      lessonsCount: (json['lessons_count'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String title;
  final String desc;
  final String image;
  final double price;
  final String category;
  final double rating;

   final String instructorName;

   final int lessonsCount;

  CourseModel copyWith({int? lessonsCount, double? rating}) {
    return CourseModel(
      id: id,
      title: title,
      desc: desc,
      image: image,
      price: price,
      category: category,
      rating: rating ?? this.rating,
      instructorName: instructorName,
      lessonsCount: lessonsCount ?? this.lessonsCount,
    );
  }

 
  static int parseLessonsCount(dynamic courseVideos) {
    if (courseVideos is! List || courseVideos.isEmpty) return 0;

    final first = courseVideos.first;
    if (first is Map && first['count'] is num) {
      return (first['count'] as num).toInt();
    }

    return courseVideos.length;
  }
}
