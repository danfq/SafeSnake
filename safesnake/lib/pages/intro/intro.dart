import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:safesnake/pages/account/account.dart';
import 'package:safesnake/pages/intro/pages/pages.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/services/strings/handler.dart';
import 'package:safesnake/util/theming/controller.dart';
import 'package:safesnake/util/widgets/main.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Immersion
    ThemeController.statusAndNav(context: context);
  }

  ///Current Language
  String _currentLang = Strings.currentLang;

  @override
  Widget build(BuildContext context) {
    //UI
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: const Text("SafeSnake"),
        allowBack: false,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () async {
                if (_currentLang == "en") {
                  await Strings.setLang(lang: "pt");
                  setState(() {
                    _currentLang = "pt";
                  });
                } else if (_currentLang == "pt") {
                  await Strings.setLang(lang: "en");
                  setState(() {
                    _currentLang = "en";
                  });
                }
              },
              child: Text(_currentLang.toUpperCase()),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: IntroductionScreen(
          globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          showNextButton: true,
          showBackButton: true,
          back: Text(Strings.buttons["back"][_currentLang]),
          next: Text(Strings.buttons["next"][_currentLang]),
          done: Text(
            Strings.buttons["begin"][_currentLang],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onDone: () async {
            //Set Intro as Complete
            await LocalData.setData(box: "intro", data: {"status": true});

            //Go To Account
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(builder: (context) => const Account()),
              );
            }
          },
          pages: IntroPages.all(_currentLang),
        ),
      ),
    );
  }
}
