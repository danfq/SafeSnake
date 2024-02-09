import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/chat/handler.dart';
import 'package:safesnake/util/models/chat.dart';
import 'package:safesnake/util/models/message.dart';
import 'package:safesnake/util/widgets/chat.dart';
import 'package:safesnake/util/widgets/input.dart';
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
  final Chat chat;

  @override
  State<LovedOneChat> createState() => _LovedOneChatState();
}

class _LovedOneChatState extends State<LovedOneChat> {
  ///Chat Input Controller
  TextEditingController chatInputController = TextEditingController();

  ///Chat Input Focus Node
  final FocusNode _chatInputFocusNode = FocusNode();

  ///Chat List Key
  final GlobalKey<AnimatedListState> _chatKey = GlobalKey<AnimatedListState>();

  ///Messages
  List<Message> messages = [];

  ///Message In Focus Status
  bool messageInFocusStatus = false;

  ///Message In Focus
  Widget? messageInFocus;

  ///Sending Message Status
  bool sendingMessage = false;

  ///Message Replying
  Message? messageReplying;

  ///Replied Messages Contents
  Map<String, String?> repliedMessageContents = {};

  ///Fetch Replied Message Content by `messageID`
  Future<void> fetchRepliedMessageContent(String messageID) async {
    final repliedMessage = await ChatHandler(context).messageByID(
      id: messageID,
    );
    setState(() {
      repliedMessageContents[messageID] = repliedMessage!.content;
    });
  }

  @override
  Widget build(BuildContext context) {
    ///Current User
    final String currentUser = AccountHandler(context).currentUser!.id;

    //Chat ID
    final String chatID = widget.chat.id;

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
        child: Column(
          children: [
            //Chat
            Expanded(
              child: StreamBuilder(
                stream: ChatHandler(context).chatMessages(
                  chatID: chatID,
                  onNewMessages: (newMessages) async {
                    if (mounted) {
                      setState(() {
                        messages = [...messages, ...newMessages];
                      });
                    }

                    //Get Replied Messages Content
                    for (final message in newMessages) {
                      if (message.replyTo != null &&
                          !repliedMessageContents.containsKey(
                            message.replyTo!,
                          )) {
                        await fetchRepliedMessageContent(message.replyTo!);
                      }
                    }
                  },
                ),
                builder: (context, snapshot) {
                  //No Data
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  //Chats
                  messages = snapshot.data!;

                  //Messages
                  return messages.isNotEmpty
                      ? ListView.builder(
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            //Message
                            final message = messages[index];

                            //Check Current User
                            final isCurrentUser = message.sender == currentUser;

                            //Check if Last in Group
                            bool isLastInGroup = true;
                            if (index > 0) {
                              final previousMessage = messages[index - 1];
                              isLastInGroup =
                                  previousMessage.sender != message.sender;
                            }

                            //Replied Message Content
                            final repliedMessageContent =
                                repliedMessageContents[message.replyTo ?? ""];

                            //Chat Bubble
                            final chatBubble = DefaultTextHeightBehavior(
                              textHeightBehavior: const TextHeightBehavior(),
                              child: ChatItem(
                                message: message,
                                isCurrentUser: isCurrentUser,
                                isLastInGroup: isLastInGroup,
                                keyboardFocusNode: _chatInputFocusNode,
                                onReply: (messageID) {
                                  setState(() {
                                    messageReplying = messageID;
                                  });
                                },
                                repliedContent: repliedMessageContent,
                              ),
                            );

                            //Display Chat Bubble
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: isLastInGroup ? 14.0 : 0.0,
                              ),
                              child: chatBubble,
                            );
                          },
                        )
                      : const Center(
                          child: Text("No Messages"),
                        );
                },
              ),
            ),

            //Chat Input
            Column(
              children: [
                //Replying Status
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: messageReplying != null ? 40.0 : 0.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(14.0),
                      topRight: Radius.circular(14.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      messageReplying?.content ?? "",
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),

                //Input
                Row(
                  children: [
                    //Input
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Input(
                          controller: chatInputController,
                          placeholder: "Write a message...",
                          backgroundColor:
                              Theme.of(context).dialogBackgroundColor,
                          onChanged: (content) => setState(() {}),
                        ),
                      ),
                    ),

                    //Send Message
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                        icon: const Icon(Ionicons.ios_send),
                        onPressed: chatInputController.text.trim().isNotEmpty
                            ? () async {
                                //Message Content
                                final messageContent =
                                    chatInputController.text.trim();

                                //Check Message Content
                                if (messageContent.isNotEmpty) {
                                  //Message
                                  final message = Message(
                                    id: const Uuid().v4(),
                                    chatID: widget.chat.id,
                                    content: messageContent,
                                    sentAt:
                                        DateTime.now().millisecondsSinceEpoch,
                                    sender: currentUser,
                                    replyTo: messageReplying?.id,
                                  );

                                  setState(() {
                                    sendingMessage = true;
                                  });

                                  //Sender Data
                                  final senderData =
                                      await AccountHandler(context).userByID(
                                    id: currentUser,
                                  );

                                  //Receiver Data
                                  final receiverData =
                                      await AccountHandler(context).userByName(
                                    name: widget.lovedOne["name"],
                                  );

                                  //Send Message
                                  try {
                                    if (mounted) {
                                      await ChatHandler(context).sendMessage(
                                        message: message,
                                        receiverFCM: receiverData["fcm"],
                                      );
                                    }

                                    //Notify User
                                    if (mounted) {
                                      await ChatHandler.sendNotification(
                                        context: context,
                                        fcmToken: receiverData["fcm"],
                                        title: "New Message",
                                        body:
                                            "${senderData["name"]}: ${message.content}",
                                      );
                                    }

                                    //Clear Input Field
                                    chatInputController.clear();

                                    //Add Message to List
                                    messages.insert(0, message);
                                    _chatKey.currentState?.insertItem(0);
                                  } catch (error) {
                                    debugPrint(error.toString());
                                  } finally {
                                    setState(() {
                                      sendingMessage = false;
                                      messageReplying = null;
                                    });
                                  }
                                }
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
