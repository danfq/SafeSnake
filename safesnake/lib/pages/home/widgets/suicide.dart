import 'package:dough/dough.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
import 'package:safesnake/util/data/constants.dart';

class SuicideCall extends StatelessWidget {
  const SuicideCall({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0),
      child: PressableDough(
        child: GestureDetector(
          onTap: () async {
            await Get.defaultDialog(
              title: "Are you sure?",
              content: const Text(
                "A call will be made to the National Suicide Hotline.",
              ),
              cancel: TextButton(
                onPressed: () => Get.back(),
                child: const Text("Cancel"),
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
                child: const Text("Confirm"),
              ),
            );
          },
          child: const CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 60.0,
            child: Center(
              child: Icon(
                Ionicons.ios_call,
                size: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
