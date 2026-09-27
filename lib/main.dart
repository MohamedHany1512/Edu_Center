import 'package:edu_app/core/classes/app_bloc_observer.dart';
import 'package:edu_app/core/classes/auth_state_listener.dart';
import 'package:edu_app/core/networking/supabase_services.dart';
import 'package:edu_app/core/routing/app_navigation.dart';
import 'package:edu_app/core/routing/app_router.dart';
import 'package:edu_app/core/shared_prefs/shared_preferences_helper.dart';
import 'package:edu_app/core/theme/app_themes.dart';
import 'package:edu_app/features/auth/presentation/pages/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferencesHelper.init();

  await SupabaseServices.init();

  Bloc.observer = const AppBlocObserver();

  runApp(const EduApp());
}

class EduApp extends StatefulWidget {
  const EduApp({super.key});

  @override
  State<EduApp> createState() => _EduAppState();
}

class _EduAppState extends State<EduApp> {
  late final AuthStateListener _authStateListener;

  @override
  void initState() {
    super.initState();
    _authStateListener = AuthStateListener(navigatorKey: navigatorKey)
      ..startListening();
  }

  @override
  void dispose() {
    _authStateListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale("ar"),

      supportedLocales: const [
        Locale('ar'),  
        Locale('en'),  
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: 'EduCenter',
      navigatorKey: navigatorKey,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,

      home: const AuthGate(),
      onGenerateRoute: const AppRouter().generateRoute,
    );
  }
}
