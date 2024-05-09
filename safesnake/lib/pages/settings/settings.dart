import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/settings/pages/account_info.dart';
import 'package:safesnake/pages/settings/pages/team/team.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/services/strings/handler.dart';
import 'package:safesnake/util/theming/controller.dart';
import 'package:safesnake/util/widgets/main.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //Accessibility
  bool ttsStatus = LocalData.boxData(box: "accessibility")["tts"] ?? false;

  //Extras
  bool colorfulMode = LocalData.boxData(box: "settings")["colorful"] ?? false;

  @override
  Widget build(BuildContext context) {
    //Current Theme
    final currentTheme = ThemeController.current(context: context);

    //Current Language
    String currentLang = Strings.currentLang;

    //UI
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: Text(Strings.pageTitles["settings"][currentLang]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () async {
                if (currentLang == "en") {
                  await Strings.setLang(lang: "pt");
                  setState(() {
                    currentLang = "pt";
                  });
                } else if (currentLang == "pt") {
                  await Strings.setLang(lang: "en");
                  setState(() {
                    currentLang = "en";
                  });
                }
              },
              child: Text(currentLang.toUpperCase()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SettingsList(
          lightTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          ),
          darkTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          ),
          physics: const BouncingScrollPhysics(),
          sections: [
            //UI
            SettingsSection(
              title: Text(Strings.settings["ui"][currentLang]),
              tiles: [
                //Theme
                SettingsTile.switchTile(
                  initialValue: currentTheme,
                  onToggle: (mode) => ThemeController.setAppearance(
                    context: context,
                    mode: mode,
                  ),
                  leading: !currentTheme
                      ? const Icon(Ionicons.ios_sunny)
                      : const Icon(Ionicons.ios_moon),
                  title: Text(Strings.settings["theme"][currentLang]),
                  description: Text(
                    currentTheme
                        ? Strings.settings["dark_mode"][currentLang]
                        : Strings.settings["light_mode"][currentLang],
                  ),
                ),
              ],
            ),

            //Account
            SettingsSection(
              title: Text(Strings.settings["account"][currentLang]),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_person),
                  title: Text(Strings.settings["account_info"][currentLang]),
                  description: Text(
                    Strings.settings["change_acc_info"][currentLang],
                  ),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const AccountInfo(),
                      ),
                    );
                  },
                ),
              ],
            ),

            //Accessibility
            SettingsSection(
              title: Text(Strings.settings["accessibility"][currentLang]),
              tiles: [
                SettingsTile.switchTile(
                  initialValue: ttsStatus,
                  onToggle: (mode) {
                    //Update UI
                    setState(() {
                      ttsStatus = mode;
                    });

                    //Update Data
                    LocalData.updateValue(
                      box: "accessibility",
                      item: "tts",
                      value: ttsStatus,
                    );
                  },
                  leading: const Icon(MaterialCommunityIcons.text_to_speech),
                  title: Text(Strings.settings["tts"][currentLang]),
                  description: Text(
                    Strings.settings["tts_info"][currentLang],
                  ),
                )
              ],
            ),

            //Extras
            SettingsSection(
              title: const Text("Extras"),
              tiles: [
                SettingsTile.switchTile(
                  initialValue: colorfulMode,
                  onToggle: (mode) {
                    //Update UI
                    setState(() {
                      colorfulMode = mode;
                    });

                    //Update Data
                    LocalData.updateValue(
                      box: "settings",
                      item: "colorful",
                      value: colorfulMode,
                    );
                  },
                  leading: const Icon(Ionicons.ios_brush),
                  title: Text(Strings.settings["color_mode"][currentLang]),
                  description: Text(
                    Strings.settings["color_mode_info"][currentLang],
                  ),
                )
              ],
            ),

            //Team & Licenses
            SettingsSection(
              title: Text(Strings.settings["team_and_licenses"][currentLang]),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_people),
                  title: Text(Strings.settings["team"][currentLang]),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => const Team()),
                    );
                  },
                ),
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_document),
                  title: Text(Strings.settings["licenses"][currentLang]),
                  onPressed: (context) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => LicensePage(
                          applicationName: "SafeSnake",
                          applicationIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14.0),
                              child: Image.asset(
                                "assets/logo.png",
                                height: 80.0,
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
