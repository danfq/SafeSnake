import 'package:flutter/material.dart';
import 'package:safesnake/util/notifications/local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///Remote Data
class RemoteData {
  ///Context
  final BuildContext context;

  ///Remote Data
  RemoteData(this.context);

  ///Supabase Database Client
  static final _database = Supabase.instance.client;

  ///Add `data` on `table`.
  ///
  ///If already present, `data` will be updated instead.
  Future<void> addData({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    //Attempt to Set Data
    try {
      await _database.from(table).upsert(data).select();
    } on PostgrestException catch (error) {
      if (context.mounted) {
        //Notify User
        await LocalNotification(context: context).show(
          type: NotificationType.failure,
          message: error.message,
        );
      }
    }
  }
}
