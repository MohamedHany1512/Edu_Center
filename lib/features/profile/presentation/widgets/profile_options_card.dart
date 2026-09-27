import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/routing/routes.dart';
 import 'package:edu_app/features/profile/presentation/widgets/custom_divider.dart';
import 'package:edu_app/features/profile/presentation/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
 
class ProfileOptionsCard extends StatelessWidget {
  const ProfileOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets
          .zero, // لان card لها margin افتراضي فممكن يبان اصغر من الشكل اللي فوقه فبنصفره
      color: AppColors.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CustomListTile(
              text: "MyFavorites",
              icon: Icons.favorite,
              onTap: () {
                Navigator.pushNamed(context, Routes.myFavoritesPage);
              },
            ),
            CustomDivider(
              color: AppColors.accent,
              thickness: 2,
              indent: 15,
              endIndent: 15,
            ),
            CustomListTile(
              text: "Contact",
              icon: Icons.contact_phone,
              onTap: () {},
            ),
            CustomDivider(
              color: AppColors.accent,
              thickness: 2,
              indent: 15,
              endIndent: 15,
            ),
            CustomListTile(
              text: "Privacy and security",
              icon: Icons.security,
              onTap: () {},
            ),
            CustomDivider(
              color: AppColors.accent,
              thickness: 2,
              indent: 15,
              endIndent: 15,
            ),
            CustomListTile(
              text: "Settings",
              icon: Icons.settings,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
