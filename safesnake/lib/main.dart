import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safesnake/firebase_options.dart';
import 'package:safesnake/pages/account/account.dart';
import 'package:safesnake/pages/intro/intro.dart';
import 'package:safesnake/pages/safesnake.dart';
import 'package:safesnake/util/data/env.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/notifications/remote.dart';
import 'package:safesnake/util/theming/themes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

void main() async {
  //Ensure Widgets Binding is Initialized
  WidgetsFlutterBinding.ensureInitialized();

  //Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Load Environment Variables
  await EnvVars.load();

  //Initialize Supabase
  await Supabase.initialize(
    url: EnvVars.get(name: "SUPABASE_URL"),
    anonKey: EnvVars.get(name: "SUPABASE_KEY"),
  );

  //Initialize Local Storage
  await LocalData.init();

  //Initialize Notification Service
  await RemoteNotifications.init();

  //Intro Status
  final introStatus = LocalData.boxData(box: "intro")["status"] ?? false;

  //Current Theme
  final currentTheme = LocalData.boxData(box: "settings")["theme"] ?? false;

  //Signed In User
  final currentUser = Supabase.instance.client.auth.currentUser;

  //Run App
  runApp(
    AdaptiveTheme(
      light: Themes.light(),
      dark: Themes.dark(),
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) {
        return MaterialApp(
          theme: light,
          darkTheme: dark,
          home: SplashScreenView(
            navigateWhere: true,
            imageSrc: "assets/anim/corn.json",
            navigateRoute: introStatus
                ? currentUser != null
                    ? SafeSnake(user: currentUser)
                    : const Account()
                : const Intro(),
            duration: const Duration(seconds: 4),
            backgroundColor: !currentTheme
                ? const Color(0xFFFAFAFA)
                : const Color(0xFF161B22),
          ),
        );
      },
    ),
  );
}
