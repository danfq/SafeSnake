import 'package:dough/dough.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
import 'package:safesnake/pages/resources/resources.dart';
import 'package:safesnake/util/data/constants.dart';
import 'package:safesnake/util/services/strings/handler.dart';

class Resources extends StatelessWidget {
  const Resources({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: PressableDough(
        child: GestureDetector(
          onTap: () async {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const ResourcesHub(),
              ),
            );
          },
          child: const CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 60.0,
            child: Center(
              child: Icon(
                FontAwesome5Solid.hand_holding_heart,
                size: 50.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
