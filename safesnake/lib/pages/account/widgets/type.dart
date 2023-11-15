import 'package:flutter/material.dart';
import 'package:safesnake/util/account/handler.dart';

class AccountTypeChoice extends StatefulWidget {
  const AccountTypeChoice({super.key, required this.onSelected});

  ///On AccountType Selected
  final Function(AccountType type) onSelected;

  @override
  State<AccountTypeChoice> createState() => _AccountTypeChoiceState();
}

class _AccountTypeChoiceState extends State<AccountTypeChoice> {
  ///Selected Type
  String selectedType = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              selectedType = "normal";

              //Set Selected Type
              widget.onSelected(AccountType.normal);
            });
          },
          style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: selectedType == "normal" ? Colors.white : Colors.black,
              ),
              backgroundColor: selectedType == "normal"
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey.shade300),
          child: const Text("For Help"),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              selectedType = "lovedOne";

              //Set Selected Type
              widget.onSelected(AccountType.lovedOne);
            });
          },
          style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: selectedType == "lovedOne" ? Colors.white : Colors.black,
              ),
              backgroundColor: selectedType == "lovedOne"
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey.shade300),
          child: const Text("To Help"),
        ),
      ],
    );
  }
}
