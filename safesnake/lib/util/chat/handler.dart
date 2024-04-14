import 'dart:convert';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/data/constants.dart';
import 'package:safesnake/util/data/remote.dart';
import 'package:safesnake/util/models/chat.dart';
import 'package:safesnake/util/models/message.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

///Chat Handler
class ChatHandler {
  ///Context
  BuildContext context;

  ///Chat Handler
  ChatHandler(this.context);

  ///Chat Data by `userID` & `lovedOneID`.
  ///Creates New Chat if None Found
  Future<ChatData?> chatByID({
    required String userID,
    required String lovedOneID,
  }) async {
    //Chat
    ChatData? chatData;

    //Check if Such Chat Already Exists
    final List userChats = await RemoteData(context)
        .instance
        .from("chats")
        .select()
        .or("person_one.eq.$userID,person_two.eq.$userID")
        .order("latest_message_timestamp", ascending: false);

    //Check if Chat Exists
    if (userChats.isEmpty) {
      //Chat Doesn't Exist - Create New
      final newChatID = const Uuid().v4();

      final chat = ChatData(
        id: newChatID,
        personOne: userID,
        personTwo: lovedOneID,
        latestMessage: "",
        latestMessageTimestamp: 0,
      );

      if (context.mounted) {
        await RemoteData(context)
            .instance
            .from("chats")
            .insert(chat.toJSON())
            .select()
            .then((_) => chatData = chat);
      }

      //Set Chat Data
      chatData = chat;
    } else {
      //Set Chat Data
      chatData = ChatData.fromJSON(
        userChats.firstWhere(
          (chat) {
            return chat["person_one"] == userID &&
                    chat["person_two"] == lovedOneID ||
                chat["person_one"] == lovedOneID &&
                    chat["person_two"] == userID;
          },
        ),
      );

      //Chat Exists - Return Chat
      return chatData;
    }

    //Return Chat ID (or Null)
    return chatData;
  }

  ///Message Data - by `id`
  Future<MessageData?> messageByID({
    required String id,
  }) async {
    //Message
    MessageData? message;

    //Get Message Data from ID
    final messageData = await RemoteData(context)
        .instance
        .from("decrypted_messages")
        .select()
        .eq("id", id);

    //Check if Message Exists
    if (messageData.isNotEmpty) {
      message = MessageData.fromJSON(messageData.first);
    }

    //Return Message
    return message;
  }

  ///Chat Messages Stream - by `chatID`
  Stream<List<MessageData>> chatMessages({
    required String chatID,
    required Function(List<MessageData> messages) onNewMessages,
  }) {
    //All Messages
    List<MessageData> allMessages = [];

    //Chat Messages
    return RemoteData(context)
        .instance
        .from("decrypted_messages")
        .stream(primaryKey: ["id"])
        .eq("chat", chatID)
        .order("sent_at", ascending: false)
        .map((messages) {
          //Parse Messages
          for (final messageItem in messages) {
            //Message
            final message = MessageData(
              id: messageItem["id"],
              chatID: chatID,
              content: messageItem["decrypted_content"],
              sentAt: messageItem["sent_at"],
              sender: messageItem["sender"],
              replyTo: messageItem["reply_to"],
            );

            //Update Messages
            allMessages.add(message);
          }

          //Update Stream
          onNewMessages(allMessages);

          //Return Chats Stream
          return allMessages;
        });
  }

  ///Send `message`
  Future<MessageData?> sendMessage({required MessageData message}) async {
    //Add Message to Database
    final addedMessage =
        await RemoteData(context).instance.from("decrypted_messages").insert(
      {
        "id": message.id,
        "chat": message.chatID,
        "content": message.content,
        "sent_at": message.sentAt,
        "sender": message.sender,
        "reply_to": message.replyTo,
      },
    ).select();

    if (context.mounted) {
      //Update Latest Chat Message
      await RemoteData(context).instance.from("chats").update(
        {
          "latest_message": message.id,
          "latest_message_timestamp": message.sentAt,
        },
      ).eq("id", message.chatID);
    }

    return addedMessage.isNotEmpty ? message : null;
  }

  ///Send Notification to FCM Token
  static Future<void> sendNotification({
    required BuildContext context,
    required String fcmToken,
    required String title,
    required String body,
    bool? isNormalMessage,
  }) async {
    const String serverKey = Constants.firebaseServerKey;
    const String fcmEndpoint = "https://fcm.googleapis.com/fcm/send";

    final Map<String, dynamic> message = {
      "to": fcmToken,
      "data": {
        "title": title,
        "body": body,
      },
      "notification": {
        "title": title,
        "body": body,
      },
    };

    //Send Notification
    await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "key=$serverKey",
      },
      body: jsonEncode(message),
    );
  }

  ///Delete Message by ID
  Future<void> deleteMessage({required String id}) async {
    await RemoteData(context).instance.from("messages").delete().eq("id", id);
  }
}
