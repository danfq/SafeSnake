
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/account/account.dart';
import 'package:safesnake/pages/safesnake.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/data/remote.dart';
import 'package:safesnake/util/notifications/local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:uuid/uuid.dart';

///Account Handler
class AccountHandler {
  ///Context
  final BuildContext context;

  ///Account Handler
  AccountHandler(this.context);

  ///Supabase Auth Client
  static final _auth = Supabase.instance.client.auth;

  ///Cache User Data Locally
  static Future<void> cacheUser() async {
    //Current User
    final currentUser = _auth.currentUser;

    //Check if User isn't Null
    if (currentUser != null) {
      //Cache User
      await LocalData.setData(
        box: "personal",
        data: {
          "name": currentUser.userMetadata?["username"],
          "email": currentUser.email,
        },
      );
    }
  }

  ///Delete Account
  ///
  ///This action is PERMANENT
  Future<void> deleteAccount() async {
    //Current User
    final currentUser = _auth.currentUser;

    //Show Sign Out Sheet
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.0),
                topRight: Radius.circular(14.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Delete Account",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: SwipeableButtonView(
                    buttonText: "Swipe to Confirm",
                    buttonWidget: const Icon(
                      Ionicons.ios_chevron_forward,
                      color: Colors.grey,
                    ),
                    activeColor: Colors.grey.shade600,
                    onWaitingProcess: () async {
                      if (currentUser != null) {
                        //Add Deletion Request
                        await RemoteData(context).addData(
                          table: "delete_requests",
                          data: {
                            "id": const Uuid().v4(),
                            "user_id": currentUser.id,
                          },
                        );

                        //Clear User Data
                        await LocalData.clearAll();

                        //Close App
                        await FlutterExitApp.exitApp(iosForceExit: true);
                      }
                    },
                    onFinish: () async {},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///Sign Out
  ///
  ///Takes the User back to `Account`
  Future<void> signOut() async {
    //Show Sign Out Sheet
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.0),
                topRight: Radius.circular(14.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Sign Out",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: SwipeableButtonView(
                    buttonText: "Swipe to Sign Out",
                    buttonWidget: const Icon(
                      Ionicons.ios_chevron_forward,
                      color: Colors.grey,
                    ),
                    activeColor: Colors.grey.shade600,
                    onWaitingProcess: () async {
                      await _auth.signOut().then((_) {
                        //Go to Account
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const Account(),
                          ),
                          (route) => false,
                        );
                      });
                    },
                    onFinish: () async {},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ///Update User Data
  Future<bool> updateData({
    String? email,
    String? password,
    Map<String, String>? data,
  }) async {
    //User Updated
    bool userUpdated = false;

    //Current User
    final currentUser = _auth.currentUser;

    //Check if User is Logged In
    if (currentUser != null) {
      //Update User per Provided Data
      await _auth
          .updateUser(
        UserAttributes(
          email: email ?? currentUser.email,
          password: password,
          data: data,
        ),
      )
          .then((response) {
        //New User Data
        final user = response.user;

        //Return if User is Not Null
        userUpdated = user != null;
      });
    }

    //Return Update Status
    return userUpdated;
  }

  ///Sign In with `email` and `password`
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    //Attempt to Sign In
    try {
      await _auth
          .signInWithPassword(
        email: email,
        password: password,
      )
          .then((response) {
        //User
        final user = response.user;

        //Check if User was Created
        if (user != null) {
          //Go Home
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => SafeSnake(user: user),
            ),
            (route) => false,
          );
        }
      });
    } on AuthException catch (error) {
      if (context.mounted) {
        //Notify User
        LocalNotification(context: context).show(
          type: NotificationType.failure,
          message: error.message,
        );
      }
    }
  }

  ///Create Account with `username`, `email` and `password`
  Future<void> createAccount({
    required String username,
    required String email,
    required String password,
  }) async {
    //Attempt to Create Account
    try {
      await _auth.signUp(
        email: email,
        password: password,
        data: {
          "username": username,
        },
      ).then((response) {
        //User
        final user = response.user;

        //Check if User was Created
        if (user != null) {
          //Go Home
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => SafeSnake(user: user),
            ),
          );
        }
      });
    } on AuthException catch (error) {
      if (context.mounted) {
        //Notify User
        LocalNotification(context: context).show(
          type: NotificationType.failure,
          message: error.message,
        );
      }
    }
  }
}

///Account Type
enum AccountType {
  normal,
  lovedOne,
}
