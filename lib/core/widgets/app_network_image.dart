import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../extensions/context_theme_extension.dart';

/// A resilient network image with a themed placeholder.
///
/// Replaces the four near-identical `Image.network(... errorBuilder: ...)`
/// blocks previously repeated in the home, my-courses, my-favorites, course
/// details and profile widgets. Also guards against empty URLs, which would
/// otherwise throw at runtime instead of falling back.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackIcon = Icons.school_rounded,
    this.fallbackIconSize = 40,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData fallbackIcon;
  final double fallbackIconSize;

  /// Helper method to safely convert double dimensions to integer cache dimensions.
  int? _safeCacheDimension(double? value) {
    if (value == null || !value.isFinite || value.isNaN) {
      return null;
    }
    return value.round();
  }

  @override
  Widget build(BuildContext context) {
    final fallback = _ImageFallback(
      width: width,
      height: height,
      icon: fallbackIcon,
      iconSize: fallbackIconSize,
    );

    final image = (url.trim().isEmpty)
        ? fallback
        : Image.network(
            url,
            width: width,
            height: height,
            fit: fit,
            // Resize decoded bitmaps to the layout size to cut memory usage
            // safely without throwing on Infinity or NaN values.
            cacheWidth: _safeCacheDimension(width),
            cacheHeight: _safeCacheDimension(height),
            errorBuilder: (_, _, _) => fallback,
          );

    if (borderRadius == null) return image;

    return ClipRRect(borderRadius: borderRadius!, child: image);
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({
    required this.width,
    required this.height,
    required this.icon,
    required this.iconSize,
  });

  final double? width;
  final double? height;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: context.resolve(AppColors.surfaceDark, AppColors.bgLight),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: context.textSecondary),
    );
  }
}
