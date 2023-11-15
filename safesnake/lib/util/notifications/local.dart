import 'package:flutter/material.dart';
import 'package:m_toast/m_toast.dart';
import 'package:safesnake/util/theming/controller.dart';

///Local Notification
class LocalNotification {
  ///Context
  final BuildContext context;

  ///Local Notification
  LocalNotification({required this.context});

  ///Show Notification with Custom `message`, by `type`
  Future<void> show({
    required NotificationType type,
    required String message,
  }) async {
    //Toast Service
    final ShowMToast toast = ShowMToast(context);

    //Show Toast by Type
    switch (type) {
      //Success
      case NotificationType.success:
        toast.successToast(
          message: message,
          alignment: Alignment.bottomCenter,
          textColor: Colors.black,
        );

      //Failure
      case NotificationType.failure:
        toast.errorToast(
          message: message,
          alignment: Alignment.bottomCenter,
          textColor: Colors.black,
        );
    }
  }
}

///Notification Type
enum NotificationType { success, failure }
