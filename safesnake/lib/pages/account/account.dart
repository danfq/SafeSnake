import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/account/login.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/services/strings/handler.dart';
import 'package:safesnake/util/theming/controller.dart';
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

  ///Current Lang
  final currentLang = Strings.currentLang;

  ///Set Question
  void setQuestion() {
    //Question Based on Current Step
    switch (step) {
      //Name
      case 0:
        question = Strings.intro["question_1"][currentLang];

      //Referral Code
      case 1:
        question = Strings.intro["question_2"][currentLang];

      //E-mail
      case 2:
        question = Strings.intro["question_3"][currentLang];

      //Password
      case 3:
        question = Strings.intro["question_4"][currentLang];

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
          placeholder: Strings.intro["name"][currentLang],
        );

      //Referral Code
      case 1:
        return Input(
          controller: referralController,
          placeholder: Strings.intro["referral"][currentLang],
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
      return Strings.buttons["next"][currentLang];
    } else {
      return Strings.buttons["done"][currentLang];
    }
  }

  @override
  void initState() {
    super.initState();

    //Question
    setQuestion();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ThemeController.statusAndNav(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        allowBack: false,
        centerTitle: false,
        title: Text(Strings.account["create"][currentLang]),
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
              await AccountHandler.createAccount(
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
