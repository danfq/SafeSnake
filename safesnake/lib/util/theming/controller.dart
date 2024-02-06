import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/theming/themes.dart';

///Theme Controller
class ThemeController {
  ///Current Theme
  static bool current({required BuildContext context}) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  ///Set Orange Mode
  static void setOrangeMode({
    required BuildContext context,
    required bool mode,
  }) {
    //Activate or Deactivate
    _orangeMode(context: context, mode: mode);
  }

  ///Activate or Deactivate Orange Mode
  static void _orangeMode({required BuildContext context, required bool mode}) {
    //Themes
    final orangeThemeLight = Themes.orangeModeLight;
    final orangeThemeDark = Themes.orangeModeDark;

    //Switch On or Off
    switch (mode) {
      case true:
        AdaptiveTheme.of(context)
            .setTheme(light: orangeThemeLight, dark: orangeThemeDark);

      case false:
        AdaptiveTheme.of(context)
            .setTheme(light: Themes.light, dark: Themes.dark);
    }
  }

  ///Easy Toggle
  static void easyToggle({
    required BuildContext context,
    required bool mode,
  }) {
    AdaptiveTheme.of(context).setThemeMode(
      mode ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light,
    );
  }

  ///Set Appearance Mode
  static void setAppearance({
    required BuildContext context,
    required bool mode,
  }) {
    //Set Appearance
    mode ? _setDark(context: context) : _setLight(context: context);

    //Status Bar & Navigation Bar
    statusAndNav(context: context);

    //Settings
    final settings = LocalData.boxData(box: "settings");

    //Add Theme to Settings
    settings.addAll({"theme": mode});

    //Save Theme Locally
    LocalData.setData(
      box: "settings",
      data: settings,
    );
  }

  ///Set Dark Mode
  static void _setDark({
    required BuildContext context,
  }) {
    AdaptiveTheme.of(context).setDark();
  }

  ///Set Light Mode
  static void _setLight({
    required BuildContext context,
  }) {
    AdaptiveTheme.of(context).setLight();
  }

  //Status Bar & Navigation Bar
  static void statusAndNav({required BuildContext context}) {
    //Current Theme
    final currentTheme = current(context: context);

    if (currentTheme) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFFFAFAFA),
          statusBarColor: Color(0xFFFFFEFD),
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0xFF161B22),
          statusBarColor: Color(0xFF131313),
        ),
      );
    }
  }
}
