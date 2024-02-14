import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';

///Text-to-Speech Engine
class TTSEngine {
  ///Service
  static final FlutterTts _tts = FlutterTts();

  ///Initialize Service
  static Future<void> init() async {
    //Default Voice -  Android Only
    if (Platform.isAndroid) {
      final defaultVoice = await _tts.getDefaultVoice;
      await _tts.setVoice(defaultVoice);
    }

    //Set Voice Properties
    await _tts.setVolume(0.8);
    await _tts.setLanguage("en-US");
  }

  ///Speak `message` using System Language & Voice
  static Future<void> speak({required String message}) async {
    //Speak Message
    await _tts.speak(message);
  }
}
