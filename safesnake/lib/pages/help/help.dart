import 'package:flutter/material.dart';
import 'package:safesnake/util/accessibility/tts.dart';
import 'package:safesnake/util/data/constants.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/help/handler.dart';
import 'package:safesnake/util/widgets/main.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    //Help Options
    List<String> helpOptions = HelpItems.all;

    //Shuffle Help Options
    helpOptions.shuffle();

    //UI
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: const Text("Get Help"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            //Page Title
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: MainWidgets(context: context).pageTitle(
                title: "Choose from the list below:",
              ),
            ),

            //List of Help Options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children: helpOptions
                      .map(
                        (item) => InkWell(
                          onLongPress: () async {
                            //TTS
                            final ttsMode = LocalData.boxData(
                                    box: "accessibility")["tts"] ??
                                false;

                            //Check Text to Speech
                            if (ttsMode) {
                              await TTSEngine.speak(message: item);
                            }
                          },
                          onTap: () async {
                            //Show Help Menu
                            await HelpHandler.showHelpSheet(
                              context: context,
                              helpContent: item.trim(),
                            );
                          },
                          borderRadius: BorderRadius.circular(14.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  item,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
