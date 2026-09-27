part of 'course_videos_cubit.dart';

/// Lesson-list states.
sealed class CourseVideosState {
  const CourseVideosState();
}

final class CourseVideosInitial extends CourseVideosState {
  const CourseVideosInitial();
}

final class CourseVideosLoading extends CourseVideosState {
  const CourseVideosLoading();
}

final class CourseVideosLoaded extends CourseVideosState {
  const CourseVideosLoaded(this.videos);

  final List<VideoModel> videos;
}

final class CourseVideosFailure extends CourseVideosState {
  const CourseVideosFailure({required this.message});

  final String message;
}