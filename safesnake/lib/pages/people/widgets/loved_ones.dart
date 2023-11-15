import 'package:flutter/material.dart';
import 'package:safesnake/util/models/loved_one.dart';

class LovedOnes extends StatelessWidget {
  const LovedOnes({super.key, required this.lovedOnes});

  ///Loved Ones
  final List<LovedOne> lovedOnes;

  @override
  Widget build(BuildContext context) {
    return lovedOnes.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              itemCount: lovedOnes.length,
              itemBuilder: (context, index) {
                //Loved One
                final lovedOne = lovedOnes[index];

                //UI
                return ListTile(
                  title: Text(lovedOne.name),
                );
              },
            ),
          )
        : const Center(child: Text("You Haven't Added Any Loved Ones Yet"));
  }
}
