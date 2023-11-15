import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:native_dialog/native_dialog.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/models/loved_one.dart';

class LovedOnes extends StatefulWidget {
  const LovedOnes({super.key});

  @override
  State<LovedOnes> createState() => _LovedOnesState();
}

class _LovedOnesState extends State<LovedOnes> {
  ///Loved Ones
  final lovedOnes =
      (LocalData.boxData(box: "loved_ones")["list"] ?? []) as List;

  @override
  Widget build(BuildContext context) {
    //Parsed Loved Ones
    List<LovedOne> parsedLovedOnes = [];

    //Parse Loved Ones
    if (lovedOnes.isNotEmpty) {
      parsedLovedOnes = lovedOnes.map((lovedOne) {
        return LovedOne.fromJSON(lovedOne);
      }).toList();
    }

    return parsedLovedOnes.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: parsedLovedOnes.length,
              itemBuilder: (context, index) {
                //Loved One
                final lovedOne = parsedLovedOnes[index];

                //UI
                return ListTile(
                  tileColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  title: Text(
                    lovedOne.name,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  trailing: Icon(
                    lovedOne.status == LovedOneStatus.invited.name
                        ? Ionicons.ios_time_outline
                        : Ionicons.ios_checkmark,
                  ),
                  onTap: () async {
                    switch (lovedOne.status) {
                      //Invited
                      case "invited":
                        await NativeDialog.alert(
                            "${lovedOne.name} hasn't joined SafeSnake, yet.");

                      //Accepted
                      case "accepted":
                        await NativeDialog.alert(
                          "${lovedOne.name} has joined SafeSnake, and is a Loved One!",
                        );
                    }
                  },
                );
              },
            ),
          )
        : const Center(child: Text("You Haven't Added Any Loved Ones Yet"));
  }
}
