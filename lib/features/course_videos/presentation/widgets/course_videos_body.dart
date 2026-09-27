import 'package:edu_app/core/routing/app_navigation.dart';
import 'package:edu_app/core/routing/routes.dart';
import 'package:edu_app/core/widgets/app_empty_view.dart';
import 'package:edu_app/core/widgets/app_error_view.dart';
import 'package:edu_app/core/widgets/app_loading_view.dart';
import 'package:edu_app/features/course_videos/data/models/video_model.dart';
import 'package:edu_app/features/course_videos/presentation/cubit/course_videos_cubit.dart';
import 'package:edu_app/features/course_videos/presentation/widgets/course_video_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Renders the lesson list for a course: loading, error, empty or list.
class CourseVideosBody extends StatelessWidget {
  const CourseVideosBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseVideosCubit, CourseVideosState>(
      builder: (context, state) {
        return switch (state) {
          CourseVideosLoading() => const AppLoadingView(),
          CourseVideosFailure(:final message) => AppErrorView(
            message: message,
            onRetry: () {
              final id = context.read<CourseVideosCubit>().courseId;
              if (id != null) {
                context.read<CourseVideosCubit>().getCourseVideos(id);
              }
            },
          ),
          CourseVideosLoaded(:final videos) => videos.isEmpty
              ? const AppEmptyView(
                  message: 'No found videos',
                  icon: Icons.video_library_outlined,
                )
              : _VideoList(videos: videos),
          CourseVideosInitial() => const AppLoadingView(),
        };
      },
    );
  }
}

class _VideoList extends StatelessWidget {
  const _VideoList({required this.videos});

  final List<VideoModel> videos;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: videos.length,
      // Keys preserve scroll position and element state when the list updates.
      itemBuilder: (context, index) {
        final video = videos[index];
        return CourseVideoTile(
          key: ValueKey(video.id),
          video: video,
          index: index,
          onTap: () =>
              context.pushRoute<void>(Routes.videoPage, arguments: video),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 10),
    );
  }
}