import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/chat/handler.dart';
import 'package:safesnake/util/data/remote.dart';
import 'package:safesnake/util/models/help_item.dart';
import 'package:safesnake/util/models/loved_one.dart';
import 'package:safesnake/util/models/message.dart';
import 'package:safesnake/util/services/notifications/local.dart';
import 'package:safesnake/util/services/strings/handler.dart';
import 'package:uuid/uuid.dart';

///Help Handler
class HelpHandler {
  ///Get All Help Items
  static Future<List<HelpItem>> getItems() async {
    //Items
    List<HelpItem> items = [];

    //All Items
    final allItems = await RemoteData(Get.context!).getData(
      table: "help_items",
    );

    //Parse Items
    for (final item in allItems) {
      //Help Item
      final helpItem = HelpItem.fromJSON(item);

      //Add Item to List
      items.add(helpItem);
    }

    //Return Items
    return items;
  }

  ///High-Alert Warning
  static Future<void> highAlertWarning({
    required String name,
    required String userName,
    required String userFCM,
  }) async {
    //Current Lang
    final currentLang = Strings.currentLang;

    //Send Notification
    await ChatHandler.sendNotification(
      context: Get.context!,
      fcmToken: userFCM,
      title: Strings.help["notif_title"][currentLang],
      body: "$name ${Strings.help["notif_body"][currentLang]}",
    ).then((_) {
      LocalNotifications.toast(message: "$userName notified!");
    });
  }

  ///High-Alert Notification
  static Future<void> highAlertNotif() async {
    //Player
    final player = AudioPlayer();

    //Asset & Volume
    await player.setAsset("assets/audio/alert.ogg");
    await player.setVolume(1.0);

    //Play
    await player.play();
  }

  ///Show Help Bottom Sheet
  static Future<void> showHelpSheet({
    required BuildContext context,
    required String helpContent,
  }) async {
    //Current Lang
    final currentLang = Strings.currentLang;

    //Loved Ones
    final lovedOnes = await AccountHandler.lovedOnes(context: context);

    //Parsed Loved Ones
    final parsedLovedOnes = lovedOnes
        .map(
          (lovedOne) => LovedOne.fromJSON(lovedOne),
        )
        .toList();

    //Show Help Menu
    if (context.mounted) {
      await showModalBottomSheet(
        context: context,
        showDragHandle: true,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.0),
                topRight: Radius.circular(14.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //Top
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    //Title
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Ask for Help",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),

                    //Notify All
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: TextButton(
                        onPressed: lovedOnes.isNotEmpty
                            ? () async {
                                //Notify All
                                for (final lovedOne in lovedOnes) {
                                  await _sendHelpRequest(
                                    context: context,
                                    lovedOne: LovedOne.fromJSON(lovedOne),
                                    content: helpContent,
                                  );
                                }

                                //Alert User
                                LocalNotifications.toast(
                                  message: "Notified All",
                                );

                                //Close Sheet
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).cardColor,
                        ),
                        child: Text(
                          Strings.lovedOnes["notify_all"][currentLang],
                        ),
                      ),
                    ),
                  ],
                ),

                //Spacing
                const SizedBox(height: 20.0),

                //Loved Ones
                parsedLovedOnes.isNotEmpty
                    ? ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 240.0,
                        ),
                        child: GridView.count(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(12.0),
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 10 / 3,
                          children: parsedLovedOnes.map(
                            (lovedOne) {
                              return GestureDetector(
                                onTap: () async {
                                  //Send to Loved One
                                  await _sendHelpRequest(
                                    context: context,
                                    lovedOne: lovedOne,
                                    content: helpContent,
                                  );

                                  //Alert User
                                  LocalNotifications.toast(
                                    message: Strings.lovedOnes["notified"]
                                        [currentLang],
                                  );

                                  //Close Sheet
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  child: Center(
                                    child: Text(
                                      lovedOne.name,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Center(
                          child: Text(
                            Strings.lovedOnes["no_loved_ones"][currentLang],
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                //Spacing
                const SizedBox(height: 40.0),
              ],
            ),
          );
        },
      );
    }
  }

  ///Send Help Request to Loved One
  static Future<void> _sendHelpRequest({
    required BuildContext context,
    required LovedOne lovedOne,
    required String content,
  }) async {
    //Current Lang
    final currentLang = Strings.currentLang;

    //Current User
    final currentUser = AccountHandler.currentUser;
    final userName = currentUser!.userMetadata!["username"];

    //Loved One
    final lovedOneData = await AccountHandler.userByName(
      name: lovedOne.name.trim(),
    );

    //Chat
    if (context.mounted) {
      //User ID
      final userID = currentUser.id.substring(0, 8).toUpperCase();

      //Loved One ID
      final lovedOneID =
          (lovedOneData["id"] as String).substring(0, 8).toUpperCase();

      final chat = await ChatHandler(context).chatByID(
        userID: userID,
        lovedOneID: lovedOneID,
      );

      //Chat ID
      final chatID = chat?.id;

      //Send Message to Loved One
      if (context.mounted) {
        await ChatHandler(context).sendMessage(
          message: MessageData(
            id: const Uuid().v4(),
            chatID: chatID!,
            content: content,
            sentAt: DateTime.now().millisecondsSinceEpoch,
            sender: currentUser.id,
          ),
        );
      }
    }

    //Notify Loved One
    if (context.mounted) {
      await ChatHandler.sendNotification(
        context: context,
        fcmToken: lovedOneData["fcm"],
        title: "$userName ${Strings.lovedOnes["notif_title_2"][currentLang]}",
        body: content,
      );
    }
  }
}
