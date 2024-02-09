import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:safesnake/pages/chat/chat.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/animations/handler.dart';
import 'package:safesnake/util/chat/handler.dart';

class LovedOnes extends StatefulWidget {
  const LovedOnes({super.key});

  @override
  State<LovedOnes> createState() => _LovedOnesState();
}

class _LovedOnesState extends State<LovedOnes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AccountHandler(context).lovedOnes(),
      builder: (context, snapshot) {
        //Loved Ones
        final lovedOnes = snapshot.data;

        //Connection State
        if (snapshot.connectionState == ConnectionState.done) {
          //Check Loved Ones
          if (lovedOnes != null && lovedOnes.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: lovedOnes.length,
                itemBuilder: (context, index) {
                  //Loved One
                  final lovedOne = lovedOnes[index];

                  //UI
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListTile(
                      onTap: () async {
                        //User ID
                        final userID = AccountHandler(context)
                            .currentUser!
                            .id
                            .toUpperCase()
                            .substring(0, 8);

                        //Loved One Sub-ID
                        final lovedOneSubID = (lovedOne["id"] as String)
                            .toUpperCase()
                            .substring(0, 8);

                        //Chat Data
                        final chat = await ChatHandler(context).newChatByID(
                          userID: userID,
                          lovedOneID: lovedOneSubID,
                        );

                        //Go to Loved One Chat
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => LovedOneChat(
                                lovedOne: lovedOne,
                                chat: chat!,
                              ),
                            ),
                          );
                        }
                      },
                      tileColor: Theme.of(context).dialogBackgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      title: Text(
                        lovedOne["name"],
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      trailing: const Icon(Ionicons.ios_chatbox),
                    ),
                  );
                },
              ),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: AnimationsHandler.asset(
                    animation: "empty",
                    reverse: true,
                  ),
                ),
                const Text("Looks like Tsuki needs to play by herself :("),
              ],
            );
          }
        } else {
          return Center(
            child: AnimationsHandler.asset(animation: "loading"),
          );
        }
      },
    );
  }
}
