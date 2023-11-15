import 'package:flutter/material.dart';
import 'package:safesnake/pages/people/widgets/contacts.dart';
import 'package:safesnake/util/widgets/main.dart';

class AddNewLovedOne extends StatefulWidget {
  const AddNewLovedOne({super.key});

  @override
  State<AddNewLovedOne> createState() => _AddNewLovedOneState();
}

class _AddNewLovedOneState extends State<AddNewLovedOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: const Text("Invite Loved Ones"),
      ),
      body: SafeArea(
        child: DeviceContacts(
          onInvited: () => setState(() {}),
        ),
      ),
    );
  }
}
