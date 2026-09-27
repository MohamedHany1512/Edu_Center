import 'package:edu_app/core/widgets/custom_back_button.dart';
import 'package:edu_app/features/course_videos/data/repo/course_videos_repo.dart';
import 'package:edu_app/features/course_videos/presentation/cubit/course_videos_cubit.dart';
import 'package:edu_app/features/course_videos/presentation/widgets/course_videos_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lesson list for a single course.
///
/// Owns the [CourseVideosCubit] and delegates rendering to
/// [CourseVideosBody], which is also embedded in the course-details page.
class CourseVideosPage extends StatelessWidget {
  const CourseVideosPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CourseVideosCubit(courseVideosRepo: CourseVideosRepo())
            ..getCourseVideos(courseId),
      child: Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(),
          title: const Text('الدروس'),
          centerTitle: true,
        ),
        body: const CourseVideosBody(),
      ),
    );
  }
}