import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/chat/handler.dart';
import 'package:safesnake/util/models/chat.dart';
import 'package:safesnake/util/models/message.dart';
import 'package:safesnake/util/widgets/main.dart';
import 'package:uuid/uuid.dart';

class LovedOneChat extends StatefulWidget {
  const LovedOneChat({
    super.key,
    required this.lovedOne,
    required this.chat,
  });

  ///Loved One
  final Map<String, dynamic> lovedOne;

  ///Chat Data
  final ChatData chat;

  @override
  State<LovedOneChat> createState() => _LovedOneChatState();
}

class _LovedOneChatState extends State<LovedOneChat> {
  ///Chat Input Controller
  TextEditingController chatInputController = TextEditingController();

  ///Messages
  List<types.Message> _messages = [];

  ///Add Message
  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  ///On Message Sent
  Future<void> _onMessageSent({
    required String currentUser,
    required types.PartialText message,
  }) async {
    final textMessage = types.TextMessage(
      author: types.User(id: currentUser),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    //Add to UI
    _addMessage(textMessage);

    //Send Message
    ChatHandler(context).sendMessage(
      message: MessageData(
        id: const Uuid().v4(),
        chatID: widget.chat.id,
        content: message.text,
        sentAt: DateTime.now().millisecondsSinceEpoch,
        sender: currentUser,
      ),
      receiverFCM: widget.lovedOne["fcm"],
    );
  }

  @override
  Widget build(BuildContext context) {
    ///Current User
    final String currentUser = AccountHandler(context).currentUser!.id;

    //UI
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MainWidgets(context: context).appBar(
        title: Text(widget.lovedOne["name"]),
        actions: [
          //Information
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {
                //Loved One
                final lovedOne = widget.lovedOne;

                //Clean ID
                final id =
                    (lovedOne["id"] as String).split("-").first.toUpperCase();

                //Show Information
                await showAdaptiveDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        lovedOne["name"],
                        textAlign: TextAlign.center,
                      ),
                      content: Text("ID: $id", textAlign: TextAlign.center),
                    );
                  },
                );
              },
              icon: const Icon(Ionicons.ios_information_circle),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: ChatHandler(context).chatMessages(
            chatID: widget.chat.id,
            onNewMessages: (newMessages) {
              setState(() {
                _messages = [..._messages, ...newMessages];
              });
            },
          ),
          builder: (context, snapshot) {
            //Check Connection
            if (snapshot.connectionState == ConnectionState.active) {
              //Messages
              final messages = snapshot.data;

              return messages != null
                  ? Chat(
                      messages: messages,
                      onSendPressed: (message) async {
                        await _onMessageSent(
                          currentUser: currentUser,
                          message: message,
                        );
                      },
                      user: types.User(id: currentUser),
                      theme: DefaultChatTheme(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        primaryColor: Theme.of(context).colorScheme.secondary,
                        secondaryColor: Colors.grey.shade300,
                        inputBackgroundColor: Theme.of(context)
                            .dialogBackgroundColor
                            .withOpacity(0.8),
                        inputTextColor:
                            Theme.of(context).textTheme.bodyMedium!.color!,
                      ),
                    )
                  : const Center(child: Text("Error Fetching Messages"));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
