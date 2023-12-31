import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/animations/handler.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/models/loved_one.dart';
import 'package:safesnake/util/notifications/local.dart';

class LovedOnes extends StatefulWidget {
  const LovedOnes({super.key});

  @override
  State<LovedOnes> createState() => _LovedOnesState();
}

class _LovedOnesState extends State<LovedOnes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AccountHandler(context).lovedOnes(),
      builder: (context, snapshot) {
        //Loved Ones
        final lovedOnes = snapshot.data;

        //Connection State
        if (snapshot.connectionState == ConnectionState.done) {
          //Check Loved Ones
          if (lovedOnes != null && lovedOnes.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: lovedOnes.length,
                itemBuilder: (context, index) {
                  //Loved One
                  final lovedOne = lovedOnes[index];

                  //UI
                  return ListTile(
                    tileColor: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    title: Text(
                      lovedOne,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    trailing: const Icon(Ionicons.ios_checkmark),
                  );
                },
              ),
            );
          } else {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: AnimationsHandler.asset(
                    animation: "empty",
                    reverse: true,
                  ),
                ),
                const Text("Looks like Tsuki needs to play by herself :("),
              ],
            );
          }
        } else {
          return Center(
            child: AnimationsHandler.asset(animation: "loading"),
          );
        }
      },
    );
  }
}
