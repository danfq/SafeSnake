import 'package:flutter_dotenv/flutter_dotenv.dart';

///Environment Variables
class EnvVars {
  ///DotEnv Handler
  static final _dotEnv = DotEnv();

  ///Load from `.env`
  static Future<void> load() async {
    await _dotEnv.load(fileName: ".env");
  }

  ///Get Variable by `name`
  static String get({required String name}) {
    return _dotEnv.get(name, fallback: "undefined");
  }
}
