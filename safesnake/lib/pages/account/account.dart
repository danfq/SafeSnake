import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/account/login.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/widgets/input.dart';
import 'package:safesnake/util/widgets/main.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  ///Username Controller
  TextEditingController usernameController = TextEditingController();

  ///Referral Code
  TextEditingController referralController = TextEditingController();

  ///E-mail Controller
  TextEditingController emailController = TextEditingController();

  ///Password Controller
  TextEditingController passwordController = TextEditingController();

  ///Step
  int step = 0;

  ///Question
  String question = "";

  ///Set Question
  void setQuestion() {
    //Question Based on Current Step
    switch (step) {
      //Name
      case 0:
        question = "What would you like me to call you?";

      //Referral Code
      case 1:
        question = "What's your Loved One's Referral Code?";

      //E-mail
      case 2:
        question =
            "Nice to meet you, ${usernameController.text}!\nWhat's your E-mail?";

      //Password
      case 3:
        question = "Can't forget the most important step!";

      //Default
      default:
        question = "";
    }
  }

  ///Step Widget
  Widget stepItem() {
    //Widget Based on Current Step
    switch (step) {
      //Name
      case 0:
        return Input(
          controller: usernameController,
          placeholder: "Name",
        );

      //Referral Code
      case 1:
        return Input(
          controller: referralController,
          placeholder: "Leave blank if you don't have a Referral Code",
        );

      //E-mail
      case 2:
        return Input(
          controller: emailController,
          placeholder: "E-mail",
        );

      //Password
      case 3:
        return Input(
          controller: passwordController,
          placeholder: "Password",
          isPassword: true,
        );

      //Default
      default:
        return Container();
    }
  }

  ///Navigation Text
  String navText() {
    //Return "Next" Except for Last Step
    if (step != 3) {
      return "Next";
    } else {
      return "All Done";
    }
  }

  @override
  void initState() {
    super.initState();

    //Question
    setQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        allowBack: false,
        centerTitle: false,
        title: const Text("Create Account"),
        leading: step != 0
            ? IconButton(
                onPressed: () {
                  //Go Back One Step
                  setState(() {
                    step -= 1;
                    setQuestion();
                  });
                },
                icon: const Icon(Ionicons.ios_chevron_back),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text("Login"),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Question
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                question,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            //Separator
            const SizedBox(height: 40.0),

            //Step
            stepItem(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ElevatedButton(
          onPressed: () async {
            //Inputs
            final nameInput = usernameController.text.trim();
            final referralCode = referralController.text.trim();
            final emailInput = emailController.text.trim();
            final passwordInput = passwordController.text.trim();

            //Check All Inputs for Account Creation
            if (nameInput.isNotEmpty &&
                emailInput.isNotEmpty &&
                passwordInput.isNotEmpty) {
              //Create Account
              await AccountHandler(context).createAccount(
                username: nameInput,
                email: emailInput,
                password: passwordInput,
                referralCode: referralCode,
              );
            }

            //Go Forward by One - Until Last Step
            if (step != 3) {
              setState(() {
                step += 1;
                setQuestion();
              });
            }
          },
          child: Text(navText()),
        ),
      ),
    );
  }
}
