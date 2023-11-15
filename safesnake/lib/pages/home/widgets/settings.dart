import 'package:dough/dough.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safesnake/pages/settings/settings.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 30.0),
      child: PressableDough(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const SettingsPage()),
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 60.0,
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/settings.svg",
                width: 70.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
