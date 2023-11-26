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
  Future<void> addData({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    //Attempt to Set Data
    try {
      await _database.from(table).insert(data).select();
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

  ///Update `data` on `table`, where `match` is within `column`
  Future<void> updateData({
    required String table,
    required String column,
    required String match,
    required Map<String, dynamic> data,
  }) async {
    //Attempt to Set Data
    try {
      await _database.from(table).update(data).eq(column, match).select();
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
