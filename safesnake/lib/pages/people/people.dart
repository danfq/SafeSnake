import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/people/widgets/loved_ones.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/notifications/local.dart';
import 'package:safesnake/util/widgets/main.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key, required this.lovedOnes});

  ///Loved Ones
  final List<dynamic> lovedOnes;

  @override
  Widget build(BuildContext context) {
    //Loved Ones

    //UI
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: const Text("Loved Ones"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {
                //Invitation Status
                final inviteSent = await AccountHandler(context).invitePerson();

                //Notify Based on Status
                if (context.mounted) {
                  await LocalNotification(context: context).show(
                    type: inviteSent
                        ? NotificationType.success
                        : NotificationType.failure,
                    message: inviteSent
                        ? "Invitation Sent!"
                        : "Failed to Send Invitation",
                  );
                }
              },
              tooltip: "Invite Loved One",
              icon: const Icon(Ionicons.ios_add),
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: LovedOnes(),
      ),
    );
  }
}
