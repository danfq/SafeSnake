import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/notifications/local.dart';
import 'package:safesnake/util/widgets/dialogs.dart';
import 'package:safesnake/util/widgets/main.dart';
import 'package:settings_ui/settings_ui.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  ///Account Data
  Map<dynamic, dynamic> accountData = LocalData.boxData(box: "personal");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: const Text("Your Account"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            //Account Data
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                child: ListTile(
                  title: Text(
                    accountData["name"],
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(accountData["email"]),
                  trailing: IconButton(
                    onPressed: () async {
                      await AccountHandler(context).signOut();
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                    ),
                    icon: const Icon(
                      Ionicons.ios_log_out,
                      size: 22.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            //Referral Code
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                child: ListTile(
                  title: const Text(
                    "Your Referral Code",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(accountData["referral"]),
                  trailing: IconButton(
                    onPressed: () async {
                      //Copy to Clipboard
                      await Clipboard.setData(
                        ClipboardData(text: accountData["referral"]),
                      );

                      //Notify User
                      if (mounted) {
                        await LocalNotification(context: context).show(
                          type: NotificationType.success,
                          message: "Copied Your Referral Code",
                        );
                      }
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                    ),
                    icon: const Icon(
                      Ionicons.ios_copy,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            //Options
            Expanded(
              child: SettingsList(
                lightTheme: SettingsThemeData(
                  settingsListBackground:
                      Theme.of(context).scaffoldBackgroundColor,
                ),
                darkTheme: SettingsThemeData(
                  settingsListBackground:
                      Theme.of(context).scaffoldBackgroundColor,
                ),
                sections: [
                  SettingsSection(
                    tiles: [
                      //Change Username
                      SettingsTile.navigation(
                        leading: const Icon(Ionicons.ios_person_outline),
                        title: const Text("Change Username"),
                        description: const Text(
                          "Please don't be weird.",
                        ),
                        onPressed: (context) async {
                          //Change Dialog - Username
                          await UtilDialog(context: context)
                              .changeUserData(
                            type: DialogType.username,
                          )
                              .then((_) {
                            setState(() {
                              accountData = LocalData.boxData(box: "personal");
                            });
                          });
                        },
                      ),

                      //Change Password
                      SettingsTile.navigation(
                        leading: const Icon(Ionicons.ios_lock_closed_outline),
                        title: const Text("Change Password"),
                        description: const Text(
                          "It must meet our security standards.",
                        ),
                        onPressed: (context) async {
                          //Change Dialog - Password
                          await UtilDialog(context: context)
                              .changeUserData(type: DialogType.password)
                              .then((_) {
                            setState(() {
                              accountData = LocalData.boxData(box: "personal");
                            });
                          });
                        },
                      ),

                      //Delete Account
                      SettingsTile.navigation(
                        leading: const Icon(Ionicons.ios_trash_outline),
                        title: const Text("Delete Account"),
                        description: const Text(
                          "This will notify our Admins of your choice.\nIf you change your mind, you may contact us.\n\nOtherwise, all your Data will be deleted, including Help Logs.",
                        ),
                        onPressed: (context) async {
                          await AccountHandler(context).deleteAccount();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
