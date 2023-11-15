import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:safesnake/util/animations/handler.dart';
import 'package:safesnake/util/widgets/input.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  ///E-mail Controller
  final TextEditingController emailController;

  ///Password Controller
  final TextEditingController passwordController;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //Animation Height
  double keyboardOpenAnimHeight = 150.0;
  double keyboardClosedAnimHeight = 250.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //Spacing
        const SizedBox(height: 40.0),

        //Animation
        KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              child: AnimationsHandler.asset(
                animation: "password",
                height: isKeyboardVisible
                    ? keyboardOpenAnimHeight
                    : keyboardClosedAnimHeight,
                repeat: false,
              ),
            );
          },
        ),

        //Spacing
        const SizedBox(height: 20.0),

        //E-mail
        Input(
          controller: widget.emailController,
          isEmail: true,
          placeholder: "E-mail",
        ),

        //Password
        Input(
          controller: widget.passwordController,
          isPassword: true,
          placeholder: "Password",
        ),
      ],
    );
  }
}
