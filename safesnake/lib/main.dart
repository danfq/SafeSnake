import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:safesnake/pages/account/account.dart';
import 'package:safesnake/pages/intro/intro.dart';
import 'package:safesnake/pages/safesnake.dart';
import 'package:safesnake/util/animations/handler.dart';
import 'package:safesnake/util/data/env.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/theming/themes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  //Ensure Widgets Binding is Initialized
  WidgetsFlutterBinding.ensureInitialized();

  //Load Environment Variables
  await EnvVars.load();

  //Initialize Supabase
  await Supabase.initialize(
    url: EnvVars.get(name: "SUPABASE_URL"),
    anonKey: EnvVars.get(name: "SUPABASE_KEY"),
  );

  //Initialize Local Storage
  await LocalData.init();

  //Intro Status
  final introStatus = LocalData.boxData(box: "intro")["status"] ?? false;

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
          home: FlutterSplashScreen.fadeIn(
            childWidget: AnimationsHandler.asset(animation: "corn"),
            useImmersiveMode: true,
            duration: const Duration(seconds: 4),
            animationCurve: Curves.easeInOut,
            backgroundColor: Colors.white,
            nextScreen: introStatus
                ? currentUser != null
                    ? SafeSnake(user: currentUser)
                    : const Account()
                : const Intro(),
          ),
        );
      },
    ),
  );
}
