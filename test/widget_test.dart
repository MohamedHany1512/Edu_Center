// Tests for the pure domain logic and the dependency-free core widgets.
//
// The previous contents of this file were the `flutter create` counter
// template. It pumped `EduApp` and asserted on a counter and a `+` button
// that this project has never had, so it failed on every run. `EduApp` also
// cannot be pumped directly because `main()` initialises SharedPreferences and
// Supabase before `runApp`, neither of which is available in a unit test.
//
// These tests cover code that needs no backend, so they stay deterministic
// and runnable in CI.

import 'package:edu_app/core/models/course_model.dart';
import 'package:edu_app/core/widgets/app_empty_view.dart';
import 'package:edu_app/features/course_details/presentation/pages/widgets/state_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CourseModel.parseLessonsCount', () {
    test('reads the aggregate shape produced by course_videos(count)', () {
      expect(CourseModel.parseLessonsCount([
        {'count': 16},
      ]), 16);
    });

    test('falls back to the row count for embedded video rows', () {
      expect(CourseModel.parseLessonsCount([
        {'id': '1'},
        {'id': '2'},
        {'id': '3'},
      ]), 3);
    });

    test('returns 0 for null and empty input', () {
      expect(CourseModel.parseLessonsCount(null), 0);
      expect(CourseModel.parseLessonsCount(<dynamic>[]), 0);
    });

    test('returns 0 when the value is not a list', () {
      expect(CourseModel.parseLessonsCount(7), 0);
    });
  });

  group('CourseModel.fromJson', () {
    test('applies safe defaults for missing fields', () {
      final course = CourseModel.fromJson(<String, dynamic>{});

      expect(course.id, '');
      expect(course.desc, '');
      expect(course.image, '');
      expect(course.price, 0);
      expect(course.rating, 0);
      expect(course.lessonsCount, 0);
    });

    test('reads the course_videos aggregate into lessonsCount', () {
      final course = CourseModel.fromJson(<String, dynamic>{
        'id': 7,
        'title': 'Dart',
        'description': 'From zero to hero',
        'image_url': 'https://example.com/dart.png',
        'price': 199.5,
        'rating': 4.5,
        'lessons_count': 12,
      });

      expect(course.id, '7');
      expect(course.title, 'Dart');
      expect(course.price, 199.5);
      expect(course.rating, 4.5);
      expect(course.lessonsCount, 12);
    });
  });

  testWidgets('AppEmptyView shows its message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppEmptyView(message: 'لا توجد كورسات')),
      ),
    );

    expect(find.text('لا توجد كورسات'), findsOneWidget);
  });

  testWidgets('StatItem renders its icon and label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatItem(icon: Icons.play_lesson_rounded, label: '10 درس'),
        ),
      ),
    );

    expect(find.text('10 درس'), findsOneWidget);
    expect(find.byIcon(Icons.play_lesson_rounded), findsOneWidget);
  });
}