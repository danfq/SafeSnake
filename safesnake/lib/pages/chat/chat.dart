import 'package:flutter/material.dart';
import 'package:safesnake/util/chat/handler.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/models/message.dart';
import 'package:safesnake/util/widgets/main.dart';

class LovedOneChat extends StatefulWidget {
  const LovedOneChat({super.key, required this.lovedOne});

  ///Loved One ID
  final Map<String, dynamic> lovedOne;

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

  ///Current User
  final String currentUser = LocalData.boxData(box: "personal")["id"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: MainWidgets(context: context).appBar(
        title: Text(widget.lovedOne["name"]),
      ),
    );
  }
}
