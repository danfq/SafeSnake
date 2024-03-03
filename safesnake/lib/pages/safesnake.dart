import 'package:flutter/material.dart';
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
      AccountHandler.cacheUser();

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
    setReferralAsUsed(referral: userReferral);
  }

  ///Set Referral as Used
  Future<void> setReferralAsUsed({required String referral}) async {
    //Check Referral
    if (referral.isNotEmpty) {
      //Used
      final used = await AccountHandler.checkReferralUsage(
        id: widget.user.id,
        referral: referral,
      );

      //Set as Used if Not Used Before
      if (!used) {
        await AccountHandler.setReferralAsUsed(
          referral: referral,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: const SafeArea(child: Home()),
    );
  }
}
