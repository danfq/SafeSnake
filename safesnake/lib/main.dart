import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:safesnake/util/services/main.dart';
import 'package:safesnake/util/theming/themes.dart';
import 'package:tbib_splash_screen/splash_screen_view.dart';

void main() async {
  //Initialize Services
  await MainServices.init();

  //Initial Route
  final initialRoute = await MainServices.initialRoute();

  //Run App
  runApp(
    AdaptiveTheme(
      light: Themes.light,
      dark: Themes.dark,
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) {
        return GetMaterialApp(
          theme: light,
          darkTheme: dark,
          debugShowCheckedModeBanner: false,
          home: SplashScreenView(
            navigateWhere: true,
            imageSrc: "assets/anim/corn.json",
            navigateRoute: initialRoute,
            duration: const Duration(seconds: 4),
            backgroundColor: const Color(0xFF161B22),
          ),
        );
      },
    ),
  );
}
