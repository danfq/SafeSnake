import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:safesnake/firebase_options.dart';
import 'package:safesnake/pages/account/account.dart';
import 'package:safesnake/pages/intro/intro.dart';
import 'package:safesnake/pages/safesnake.dart';
import 'package:safesnake/util/accessibility/tts.dart';
import 'package:safesnake/util/account/handler.dart';
import 'package:safesnake/util/data/env.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/services/notifications/remote.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///Main Services
class MainServices {
  ///Initialize Services
  ///
  ///- Widgets Binding.
  ///- Environment Variables (DotEnv).
  ///- Local Data (HIVE).
  ///- Remote Data (Supabase).
  ///- Notifications (Firebase).
  ///- TTS Engine.
  static Future<void> init() async {
    //Widgets Binding
    WidgetsFlutterBinding.ensureInitialized();

    //Environment Variables
    await EnvVars.load();

    //Local Data
    await LocalData.init();

    //Remote Data
    await Supabase.initialize(
      url: EnvVars.get(name: "SUPABASE_URL"),
      anonKey: EnvVars.get(name: "SUPABASE_KEY"),
    );

    //Firebase (Notifications)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((_) async {
      //Handle APNs Token
      await AccountHandler.fcmToken();

      //Initialize Notification Service
      await RemoteNotifications.init();
    });

    //TTS Engine
    await TTSEngine.init();
  }

  ///Initial Route
  static Future<Widget> initialRoute() async {
    //Intro Status
    final introStatus = LocalData.boxData(box: "intro")["status"] ?? false;

    //Signed In User
    final currentUser = Supabase.instance.client.auth.currentUser;

    return introStatus
        ? currentUser != null
            ? SafeSnake(user: currentUser)
            : const Account()
        : const Intro();
  }
}
