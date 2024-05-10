import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

///Resources Handler
class ResourcesHandler {
  ///Call Number
  static Future<void> call({required String number}) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
