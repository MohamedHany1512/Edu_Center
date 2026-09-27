/// Named route paths.
///
/// `abstract final` prevents the class from being instantiated. The previous
/// `AppStrings` class duplicated the login/signup entries with a different
/// casing, which made it possible to navigate to a route that does not exist.
abstract final class Routes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String mainScreen = '/mainScreen';

  static const String courseDetails = '/courseDetails';
  static const String courseVideos = '/courseVideos';
  static const String videoPage = '/videoPage';

  static const String myFavoritesPage = '/myFavoritesPage';
  static const String myCoursesPage = '/myCoursesPage';

  static const String forgetPasswordPage = '/forgetPasswordPage';
  static const String changePasswordPage = '/changePasswordPage';
  static const String profilePage = '/profilePage';
}
