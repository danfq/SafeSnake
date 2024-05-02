import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/people/pages/add_by_code.dart';
import 'package:safesnake/pages/people/widgets/loved_ones.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/services/strings/handler.dart';
import 'package:safesnake/util/widgets/main.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key, required this.lovedOnes});

  ///Loved Ones
  final List<dynamic> lovedOnes;

  @override
  Widget build(BuildContext context) {
    //Current Lang
    final currentLang = Strings.currentLang;

    //UI
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: const Text("Loved Ones"),
      ),
      body: const SafeArea(child: LovedOnes()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Show Bottom Sheet
          await showModalBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Send Invitation
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          //Close Sheet
                          Navigator.pop(context);

                          //Invite Person
                          await AccountHandler.invitePerson();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).dialogBackgroundColor,
                        ),
                        child: Text(Strings.lovedOnes["invite"][currentLang]),
                      ),
                    ),

                    //Or
                    Text(Strings.common["or"][currentLang]),

                    //Enter Code
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          //Close Sheet
                          Navigator.pop(context);

                          //Go to AddByCode
                          await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const AddByCode(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).dialogBackgroundColor,
                        ),
                        child: Text(
                          Strings.lovedOnes["enter_code"][currentLang],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Ionicons.ios_add, color: Colors.white),
      ),
    );
  }
}
