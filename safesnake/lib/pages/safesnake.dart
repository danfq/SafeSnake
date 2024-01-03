import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/home/home.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/animations/handler.dart';
import 'package:safesnake/util/theming/controller.dart';
import 'package:safesnake/util/widgets/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SafeSnake extends StatefulWidget {
  const SafeSnake({super.key, required this.user});

  ///User
  final User user;

  @override
  State<SafeSnake> createState() => _SafeSnakeState();
}

class _SafeSnakeState extends State<SafeSnake> {
  ///Current Theme
  bool currentTheme = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //Current Theme
    currentTheme = ThemeController.current(context: context);

    //Immersion
    ThemeController.statusAndNav(context: context);

    if (context.mounted) {
      //Cache User
      AccountHandler(context).cacheUser();

      //Listen for Firebase Messages
      AccountHandler.fcmListen();
    }
  }

  @override
  void initState() {
    super.initState();

    //User Referral Code
    final String userReferral = widget.user.userMetadata!["invited_by"];

    //Set Referral Code as Used - If Not Null
    if (userReferral.isNotEmpty) {
      AccountHandler(context).setReferralAsUsed(
        id: widget.user.id,
        referral: userReferral,
      );
    }

    if (context.mounted) {
      //Cache User
      AccountHandler(context).cacheUser();

      //Listen for Firebase Messages
      AccountHandler.fcmListen();
    }
  }

  @override
  Widget build(BuildContext context) {
    //UI
    return Scaffold(
      appBar: MainWidgets(context: context).appBar(
        allowBack: false,
        title: Row(
          children: [
            AnimationsHandler.asset(animation: "corn", height: 40.0),
            const SizedBox(width: 4.0),
            Text(
              "SafeSnake",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: currentTheme ? Colors.white : const Color(0xFF008080),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Ionicons.ios_chatbox),
            ),
          ),
        ],
      ),
      body: const SafeArea(child: Home()),
    );
  }
}
