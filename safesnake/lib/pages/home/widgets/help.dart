import 'package:dough/dough.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safesnake/pages/help/help.dart';
import 'package:safesnake/util/data/local.dart';

class AskForHelp extends StatefulWidget {
  const AskForHelp({super.key, required this.lovedOnes});

  ///Loved Ones
  final List<dynamic> lovedOnes;

  @override
  State<AskForHelp> createState() => _AskForHelpState();
}

class _AskForHelpState extends State<AskForHelp> {
  ///Loved Ones
  final lovedOnes = LocalData.boxData(box: "loved_ones")["list"] ?? [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0),
      child: PressableDough(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const Help(),
              ),
            );
          },
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE91E63),
            radius: 100.0,
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/heart.svg",
                width: 120.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
