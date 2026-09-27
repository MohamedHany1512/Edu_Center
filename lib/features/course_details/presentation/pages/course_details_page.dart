import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/functions.dart';
import 'package:edu_app/core/routing/routes.dart';
import 'package:edu_app/core/widgets/app_loading_view.dart';
import 'package:edu_app/core/widgets/custom_button.dart';
import 'package:edu_app/features/course_details/data/repo/course_details_repo.dart';
import 'package:edu_app/features/course_details/presentation/cubit/course_details_cubit.dart';
import 'package:edu_app/features/course_details/presentation/pages/widgets/state_item.dart';
import 'package:edu_app/features/course_videos/data/models/video_model.dart';
import 'package:edu_app/features/course_videos/data/repo/course_videos_repo.dart';
import 'package:edu_app/features/course_videos/presentation/cubit/course_videos_cubit.dart';
import 'package:edu_app/core/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseDetailsPage extends StatelessWidget {
  final CourseModel courseModel;

  const CourseDetailsPage({super.key, required this.courseModel});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CourseDetailsCubit(courseDetailsRepo: CourseDetailsRepo())
                ..loadCourseState(courseModel.id),
        ),
        BlocProvider(
          create: (context) =>
              CourseVideosCubit(courseVideosRepo: CourseVideosRepo())
                ..getCourseVideos(courseModel.id),
        ),
      ],
      child: _CourseDetailsView(courseModel: courseModel),
    );
  }
}

class _CourseDetailsView extends StatefulWidget {
  final CourseModel courseModel;

  const _CourseDetailsView({required this.courseModel});

  @override
  State<_CourseDetailsView> createState() => _CourseDetailsViewState();
}

class _CourseDetailsViewState extends State<_CourseDetailsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openFirstVideo(List<VideoModel> videos) {
    if (videos.isEmpty) {
      Navigator.pushNamed(
        context,
        Routes.courseVideos,
        arguments: widget.courseModel,
      );
      return;
    }
    Navigator.pushNamed(context, Routes.videoPage, arguments: videos.first);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final course = widget.courseModel;

    return BlocConsumer<CourseDetailsCubit, EnrollmentState>(
      listener: (context, state) {
        if (state is EnrollmentFailure) {
          snackBarMessage(
            context: context,
            text: state.errorMessage,
            backgroundColor: AppColors.error,
          );
        }
      },
      builder: (context, state) {
        final isEnrolled = state is EnrollmentSuccess && state.isEnrolled;
        final isEnrolling = state is EnrollmentLoading;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: isDark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: (isDark ? Colors.black : Colors.white)
                        .withValues(alpha: 0.7),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, size: 20),
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: (isDark ? Colors.black : Colors.white)
                          .withValues(alpha: 0.7),
                      child: BlocBuilder<CourseDetailsCubit, EnrollmentState>(
                        builder: (context, favState) {
                          final fav = favState is EnrollmentSuccess
                              ? favState.isFavorite
                              : false;
                          return IconButton(
                            icon: Icon(
                              fav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_outline_rounded,
                              size: 20,
                              color: fav
                                  ? AppColors.error
                                  : (isDark
                                        ? Colors.white
                                        : AppColors.textPrimaryLight),
                            ),
                            onPressed: () {
                              context.read<CourseDetailsCubit>().toggleFavorite(
                                courseId: course.id,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Image.network(
                        course.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.school,
                            size: 60,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            iconSize: 42,
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              final videosState = context
                                  .read<CourseVideosCubit>()
                                  .state;
                              if (videosState is CourseVideosLoaded) {
                                _openFirstVideo(videosState.videos);
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  Routes.courseVideos,
                                  arguments: course,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (course.category.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                course.category,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          else
                            const SizedBox.shrink(),
                          Row(
                            children: [
                              if (course.rating > 0) ...[
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.starRating,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  course.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ] else
                                Text(
                                  'جديد',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (course.instructorName.isNotEmpty) ...[
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              course.instructorName,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceDark
                              : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            BlocBuilder<CourseVideosCubit, CourseVideosState>(
                              builder: (context, videosState) {
                                final lessons =
                                    videosState is CourseVideosLoaded
                                    ? videosState.videos.length
                                    : course.lessonsCount;
                                return StatItem(
                                  icon: Icons.play_lesson_rounded,
                                  label: '$lessons درس',
                                );
                              },
                            ),
                            const StatItem(
                              icon: Icons.workspace_premium_rounded,
                              label: 'شهادة',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                        indicatorColor: AppColors.primary,
                        indicatorWeight: 3,
                        indicatorSize: TabBarIndicatorSize.label,
                        tabs: const [
                          Tab(text: 'عن الكورس'),
                          Tab(text: 'محتوى الدروس'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 280,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              child: Text(
                                course.desc.isEmpty
                                    ? 'لا يوجد وصف لهذا الكورس.'
                                    : course.desc,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.6,
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondaryLight,
                                ),
                              ),
                            ),
                            BlocBuilder<CourseVideosCubit, CourseVideosState>(
                              builder: (context, videosState) {
                                if (videosState is CourseVideosLoading) {
                                  return const AppLoadingView();
                                }
                                if (videosState is CourseVideosFailure) {
                                  return Center(
                                    child: Text(
                                      videosState.message,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: AppColors.error,
                                        fontSize: 13,
                                      ),
                                    ),
                                  );
                                }
                                if (videosState is CourseVideosLoaded) {
                                  if (videosState.videos.isEmpty) {
                                    return Center(
                                      child: Text(
                                        'لا توجد دروس متاحة بعد.',
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    );
                                  }
                                  return ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: videosState.videos.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                    itemBuilder: (context, index) {
                                      final video = videosState.videos[index];
                                      return ListTile(
                                        dense: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: BorderSide(
                                            color: isDark
                                                ? AppColors.borderDark
                                                : AppColors.borderLight,
                                          ),
                                        ),
                                        onTap: () => Navigator.pushNamed(
                                          context,
                                          Routes.videoPage,
                                          arguments: video,
                                        ),
                                        leading: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: AppColors.bgLight,
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          video.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        subtitle: video.desc.isEmpty
                                            ? null
                                            : Text(
                                                video.desc,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                      );
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 15,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'السعر',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                    Text(
                      '${course.price.toStringAsFixed(2)} EGP',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: CustomButton(
                    text: isEnrolled
                        ? 'ابدأ التعلم'
                        : (isEnrolling ? 'جاري الاشتراك' : 'الاشتراك الآن'),
                    isLoading: isEnrolling,
                    onPressed: () {
                      if (isEnrolled) {
                        Navigator.pushNamed(
                          context,
                          Routes.courseVideos,
                          arguments: course,
                        );
                        return;
                      }
                      context.read<CourseDetailsCubit>().enrollCourse(
                        course.id,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
