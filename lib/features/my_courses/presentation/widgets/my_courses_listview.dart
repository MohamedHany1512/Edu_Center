import 'package:edu_app/core/models/course_model.dart';
import 'package:edu_app/core/routing/routes.dart';
 import 'package:edu_app/features/my_courses/presentation/widgets/my_course_card.dart';
import 'package:flutter/material.dart';
 
class MyCoursesListView extends StatelessWidget {
  const MyCoursesListView({super.key, required this.courses});

  final List<CourseModel> courses;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
      child: ListView.separated(
        itemCount: courses.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final course = courses[index];

          // عدد الدروس يأتي فعلياً من جدول course_videos
          final totalLessons = course.lessonsCount;

          return MyCourseCard(
            title: course.title,
            category: course.category.isEmpty ? 'دورة' : course.category,
            imageUrl: course.image,
            progress: 0,
            completedLessons: 0,
            totalLessons: totalLessons,
            onTap: () {
              Navigator.pushNamed(
                context,
                Routes.courseVideos,
                arguments: course,
              );
            },
          );
        },
      ),
    );
  }
}
