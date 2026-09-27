import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/functions.dart';
import 'package:edu_app/core/routing/routes.dart';
import 'package:edu_app/core/widgets/app_error_view.dart';
import 'package:edu_app/core/widgets/app_loading_view.dart';
import 'package:edu_app/features/profile/data/models/profile_model.dart';
import 'package:edu_app/features/profile/data/repo/profile_repo.dart';
import 'package:edu_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:edu_app/features/profile/presentation/widgets/courses_count_card.dart';
import 'package:edu_app/features/profile/presentation/widgets/profile_option_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class ProfilePage extends StatelessWidget {
  /// يزداد مع كل عرض للصفحة ليتم إعادة جلب البيانات
  final int refreshToken;

  const ProfilePage({super.key, this.refreshToken = 0});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileCubit(profileRepo: ProfileRepo())..getProfileData(),
      child: _ProfileView(refreshToken: refreshToken),
    );
  }
}

class _ProfileView extends StatefulWidget {
  final int refreshToken;

  const _ProfileView({required this.refreshToken});

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  @override
  void didUpdateWidget(covariant _ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // إعادة الجلب عند تغير العدّاد، أي كل مرة تُعرض فيها الصفحة
    if (widget.refreshToken != oldWidget.refreshToken) {
      context.read<ProfileCubit>().getProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          snackBarMessage(
            context: context,
            text: state.message,
            backgroundColor: AppColors.error,
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileInitial || state is ProfileLoading) {
          return const Scaffold(body: AppLoadingView());
        }

        if (state is ProfileFailure) {
          return Scaffold(
            body: AppErrorView(
              message: state.message,
              onRetry: () => context.read<ProfileCubit>().getProfileData(),
            ),
          );
        }

        if (state is ProfileLoaded) {
          return _ProfileBody(
            profile: state.profileModel,
            coursesCount: state.count,
            favoritesCount: state.favoritesCount,
          );
        }

        return const Scaffold(body: AppLoadingView());
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final ProfileModel profile;
  final int coursesCount;
  final int favoritesCount;

  const _ProfileBody({
    required this.profile,
    required this.coursesCount,
    required this.favoritesCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () => context.read<ProfileCubit>().getProfileData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            children: [
              // User Header Info Card - بيانات حقيقية من جدول profiles
              Center(
                child: Column(
                  children: [
                    _ProfileAvatar(
                      avatarUrl: profile.avatarUrl,
                      name: profile.fullName,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      profile.fullName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Real counts from user_courses and favorites tables
              Row(
                children: [
                  Expanded(
                    child: CoursesCountCard(
                      count: coursesCount,
                      title: 'دوراتي',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CoursesCountCard(
                      count: favoritesCount,
                      title: 'المفضلة',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 28,
              ), // Profile Options Section - real actions
              ProfileOptionTile(
                icon: Icons.favorite_outline_rounded,
                title: 'المفضلة',
                subtitle: 'الكورسات التي أضفتها إلى المفضلة',
                onTap: () {
                  Navigator.pushNamed(context, Routes.myFavoritesPage);
                },
              ),
              ProfileOptionTile(
                icon: Icons.play_circle_outline_rounded,
                title: 'دوراتي',
                subtitle: 'الكورسات التي اشتركت فيها',
                onTap: () {
                  Navigator.pushNamed(context, Routes.myCoursesPage);
                },
              ),
              ProfileOptionTile(
                icon: Icons.security_rounded,
                title: 'الأمان وكلمة المرور',
                subtitle: 'تغيير كلمة المرور الخاصة بحسابك',
                onTap: () {
                  Navigator.pushNamed(context, Routes.changePasswordPage);
                },
              ),
              ProfileOptionTile(
                icon: Icons.notifications_none_rounded,
                title: 'الإشعارات',
                subtitle: 'الإشعارات غير مفعّلة حالياً',
                onTap: () {
                  snackBarMessage(
                    context: context,
                    text: 'هذه الميزة غير متاحة حالياً',
                  );
                },
              ),
              const SizedBox(height: 10),
              ProfileOptionTile(
                icon: Icons.logout_rounded,
                title: 'تسجيل الخروج',
                isDestructive: true,
                onTap: () {
                  context.read<ProfileCubit>().logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  final String avatarUrl;
  final String name;

  const _ProfileAvatar({required this.avatarUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    final hasImage = avatarUrl.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: CircleAvatar(
        radius: 46,
        backgroundColor: AppColors.bgLight,
        child: hasImage
            ? ClipOval(
                child: Image.network(
                  avatarUrl,
                  width: 92,
                  height: 92,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _fallbackIcon(context),
                ),
              )
            : _fallbackIcon(context),
      ),
    );
  }

  Widget _fallbackIcon(BuildContext context) {
    final trimmed = name.trim();
    final letter = trimmed.isEmpty ? '' : trimmed[0].toUpperCase();

    return letter.isEmpty
        ? const Icon(Icons.person, size: 50, color: AppColors.primary)
        : Text(
            letter,
            style: const TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          );
  }
}
