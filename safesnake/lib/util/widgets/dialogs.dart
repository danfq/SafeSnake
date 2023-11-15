import 'package:flutter/material.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/widgets/input.dart';

///Dialog Type
enum DialogType {
  username,
  email,
  password,
}

///Utility Dialog
class UtilDialog {
  ///Context
  final BuildContext context;

  ///Utility Dialog
  UtilDialog({required this.context});

  ///Change User Data
  Future<void> changeUserData({required DialogType type}) async {
    //Dialog Name
    String dialogName;
    switch (type) {
      case DialogType.username:
        dialogName = "Username";

      case DialogType.email:
        dialogName = "E-mail";

      case DialogType.password:
        dialogName = "Password";
    }

    //Controller
    TextEditingController inputController = TextEditingController();

    //Input
    String input = inputController.text.trim();

    //Show Adaptive Dialog
    await showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  "Change $dialogName",
                  style: const TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              //Input
              Input(
                controller: inputController,
                placeholder: "New $dialogName",
                centerPlaceholder: true,
                onChanged: (inputString) {
                  input = inputString;
                },
              ),

              //Save
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      //Check Input
                      if (input.isNotEmpty) {
                        //Update User Data per Type
                        switch (type) {
                          case DialogType.username:
                            if (context.mounted) {
                              await AccountHandler(context).updateData(
                                data: {"username": input},
                              );
                            }

                          case DialogType.email:
                            if (context.mounted) {
                              await AccountHandler(context).updateData(
                                email: input,
                              );
                            }

                          case DialogType.password:
                            if (context.mounted) {
                              await AccountHandler(context).updateData(
                                password: input,
                              );
                            }
                        }

                        //Update Local User Cache
                        await AccountHandler.cacheUser();

                        //Close Dialog
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("Save"),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
