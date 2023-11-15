import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/settings/pages/account_info.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/widgets/main.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //Account Data
  bool receiveInvites = LocalData.boxData(box: "settings")["invites"] ?? false;

  @override
  Widget build(BuildContext context) {
    //UI
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        onBack: () async {
          //Save Data
          await LocalData.setData(
            box: "settings",
            data: {
              "invites": receiveInvites,
            },
          );

          //Go Back
          if (mounted) {
            Navigator.pop(context);
          }
        },
        title: const Text("Settings"),
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
              title: const Text("UI & Visuals"),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_text_outline),
                  title: const Text("Font"),
                  onPressed: (context) {},
                ),
              ],
            ),

            //Account
            SettingsSection(
              title: const Text("My Account"),
              tiles: [
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.ios_person),
                  title: const Text("Information"),
                  description: const Text(
                    "See and change all your Account Information.",
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
                SettingsTile.switchTile(
                  leading: SvgPicture.asset(
                    "assets/icons/people.svg",
                    fit: BoxFit.cover,
                    width: 24.0,
                    color: Colors.grey,
                  ),
                  initialValue: receiveInvites,
                  onToggle: (mode) {
                    setState(() {
                      receiveInvites = mode;
                    });
                  },
                  title: const Text("Loved One Invites"),
                  description: const Text(
                    "Whether you'd like to receive Loved One invites.",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
