import 'package:flutter/material.dart';
import 'package:safesnake/pages/account/widgets/login_form.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/widgets/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ///E-mail Controller
  TextEditingController emailController = TextEditingController();

  ///Password
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MainWidgets(context: context).appBar(title: const Text("Login")),
      body: SafeArea(
        child: LoginForm(
          emailController: emailController,
          passwordController: passwordController,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ElevatedButton(
          onPressed: () async {
            //E-mail & Password
            final email = emailController.text.trim();
            final password = passwordController.text.trim();

            //Check E-mail & Password
            if (email.isNotEmpty && password.isNotEmpty) {
              //Sign In with E-mail & Password
              await AccountHandler.signIn(
                email: email,
                password: password,
              );
            }
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}
