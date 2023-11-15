import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class Input extends StatefulWidget {
  const Input({
    super.key,
    required this.controller,
    required this.placeholder,
    this.centerPlaceholder = false,
    this.isPassword = false,
    this.isEmail = false,
    this.onChanged,
  });

  ///Controller
  final TextEditingController controller;

  ///Placeholder
  final String placeholder;

  ///Center Placeholder
  final bool centerPlaceholder;

  ///Password
  final bool isPassword;

  ///E-mail
  final bool isEmail;

  ///On Changed
  final Function(String input)? onChanged;

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  ///Password Visibility
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: CupertinoTextField(
        controller: widget.controller,
        placeholder: widget.placeholder,
        padding: const EdgeInsets.all(14.0),
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign:
            widget.centerPlaceholder ? TextAlign.center : TextAlign.start,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14.0),
        ),
        keyboardType:
            widget.isEmail ? TextInputType.emailAddress : TextInputType.text,
        obscureText: widget.isPassword && !passwordVisible,
        suffix: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
                icon: Icon(
                  !passwordVisible ? Ionicons.ios_eye : Ionicons.ios_eye_off,
                ),
              )
            : null,
        suffixMode: widget.isPassword
            ? OverlayVisibilityMode.editing
            : OverlayVisibilityMode.never,
        onChanged: widget.onChanged,
      ),
    );
  }
}
