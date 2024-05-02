import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:safesnake/util/services/strings/handler.dart';

///Text-to-Speech Engine
class TTSEngine {
  ///Service
  static final FlutterTts _tts = FlutterTts();

  ///Initialize Service
  static Future<void> init() async {
    //Current Lang
    final currentLang = Strings.currentLang;

    //Default Voice -  Android Only
    if (Platform.isAndroid) {
      final defaultVoice = await _tts.getDefaultVoice;

      await _tts.setVoice({
        "name": defaultVoice["name"],
        "locale": defaultVoice["locale"],
      });
    }

    //Set Voice Properties
    await _tts.setVolume(0.8);
    if (currentLang == "en") {
      await _tts.setLanguage("en-US");
    } else if (currentLang == "pt") {
      await _tts.setLanguage("pt-PT");
    }
  }

  ///Speak `message` using System Language & Voice
  static Future<void> speak({required String message}) async {
    //Speak Message
    await _tts.speak(message);
  }

  ///Change Language
  static Future<void> changeLang({required String lang}) async {
    if (lang == "en") {
      await _tts.setLanguage("en-US");
    } else if (lang == "pt") {
      await _tts.setLanguage("pt-PT");
    }
  }
}
