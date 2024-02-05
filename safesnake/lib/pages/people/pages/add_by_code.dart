import 'package:flutter/material.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/widgets/input.dart';
import 'package:safesnake/util/widgets/main.dart';

class AddByCode extends StatefulWidget {
  const AddByCode({super.key});

  @override
  State<AddByCode> createState() => _AddByCodeState();
}

class _AddByCodeState extends State<AddByCode> {
  ///Code Controller
  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //UI
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: const Text("Add by Referral"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Input
            Input(
              controller: codeController,
              centerPlaceholder: true,
              placeholder: "Referral Code",
            ),

            //Proceed
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: () async {
                  //Referral Code
                  final referral = codeController.text.trim();

                  //Check Referral Code
                  if (referral.isNotEmpty) {
                    //Add Loved One
                    await AccountHandler(context)
                        .addPersonByReferral(
                          referral: referral,
                        )
                        .then((_) => setState(() {}));
                  }
                },
                child: const Text("Add Loved One"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
