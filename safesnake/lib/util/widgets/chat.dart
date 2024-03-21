import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:safesnake/util/accessibility/tts.dart';
import 'package:safesnake/util/chat/handler.dart';
import 'package:safesnake/util/data/constants.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/models/message.dart';
import 'package:safesnake/util/theming/colors.dart';
import 'package:safesnake/util/theming/controller.dart';

class ChatItem extends StatefulWidget {
  const ChatItem({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.isLastInGroup,
    required this.keyboardFocusNode,
    required this.onReply,
    this.repliedContent,
  });

  final MessageData message;
  final bool isCurrentUser;
  final bool isLastInGroup;
  final FocusNode keyboardFocusNode;
  final Function(MessageData message) onReply;
  final String? repliedContent;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  ///Message Focused Status
  bool messageFocused = false;

  //Minimum Width for Replied Message
  double minRepliedMessageWidth = 100.0;

  //Maximum Width for Replied Message
  double maxRepliedMessageWidth = 200.0;

  ///Calculate Message Width based on its Content
  double calculateRepliedMessageWidth() {
    final textPainter = TextPainter(
      text: TextSpan(
        text: widget.repliedContent ?? "",
        style: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor),
      maxLines: 1,
      textWidthBasis: TextWidthBasis.parent,
      textHeightBehavior: DefaultTextHeightBehavior.of(context),
      locale: Localizations.localeOf(context),
    );

    textPainter.layout(maxWidth: maxRepliedMessageWidth);

    // Return Actual Width
    return textPainter.width;
  }

  ///Check if Message is Help Item
  bool isHelpItem() {
    return HelpItems.all.contains(widget.message.content);
  }

  @override
  Widget build(BuildContext context) {
    ///Accent Color
    final accentColor = LocalData.boxData(box: "colors").isNotEmpty &&
            LocalData.boxData(box: "colors")["accent"] != null
        ? HexColor.fromHex(LocalData.boxData(box: "colors")["accent"])
        : Theme.of(context).colorScheme.secondary;

    //UI
    return GestureDetector(
      onLongPress: () {
        //Message Render Box
        final RenderBox renderBox =
            this.context.findRenderObject() as RenderBox;

        //Message UI Center
        final Offset messageCenter = renderBox.localToGlobal(
          renderBox.size.center(Offset.zero),
        );

        //TTS
        final ttsMode = LocalData.boxData(box: "accessibility")["tts"] ?? false;

        setState(() {
          messageFocused = true;
        });

        //Show Menu
        showPullDownMenu(
          context: context,
          onCanceled: () {
            setState(() {
              messageFocused = false;
            });
          },
          items: [
            //Reply to Message
            PullDownMenuItem(
              title: "Reply To",
              icon: FontAwesome5Solid.reply,
              onTap: () {
                setState(() {
                  messageFocused = false;
                });

                //Bring Keyboard into Focus
                widget.keyboardFocusNode.requestFocus();

                //Set Reply Status
                widget.onReply(widget.message);
              },
            ),

            //TTS
            PullDownMenuItem(
              title: "Speak Message",
              icon: MaterialCommunityIcons.text_to_speech,
              onTap: ttsMode
                  ? () async {
                      await TTSEngine.speak(message: widget.message.content);
                    }
                  : null,
            ),

            //Delete Message - Only Own Messages
            PullDownMenuItem(
              enabled: widget.isCurrentUser,
              title: "Delete",
              icon: Ionicons.ios_trash,
              onTap: () async {
                setState(() {
                  messageFocused = false;
                });

                //Confirmation
                showAdaptiveDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text(
                        "Deleting a Message is irreversible.",
                      ),
                      actions: [
                        //Cancel
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),

                        //Confirm
                        ElevatedButton(
                          onPressed: () async {
                            //Delete Message
                            await ChatHandler(context).deleteMessage(
                              id: widget.message.id,
                            );
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            //Information
            PullDownMenuItem(
              title: "Information",
              icon: Ionicons.ios_information,
              onTap: () async {
                await Get.defaultDialog(
                  title: "Message Info",
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Sent At: ${DateTime.fromMillisecondsSinceEpoch(widget.message.sentAt)}",
                    ),
                  ),
                );
              },
            ),
          ],
          position: Rect.fromCenter(
            center: messageCenter,
            width: 20,
            height: 50,
          ),
        );
      },
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Spacing - If Replied Message is Present
            widget.message.replyTo != null
                ? const SizedBox(height: 10.0)
                : Container(),

            //Replied Message - If Present
            if (widget.message.replyTo != null)
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Align(
                  alignment: widget.isCurrentUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: IntrinsicHeight(
                    child: Container(
                      width: calculateRepliedMessageWidth(),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: IntrinsicWidth(
                          child: Text(
                            widget.repliedContent ?? "",
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(),

            //Chat Message
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              child: BubbleSpecialThree(
                text: widget.message.content,
                isSender: widget.isCurrentUser,
                color: widget.isCurrentUser
                    ? messageFocused
                        ? accentColor!.withOpacity(0.6)
                        : accentColor!
                    : messageFocused
                        ? Colors.grey.withOpacity(0.8)
                        : Colors.grey.withOpacity(0.6),
                textStyle: TextStyle(
                  color: !widget.isCurrentUser
                      ? !ThemeController.current(context: context)
                          ? Colors.black
                          : Colors.white
                      : Colors.white,
                  fontSize: 16.0,
                  fontStyle: isHelpItem() ? FontStyle.italic : FontStyle.normal,
                  fontWeight:
                      isHelpItem() ? FontWeight.bold : FontWeight.normal,
                ),
                tail: widget.isLastInGroup,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
