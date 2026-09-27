import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/extensions/context_theme_extension.dart';
import 'package:edu_app/features/course_videos/data/models/video_model.dart';
import 'package:flutter/material.dart';

/// A single lesson row in the course content list.
class CourseVideoTile extends StatelessWidget {
  const CourseVideoTile({
    super.key,
    required this.video,
    required this.index,
    required this.onTap,
  });

  final VideoModel video;

  /// Zero-based position, displayed as the 1-based lesson number.
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
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
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
      subtitle: video.desc.isEmpty
          ? null
          : Text(
              video.desc,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: context.textSecondary),
            ),
      trailing: const Icon(
        Icons.play_circle_fill_rounded,
        color: AppColors.primary,
        size: 28,
      ),
    );
  }
}