import 'package:flutter/material.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/services/strings/handler.dart';
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

  ///Current Language
  static final currentLang = Strings.currentLang;

  @override
  Widget build(BuildContext context) {
    //UI
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        title: Text(Strings.pageTitles["referral_add_code"][currentLang]),
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
              placeholder: Strings.common["referral_code"][currentLang],
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
                    await AccountHandler.addPersonByReferral(
                      referral: referral,
                    ).then((_) => setState(() {}));
                  }
                },
                child: Text(Strings.lovedOnes["add"][currentLang]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
