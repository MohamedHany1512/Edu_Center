import 'package:edu_app/core/constants/app_colors.dart';
import 'package:edu_app/core/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

/// Curved brand header with the greeting and the catalogue search field.
///
/// Extracted from `home_page.dart` so the page only orchestrates state.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.name,
    required this.searchController,
    required this.onSearch,
  });

  final String name;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اهلا, $name 👋',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'مرحبا بك',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 18),
          CustomTextFormField(
            controller: searchController,
            hintText: 'ما الذي تبحث عنه ؟؟',
            textInputAction: TextInputAction.search,
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.primary,
            ),
            onChanged: onSearch,
          ),
        ],
      ),
    );
  }
}
