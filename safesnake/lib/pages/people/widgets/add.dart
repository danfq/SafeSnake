import 'package:flutter/material.dart';
import 'package:safesnake/pages/people/widgets/contacts.dart';
import 'package:safesnake/util/widgets/main.dart';

class AddNewLovedOne extends StatelessWidget {
  const AddNewLovedOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: const Text("Invite Loved Ones"),
      ),
      body: const SafeArea(child: DeviceContacts()),
    );
  }
}
