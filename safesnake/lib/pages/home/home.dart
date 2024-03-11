import 'package:flutter/material.dart';
import 'package:safesnake/pages/home/widgets/help.dart';
import 'package:safesnake/pages/home/widgets/people.dart';
import 'package:safesnake/pages/home/widgets/settings.dart';
import 'package:safesnake/pages/home/widgets/suicide.dart';
import 'package:safesnake/util/data/local.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ///Loved Ones
  List<dynamic> lovedOnes = LocalData.boxData(box: "loved_ones")["list"] ?? [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //Ask for Help
        AskForHelp(lovedOnes: lovedOnes),

        //Extras
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Settings(),
            People(lovedOnes: lovedOnes),
          ],
        ),

        //Suicide Call
        const SuicideCall(),
      ],
    );
  }
}
