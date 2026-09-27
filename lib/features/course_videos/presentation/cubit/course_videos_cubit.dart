import 'package:edu_app/features/course_videos/data/models/video_model.dart';
import 'package:edu_app/features/course_videos/data/repo/course_videos_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'course_videos_state.dart';

/// Loads the lessons that make up a course.
class CourseVideosCubit extends Cubit<CourseVideosState> {
  CourseVideosCubit({required CourseVideosRepo courseVideosRepo})
    : _courseVideosRepo = courseVideosRepo,
      super(const CourseVideosInitial());

  final CourseVideosRepo _courseVideosRepo;

  /// The course currently loaded, retained so the failure state's retry action
  /// can re-request the same lessons.
  String? _courseId;

  String? get courseId => _courseId;

  Future<void> getCourseVideos(String courseId) async {
    _courseId = courseId;
    emit(const CourseVideosLoading());

    final result = await _courseVideosRepo.getCourseVideos(courseId);

    if (isClosed) return;

    result.fold(
      (failure) => emit(CourseVideosFailure(message: failure)),
      (videos) => emit(CourseVideosLoaded(videos)),
    );
  }
}