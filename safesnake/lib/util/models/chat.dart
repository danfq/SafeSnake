import 'package:flutter/material.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/data/remote.dart';

class Chat extends StatelessWidget {
  final String id;
  final String personOne;
  final String personTwo;
  final String latestMessage;
  final int latestMessageTimestamp;

  const Chat({
    super.key,
    required this.id,
    required this.personOne,
    required this.personTwo,
    required this.latestMessage,
    required this.latestMessageTimestamp,
  });

  ///`Chat` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "person_one": personOne,
      "person_two": personTwo,
      "latest_message": latestMessage,
      "latest_message_timestamp": latestMessageTimestamp,
    };
  }

  ///JSON Object to `Chat`
  factory Chat.fromJSON(Map<String, dynamic> json) {
    return Chat(
      id: json["id"],
      personOne: json["person_one"],
      personTwo: json["person_two"],
      latestMessage: json["latest_message"],
      latestMessageTimestamp: json["latest_message_timestamp"],
    );
  }

  //UI
  @override
  Widget build(BuildContext context) {
    //Current User
    final currentUser = (LocalData.boxData(box: "personal")["id"] as String)
        .split("-")
        .first
        .toUpperCase();

    //User ID
    String personID() {
      if (personOne == currentUser) {
        return personTwo;
      } else {
        return personOne;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder(
        future: AccountHandler(context).userByID(id: personID()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //User Data
            final userData = snapshot.data;

            //Check Data
            if (userData != null) {
              //UI
              return ListTile(
                title: Text(
                  userData["name"],
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: FutureBuilder(
                  future: RemoteData(context)
                      .instance
                      .from("decrypted_messages")
                      .select()
                      .eq("chat", id),
                  builder: (context, snapshot) {
                    //Check Connection State
                    if (snapshot.connectionState == ConnectionState.done) {
                      //Content
                      final message = snapshot.data;

                      //Check Latest Message Content
                      if (message.isNotEmpty) {
                        //Data
                        final messageData = message.last;

                        return Text(
                          latestMessage.isNotEmpty
                              ? (messageData["sender"] as String)
                                          .split("-")
                                          .first
                                          .toUpperCase() ==
                                      currentUser
                                  ? "You: ${messageData["decrypted_content"]}"
                                  : messageData["decrypted_content"]
                              : "No Messages",
                          style: TextStyle(
                            fontSize: 12.0,
                            fontStyle: (messageData["sender"] as String)
                                        .split("-")
                                        .first
                                        .toUpperCase() ==
                                    currentUser
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
              );
            } else {
              return const Text("Error Loading User Information");
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
