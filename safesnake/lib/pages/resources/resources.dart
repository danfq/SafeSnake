import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/util/services/resources/handler.dart';
import 'package:safesnake/util/services/strings/handler.dart';
import 'package:safesnake/util/widgets/main.dart';
import 'package:settings_ui/settings_ui.dart';

class ResourcesHub extends StatelessWidget {
  const ResourcesHub({super.key});

  @override
  Widget build(BuildContext context) {
    //Current Lang
    final currentLang = Strings.currentLang;

    //UI
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: Text(Strings.pageTitles["resources_hub"][currentLang]),
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
            //Suicide
            SettingsSection(
              title: Text(Strings.resources["section_suicide"][currentLang]),
              tiles: [
                //Suicide Prevention Hotline
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_alert_circle_outline),
                  title: Text(
                    Strings.resources["suicide_hotline"][currentLang],
                  ),
                  onPressed: (context) async {
                    //Start Call
                    await ResourcesHandler.call(number: "+351218540740");
                  },
                ),
              ],
            ),

            //Talk
            SettingsSection(
              title: Text(Strings.resources["section_talk"][currentLang]),
              tiles: [
                //Suicide Prevention Hotline
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_people_outline),
                  title: Text(Strings.resources["sos_talk"][currentLang]),
                  onPressed: (context) async {
                    //Start Call
                    await ResourcesHandler.call(number: "+351213544545");
                  },
                ),
              ],
            ),

            //Health
            SettingsSection(
              title: Text(Strings.resources["section_health"][currentLang]),
              tiles: [
                //General Health Line
                SettingsTile.navigation(
                  leading: const Icon(Fontisto.heartbeat_alt),
                  title: Text(Strings.resources["health_general"][currentLang]),
                  onPressed: (context) async {
                    //Start Call
                    await ResourcesHandler.call(number: "112");
                  },
                ),

                //24 Hour Health Line
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_time_outline),
                  title: Text(Strings.resources["health_24"][currentLang]),
                  onPressed: (context) async {
                    //Start Call
                    await ResourcesHandler.call(number: "+351808242424");
                  },
                ),
              ],
            ),

            //Children
            SettingsSection(
              title: Text(Strings.resources["section_child"][currentLang]),
              tiles: [
                //General Health Line
                SettingsTile.navigation(
                  leading: const Icon(MaterialIcons.child_care),
                  title: Text(Strings.resources["child_missing"][currentLang]),
                  onPressed: (context) async {
                    //Start Call
                    await ResourcesHandler.call(number: "116000");
                  },
                ),

                //24 Hour Health Line
                SettingsTile.navigation(
                  leading: const Icon(
                    MaterialCommunityIcons.account_child_outline,
                  ),
                  title: Text(Strings.resources["child_support"][currentLang]),
                  onPressed: (context) async {
                    //Start Call
                    await ResourcesHandler.call(number: "116111");
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
