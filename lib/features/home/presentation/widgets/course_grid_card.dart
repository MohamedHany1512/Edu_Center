import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/extensions/context_theme_extension.dart';
import 'package:edu_app/core/models/course_model.dart';
import 'package:edu_app/core/utils/app_formatters.dart';
import 'package:edu_app/core/widgets/app_network_image.dart';
import 'package:flutter/material.dart';
 
class CourseGridCard extends StatelessWidget {
  const CourseGridCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final CourseModel course;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Thumbnail(
                imageUrl: course.image,
                category: AppFormatters.category(course.category),
                isFavorite: isFavorite,
                onFavoriteTap: onFavoriteTap,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        course.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                          height: 1.2,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _MetaRow(
                            rating: course.rating,
                            lessons: AppFormatters.lessons(course.lessonsCount),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            AppFormatters.price(course.price),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }}
class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.imageUrl,
    required this.category,
    required this.isFavorite,
    required this.onFavoriteTap,
  });

  final String imageUrl;
  final String category;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppNetworkImage(
          url: imageUrl,
          height: 120,
          width: double.infinity,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(18),
          ),
        ),

        // Category badge
        Positioned(
          top: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: (context.isDarkMode ? Colors.black : Colors.white)
                .withValues(alpha: 0.85),
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onFavoriteTap,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Icon(
                  isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_outline_rounded,
                  size: 16,
                  color: isFavorite ? AppColors.error : AppColors.success,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Rating star plus an optional lesson count.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.rating, required this.lessons});

  final double rating;
  final String? lessons;

  @override
  Widget build(BuildContext context) {
    final muted = context.textSecondary;

    return Row(
      children: [
        const Icon(Icons.star_rounded, color: AppColors.warning, size: 14),
        const SizedBox(width: 3),
        Text(
          AppFormatters.rating(rating),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: muted,
          ),
        ),
        if (lessons != null) ...[
          const SizedBox(width: 6),
          Text('•', style: TextStyle(color: muted, fontSize: 11)),
          const SizedBox(width: 6),
          const Icon(
            Icons.access_time_rounded,
            color: AppColors.textSecondaryLight,
            size: 12,
          ),
          const SizedBox(width: 3),
          Expanded(
            child: Text(
              lessons!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: muted),
            ),
          ),
        ],
      ],
    );
  }
}
  