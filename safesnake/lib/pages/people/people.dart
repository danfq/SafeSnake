import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/people/widgets/add.dart';
import 'package:safesnake/pages/people/widgets/loved_ones.dart';
import 'package:safesnake/util/models/loved_one.dart';
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
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const AddNewLovedOne(),
                  ),
                );
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
