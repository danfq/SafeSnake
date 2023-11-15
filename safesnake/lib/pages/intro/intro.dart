import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:safesnake/pages/account/account.dart';
import 'package:safesnake/pages/intro/pages/pages.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/theming/controller.dart';
import 'package:safesnake/util/widgets/main.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    //Immersion
    ThemeController.statusAndNav(context: context);

    //UI
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: const Text("SafeSnake"),
        allowBack: false,
      ),
      body: SafeArea(
        child: IntroductionScreen(
          globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          showNextButton: true,
          showBackButton: true,
          back: const Text("Back"),
          next: const Text("Next"),
          done: const Text(
            "Let's Begin",
            style: TextStyle(fontWeight: FontWeight.bold),
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
          pages: IntroPages.all,
        ),
      ),
    );
  }
}
