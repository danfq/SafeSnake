import 'package:dough/dough.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/people/people.dart';

class People extends StatelessWidget {
  const People({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, right: 10.0),
      child: PressableDough(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const PeoplePage()),
            );
          },
          child: CircleAvatar(
            backgroundColor: const Color(0xFF008080),
            radius: 70.0,
            child: Center(
              child: SvgPicture.asset(
                "assets/icons/people.svg",
                fit: BoxFit.cover,
                width: 80.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
