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
  final instance = Supabase.instance.client;

  ///Add `data` on `table`.
  Future<void> addData({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    //Attempt to Set Data
    try {
      await instance.from(table).upsert(data).select();
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

  ///Get Data from Table
  Future<List> getData({required String table}) async {
    //Data
    List data = [];

    //Attempt to Get Data
    try {
      data = await instance.from(table).select();
    } on PostgrestException catch (error) {
      if (context.mounted) {
        //Notify User
        await LocalNotification(context: context).show(
          type: NotificationType.failure,
          message: error.message,
        );
      }
    }

    //Return Data
    return data;
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
      await instance.from(table).update(data).eq(column, match).select();
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
