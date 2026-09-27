import 'package:edu_app/features/profile/presentation/widgets/custom_circle_avatar.dart';
import 'package:flutter/material.dart';
 
class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;

  const ProfileHeader({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomCircleAvatar(name: name),
        const SizedBox(height: 15),
        Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(email, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      ],
    );
  }
}
