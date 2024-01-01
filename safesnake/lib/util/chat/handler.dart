import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/data/remote.dart';
import 'package:safesnake/util/models/chat.dart';
import 'package:safesnake/util/models/message.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

///Chat Handler
class ChatHandler {
  ///Context
  BuildContext context;

  ///Chat Handler
  ChatHandler(this.context);

  ///All Chats - by `userID`
  Stream<List<Chat>> allChatsByID({
    required String userID,
  }) {
    return RemoteData(context)
        .instance
        .from("chats")
        .stream(primaryKey: ["id"]).map(
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
  Future<Chat?> newChatByID({required String userID}) async {
    //Chat
    Chat? chatData;

    //Users
    final users = RemoteData(context)
        .instance
        .from("decrypted_users")
        .select()
        .ilike("id", "%$userID%");

    //Check if Such Chat Already Exists
    final userChats = RemoteData(context)
        .instance
        .from("chats")
        .select()
        .eq("person_one", userID)
        .or("person_two.eq.$userID")
        .order("latest_message_timestamp", ascending: false);

    //Check if User Exists
    if ((await users).isNotEmpty && (await users).length == 1) {
      //User Exists
      if ((await userChats).isEmpty) {
        //Chat Doesn't Exist - Create New
        final newChatID = const Uuid().v4();

        //Current User
        final currentUser = LocalData.boxData(box: "user");

        final chat = Chat(
          id: newChatID,
          personOne: currentUser["id"].split("-").first.toUpperCase(),
          personTwo: userID,
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
      } else {
        //Chat Exists - Return Null
        return null;
      }
    } else {
      //User Doesn't Exist
      return null;
    }

    //Return Chat ID (or Null)
    return chatData;
  }

  ///Message Data - by `id`
  Future<Message?> messageByID({required String id}) async {
    //Message
    Message? message;

    //Get Message Data from ID
    final messageData = await RemoteData(context)
        .instance
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
  Stream<List<Message>> chatMessages({
    required String chatID,
    required Function(List<Message> messages) onNewMessages,
  }) {
    //All Messages
    List<Message> allMessages = [];

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
            final message = Message(
              id: messageItem["id"],
              chatID: chatID,
              content: messageItem["decrypted_content"],
              sentAt: messageItem["sent_at"],
              deliveredAt: messageItem["delivered_at"],
              read: messageItem["read"],
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
  }) async {
    //Add Message to Database
    final addedMessage =
        await RemoteData(context).instance.from("decrypted_messages").insert(
      {
        "id": message.id,
        "chat": message.chatID,
        "content": message.content,
        "sent_at": message.sentAt,
        "delivered_at": message.deliveredAt,
        "read": message.read,
        "sender": message.sender,
        "reply_to": message.replyTo,
      },
    ).select();

    //Update Latest Chat Message
    if (context.mounted) {
      await RemoteData(context).instance.from("chats").update(
        {
          "latest_message": message.id,
          "latest_message_timestamp": message.sentAt,
        },
      ).eq("id", message.chatID);
    }

    return addedMessage.isNotEmpty ? message : null;
  }

  ///Delete Message by ID
  Future<void> deleteMessage({required String id}) async {
    await RemoteData(context).instance.from("messages").delete().eq("id", id);
  }
}
