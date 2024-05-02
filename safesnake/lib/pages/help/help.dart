import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/util/accessibility/tts.dart';
import 'package:safesnake/util/data/constants.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/help/handler.dart';
import 'package:safesnake/util/models/help_item.dart';
import 'package:safesnake/util/services/strings/handler.dart';
import 'package:safesnake/util/widgets/main.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
//Colorful Mode
  final bool colorfulMode =
      LocalData.boxData(box: "settings")["colorful"] ?? false;

  //TTS
  final ttsMode = LocalData.boxData(box: "accessibility")["tts"] ?? false;

  //Random Pastel Color
  Color randomPastelColor() {
    //Random RGB Pastel Colors
    int red = Random().nextInt(128) + 128;
    int green = Random().nextInt(128) + 100;
    int blue = Random().nextInt(128) + 100;

    //Random Pastel Color
    return Color.fromRGBO(red, green, blue, 1);
  }

  ///Help Mode
  bool _helpMode = false;

  ///Current Lang
  final currentLang = Strings.currentLang;

  ///Help Items
  List<HelpItem> _helpItems = [];

  ///Get Items
  Future<void> getItems() async {
    //Items
    final items = await HelpHandler.getItems();

    //Set Items
    setState(() {
      _helpItems = items;
    });
  }

  @override
  void initState() {
    super.initState();

    //Get Items
    getItems();
  }

  ///Help List
  Widget _helpList() {
    //By Help Mode
    switch (_helpMode) {
      //Grid
      case false:
        return GridView.count(
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          children: _helpItems
              .map(
                (item) => InkWell(
                  onLongPress: () async {
                    //Check Text to Speech
                    if (ttsMode) {
                      await TTSEngine.speak(
                        message: currentLang == "en" ? item.en : item.pt,
                      );
                    }
                  },
                  onTap: () async {
                    //Show Help Menu
                    await HelpHandler.showHelpSheet(
                      context: context,
                      helpContent: currentLang == "en" ? item.en : item.pt,
                    );
                  },
                  borderRadius: BorderRadius.circular(14.0),
                  child: Card(
                    color: colorfulMode
                        ? randomPastelColor()
                        : Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          currentLang == "en" ? item.en : item.pt,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        );

      case true:
        return ListView.builder(
          itemCount: _helpItems.length,
          itemBuilder: (context, index) {
            //Option
            final option = _helpItems[index];

            //UI
            return Padding(
              padding: const EdgeInsets.all(14.0),
              child: ListTile(
                onLongPress: () async {
                  //Check Text to Speech
                  if (ttsMode) {
                    await TTSEngine.speak(
                        message: currentLang == "en" ? option.en : option.pt);
                  }
                },
                onTap: () async {
                  //Show Help Menu
                  await HelpHandler.showHelpSheet(
                    context: context,
                    helpContent: currentLang == "en" ? option.en : option.pt,
                  );
                },
                tileColor: colorfulMode
                    ? randomPastelColor()
                    : Theme.of(context).cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                title: Text(currentLang == "en" ? option.en : option.pt),
              ),
            );
          },
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: Text(Strings.help["get_help"][currentLang]),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  _helpMode = !_helpMode;
                });
              },
              icon: Icon(
                _helpMode
                    ? Ionicons.ios_grid_outline
                    : Ionicons.ios_list_outline,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            //Page Title
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: MainWidgets(context: context).pageTitle(
                title: Strings.help["choose_list"][currentLang],
              ),
            ),

            //List of Help Options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: _helpList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
