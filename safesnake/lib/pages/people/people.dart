import 'package:flutter/material.dart';
import 'package:safesnake/util/widgets/main.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: const Text("Loved Ones"),
      ),
    );
  }
}
