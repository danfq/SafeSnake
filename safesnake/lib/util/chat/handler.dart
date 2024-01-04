import 'dart:convert';

import 'package:safesnake/util/data/constants.dart';
import 'package:safesnake/util/data/remote.dart';
import 'package:safesnake/util/models/chat.dart';
import 'package:safesnake/util/models/message.dart';
import 'package:flutter/material.dart';
import 'package:safesnake/util/notifications/local.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

///Chat Handler
class ChatHandler {
  ///Context
  BuildContext context;

  ///Chat Handler
  ChatHandler(this.context);

  ///All Chats - by `userID`
  static Stream<List<Chat>> allChatsByID({
    required String userID,
  }) {
    return RemoteData.instance.from("chats").stream(primaryKey: ["id"]).map(
      (chats) {
        //All Chats
        List<Chat> allChats = [];

        //Parse Chats
        for (final chatData in chats) {
          //Chat
          final chat = Chat(
            id: chatData["id"],
            personOne: chatData["person_one"],
            personTwo: chatData["person_two"],
            latestMessage: chatData["latest_message"],
            latestMessageTimestamp: chatData["latest_message_timestamp"],
          );

          //Check if User Owns Chat
          if (chat.personOne == userID || chat.personTwo == userID) {
            //Update Chats
            allChats.add(chat);
          }
        }

        return allChats;
      },
    );
  }

  ///Start New Chat by `userID`
  Future<Chat?> newChatByID({
    required String userID,
    required String lovedOneID,
  }) async {
    //Chat
    Chat? chatData;

    //Check if Such Chat Already Exists
    final userChats = await RemoteData.instance
        .from("chats")
        .select()
        .or("person_one.eq.$userID,person_two.eq.$userID")
        .order("latest_message_timestamp", ascending: false);

    //Check if Chat Exists
    if (userChats.isEmpty) {
      //Chat Doesn't Exist - Create New
      final newChatID = const Uuid().v4();

      final chat = Chat(
        id: newChatID,
        personOne: userID,
        personTwo: lovedOneID,
        latestMessage: "",
        latestMessageTimestamp: 0,
      );

      if (context.mounted) {
        await RemoteData.instance
            .from("chats")
            .insert(chat.toJSON())
            .select()
            .then((_) => chatData = chat);
      }

      //Set Chat Data
      chatData = chat;
    } else {
      //Set Chat Data
      chatData = Chat.fromJSON(userChats.first);

      //Chat Exists - Return Chat
      return chatData;
    }

    //Return Chat ID (or Null)
    return chatData;
  }

  ///Message Data - by `id`
  static Future<Message?> messageByID({required String id}) async {
    //Message
    Message? message;

    //Get Message Data from ID
    final messageData = await RemoteData.instance
        .from("decrypted_messages")
        .select()
        .eq("id", id);

    //Check if Message Exists
    if (messageData.isNotEmpty) {
      message = Message.fromJSON(messageData.first);
    }

    //Return Message
    return message;
  }

  ///Chat Messages Stream - by `chatID`
  static Stream<List<Message>> chatMessages({
    required String chatID,
    required Function(List<Message> messages) onNewMessages,
  }) {
    //All Messages
    List<Message> allMessages = [];

    //Chat Messages
    return RemoteData.instance
        .from("decrypted_messages")
        .stream(primaryKey: ["id"])
        .eq("chat", chatID)
        .order("sent_at", ascending: false)
        .map((messages) {
          //Parse Messages
          for (final messageItem in messages) {
            //Message
            final message = Message(
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
  Future<Message?> sendMessage({
    required Message message,
    required String receiverFCM,
  }) async {
    //Add Message to Database
    final addedMessage =
        await RemoteData.instance.from("decrypted_messages").insert(
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
      await RemoteData.instance.from("chats").update(
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

    //Request
    final http.Response response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "key=$serverKey",
      },
      body: jsonEncode(message),
    );

    if (context.mounted) {
      if (response.statusCode == 200) {
        if (!(isNormalMessage ?? false)) {
          await LocalNotification(context: context).show(
            type: NotificationType.success,
            message: "Notified Loved One",
          );
        }
      } else {
        if (!(isNormalMessage ?? false)) {
          await LocalNotification(context: context).show(
            type: NotificationType.failure,
            message: "Failed to Notify Loved One",
          );
        }
      }
    }
  }

  ///Delete Message by ID
  static Future<void> deleteMessage({required String id}) async {
    await RemoteData.instance.from("messages").delete().eq("id", id);
  }
}
