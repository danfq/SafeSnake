import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
import 'package:safesnake/util/data/constants.dart';
import 'package:safesnake/util/services/strings/handler.dart';

class SuicideCall extends StatelessWidget {
  const SuicideCall({super.key});

  @override
  Widget build(BuildContext context) {
    //Current Lang
    final currentLang = Strings.currentLang;

    //UI
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: PressableDough(
        child: GestureDetector(
          onTap: () async {
            await Get.defaultDialog(
              title: Strings.help["are_you_sure"][currentLang],
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Strings.help["call_sui_desc"][currentLang],
                ),
              ),
              cancel: TextButton(
                onPressed: () => Get.back(),
                child: Text(Strings.buttons["cancel"][currentLang]),
              ),
              confirm: ElevatedButton(
                onPressed: () async {
                  //Close Dialog
                  Get.back();

                  //Place Call
                  await FlutterPhoneDirectCaller.callNumber(
                    Constants.suicideHotline,
                  );
                },
                child: Text(Strings.buttons["confirm"][currentLang]),
              ),
            );
          },
          child: const CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 60.0,
            child: Center(
              child: Icon(
                Ionicons.ios_alert_circle_outline,
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
