import 'package:dartz/dartz.dart';
import 'package:edu_app/features/profile/data/models/profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 
class ProfileRepo {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Either<String, ProfileModel>> getProfileData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return const Left("المستخدم غير مسجل الدخول");
      }

      // استخدام maybeSingle لتفادي Exception في حالة عدم وجود الصف
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response == null) {
        // الرجوع إلى بيانات حساب Supabase عند عدم وجود صف في profiles
        return Right(
          ProfileModel(
            id: user.id,
            fullName:
                user.userMetadata?['full_name']?.toString() ??
                user.email?.split('@').first ??
                'مستخدم جديد',
            email: user.email ?? '',
            avatarUrl: user.userMetadata?['avatar_url']?.toString() ?? '',
          ),
        );
      }

      return Right(ProfileModel.fromJson(response));
    } catch (e) {
      return Left('خطأ أثناء جلب بيانات البروفايل: ${e.toString()}');
    }
  }

  Future<Either<String, int>> getCoursesCount() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return const Right(0);

      // جلب عدد الاشتراكات من جدول user_courses
      final response = await supabase
          .from('user_courses')
          .select('id')
          .eq('user_id', user.id);

      return Right(response.length);
    } catch (e) {
      return Left('خطأ أثناء جلب عدد الكورسات: ${e.toString()}');
    }
  }

  Future<Either<String, int>> getFavoritesCount() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return const Right(0);

      final response = await supabase
          .from('favorites')
          .select('id')
          .eq('user_id', user.id);

      return Right(response.length);
    } catch (e) {
      return Left('خطأ أثناء جلب عدد المفضلة: ${e.toString()}');
    }
  }

  /// تحديث الاسم والصورة الشخصية للمستخدم
  Future<Either<String, void>> updateProfile({
    required String fullName,
    String? avatarUrl,
  }) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        return const Left("المستخدم غير مسجل الدخول");
      }

      await supabase.from('profiles').upsert({
        'id': user.id,
        'full_name': fullName,
        if (avatarUrl != null && avatarUrl.isNotEmpty) 'avatar_url': avatarUrl,
      });

      return const Right(null);
    } catch (e) {
      return Left('خطأ أثناء تحديث البيانات: ${e.toString()}');
    }
  }

  Future<Either<String, void>> logout() async {
    try {
      await supabase.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
