import 'package:dough/dough.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:safesnake/pages/people/people.dart';
import 'package:safesnake/util/models/loved_one.dart';

class People extends StatelessWidget {
  const People({super.key, required this.lovedOnes});

  ///Loved Ones
  final List<dynamic> lovedOnes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, right: 10.0),
      child: PressableDough(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => PeoplePage(lovedOnes: lovedOnes),
              ),
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
