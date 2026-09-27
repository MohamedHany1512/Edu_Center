class ProfileModel {
  final String id;
  final String fullName;
  final String email;
  final String avatarUrl;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? 'مستخدم جديد',
      email: json['email']?.toString() ?? '',
      avatarUrl: json['avatar_url']?.toString() ?? '',
    );
  }
}