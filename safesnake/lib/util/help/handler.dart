import 'package:flutter/material.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/chat/handler.dart';
import 'package:safesnake/util/models/loved_one.dart';
import 'package:safesnake/util/models/message.dart';
import 'package:safesnake/util/notifications/local.dart';
import 'package:uuid/uuid.dart';

///Help Handler
class HelpHandler {
  ///Show Help Bottom Sheet
  static Future<void> showHelpSheet({
    required BuildContext context,
    required String helpContent,
  }) async {
    //Loved Ones
    final lovedOnes = await AccountHandler(context).lovedOnes();

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
                        child: const Text("Notify All"),
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
                                    message: "Notified ${lovedOne.name}",
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
                    : const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: Text(
                            "You don't have any Loved Ones.",
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
    //Current User
    final currentUser = AccountHandler(context).currentUser;
    final userName = currentUser!.userMetadata!["username"];

    //Loved One
    final lovedOneData = await AccountHandler(context).userByName(
      name: lovedOne.name.trim(),
    );

    //Chat
    if (context.mounted) {
      //User ID
      final userID = currentUser.id.substring(0, 8).toUpperCase();

      //Loved One ID
      final lovedOneID =
          (lovedOneData["id"] as String).substring(0, 8).toUpperCase();

      final chat = await ChatHandler(context).newChatByID(
        userID: userID,
        lovedOneID: lovedOneID,
      );

      //Chat ID
      final chatID = chat?.id;

      //Send Message to Loved One
      if (context.mounted) {
        await ChatHandler(context).sendMessage(
          message: Message(
            id: const Uuid().v4(),
            chatID: chatID!,
            content: content,
            sentAt: DateTime.now().millisecondsSinceEpoch,
            sender: currentUser.id,
          ),
          receiverFCM: lovedOneData["fcm"],
        );
      }
    }

    //Notify Loved One
    if (context.mounted) {
      await ChatHandler.sendNotification(
        context: context,
        fcmToken: lovedOneData["fcm"],
        title: "$userName needs your help!",
        body: content,
      );
    }
  }
}
