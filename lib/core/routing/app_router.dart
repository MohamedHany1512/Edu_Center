import 'package:edu_app/core/routing/routes.dart';
import 'package:edu_app/features/auth/data/repo/auth_repo.dart';
import 'package:edu_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:edu_app/features/auth/presentation/pages/change_password_page.dart';
import 'package:edu_app/features/auth/presentation/pages/forget_password_page.dart';
import 'package:edu_app/features/auth/presentation/pages/login_page.dart';
import 'package:edu_app/features/auth/presentation/pages/signup_page.dart';
import 'package:edu_app/features/course_details/presentation/pages/course_details_page.dart';
import 'package:edu_app/features/course_videos/data/models/video_model.dart';
import 'package:edu_app/features/course_videos/presentation/pages/course_videos_page.dart';
import 'package:edu_app/features/course_videos/presentation/pages/video_player_page.dart';
import 'package:edu_app/core/models/course_model.dart';
import 'package:edu_app/features/layout/presentation/pages/layout_page.dart';
import 'package:edu_app/features/my_favorites/presentation/pages/my_favorites_page.dart';
import 'package:edu_app/features/my_courses/presentation/pages/my_courses_page.dart';
import 'package:edu_app/features/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Maps named routes to their pages and provides the required blocs.
///
/// Every `AuthCubit` is created fresh per route. The previous code cast
/// `RouteSettings.arguments` with a bare `as`, which threw an unhelpful
/// `TypeError` when a route was pushed without arguments; [_arg] fails fast
/// with a clear message instead.
class AppRouter {
  const AppRouter();

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return _buildAuthRoute(const LoginPage());

      case Routes.signup:
        return _buildAuthRoute(const SignupPage());

      case Routes.forgetPasswordPage:
        return _buildAuthRoute(const ForgetPasswordPage());

      case Routes.changePasswordPage:
        return _buildAuthRoute(const ChangePasswordPage());

      case Routes.mainScreen:
        return MaterialPageRoute<void>(
          builder: (_) => const LayoutPage(),
          settings: settings,
        );

      case Routes.courseDetails:
        final course = _arg<CourseModel>(settings, Routes.courseDetails);
        return MaterialPageRoute<void>(
          builder: (_) => CourseDetailsPage(courseModel: course),
          settings: settings,
        );

      case Routes.courseVideos:
        final course = _arg<CourseModel>(settings, Routes.courseVideos);
        return MaterialPageRoute<void>(
          builder: (_) => CourseVideosPage(courseId: course.id),
          settings: settings,
        );

      case Routes.videoPage:
        final video = _arg<VideoModel>(settings, Routes.videoPage);
        return MaterialPageRoute<void>(
          builder: (_) => VideoPlayerPage(video: video),
          settings: settings,
        );

      case Routes.myFavoritesPage:
        return MaterialPageRoute<void>(
          builder: (_) => const MyFavoritesPage(),
          settings: settings,
        );

      case Routes.myCoursesPage:
        return MaterialPageRoute<void>(
          builder: (_) => const MyCoursesPage(),
          settings: settings,
        );

      case Routes.profilePage:
        return MaterialPageRoute<void>(
          builder: (_) => const ProfilePage(),
          settings: settings,
        );

      default:
        return MaterialPageRoute<void>(
          builder: (_) => const _NotFoundPage(),
          settings: settings,
        );
    }
  }

  /// Wraps [child] in a scoped [AuthCubit].
  MaterialPageRoute<void> _buildAuthRoute(Widget child) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<AuthCubit>(
        create: (_) => AuthCubit(authRepo: AuthRepo()),
        child: child,
      ),
    );
  }

  /// Safely reads and validates [RouteSettings.arguments].
  T _arg<T>(RouteSettings settings, String route) {
    final arguments = settings.arguments;
    if (arguments is T) return arguments;

    throw ArgumentError.value(
      arguments,
      'RouteSettings.arguments',
      'Route "$route" expects a $T but received '
          '${arguments.runtimeType}',
    );
  }
}

class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(child: Text('Page is not found')),
    );
  }
}
