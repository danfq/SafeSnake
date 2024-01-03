import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:safesnake/pages/account/account.dart';
import 'package:safesnake/pages/safesnake.dart';
import 'package:safesnake/util/data/local.dart';
import 'package:safesnake/util/data/remote.dart';
import 'package:safesnake/util/notifications/local.dart';
import 'package:safesnake/util/notifications/remote.dart';
import 'package:share_plus/share_plus.dart';
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

  ///Firebase Messaging
  static final _firebaseMessaging = FirebaseMessaging.instance;

  ///Current User
  User? get currentUser => _auth.currentUser;

  ///Cache User Data Locally
  static Future<void> cacheUser() async {
    //Current User
    final currentUser = _auth.currentUser;

    //Check if User isn't Null
    if (currentUser != null) {
      //FCM Token
      final fcm = await fcmToken();

      //Cache User
      await LocalData.setData(
        box: "personal",
        data: {
          "id": currentUser.id,
          "name": currentUser.userMetadata?["username"],
          "accept_invites": currentUser.userMetadata?["accept_invites"],
          "referral": currentUser.userMetadata?["referral"],
          "email": currentUser.email,
          "fcm": fcm,
        },
      );
    }
  }

  ///Get FCM Token
  static Future<String> fcmToken() async {
    String userToken = "";

    //Request Permission
    await _firebaseMessaging.requestPermission();

    //Get Token
    await _firebaseMessaging.getToken().then((String? token) {
      userToken = token ?? "";
    });

    //Return Token
    return userToken;
  }

  ///Listen for Firebase Messages
  static void fcmListen(BuildContext context) {
    //Listen for Messages - Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      //Send Notification
      await RemoteNotifications.showNotif(message.notification!);
    });

    //Listen for Messages - Background
    FirebaseMessaging.onBackgroundMessage(_onBackground);
  }

  ///Background Notification
  @pragma("vm:entry-point")
  static Future<void> _onBackground(RemoteMessage message) async {
    //Send Notification
    await RemoteNotifications.showNotif(message.notification!);
  }

  ///Get Loved Ones as `List<String>`
  Future<List<Map<String, dynamic>>> lovedOnes() async {
    //Loved Ones
    List<Map<String, dynamic>> lovedOnes = [];

    //Current User ID
    final currentUserID = currentUser?.id;

    //Invitations
    final invitations = await RemoteData(context).getData(table: "invitations");

    // Filter By Current User's ID as the Creator
    for (final invitation in invitations) {
      //Created Referral
      if (invitation["created_by"] == currentUserID) {
        final user = await userByID(id: invitation["used_by"]);

        //Add User
        lovedOnes.add(user);
      }

      //Used Referral
      if (invitation["used_by"] == currentUserID) {
        final user = await userByID(id: invitation["created_by"]);

        //Add User
        lovedOnes.add(user);
      }
    }

    // Return Loved Ones
    return lovedOnes;
  }

  ///User by ID
  Future<Map<String, dynamic>> userByID({required String id}) async {
    //Get User Name via ID
    final users = await RemoteData(context).getData(table: "users");

    //Matching User
    final matchingUser = users.firstWhere((user) {
      return user["id"] == id;
    });

    //Return User Data
    return {
      "id": matchingUser["id"],
      "name": matchingUser["name"],
    };
  }

  ///User by Referral
  Future<Map<String, dynamic>> _userByReferral({
    required String referral,
  }) async {
    //Get User Name via ID
    final users = await RemoteData(context).getData(table: "users");

    //Matching User
    final matchingUser = users.firstWhere((user) {
      return user["referral"] == referral;
    });

    //Return User Data
    return {
      "id": matchingUser["id"],
      "name": matchingUser["name"],
    };
  }

  ///Delete Account
  ///
  ///This action is PERMANENT
  Future<void> deleteAccount() async {
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
                            "user_id": currentUser?.id,
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
    Map<String, dynamic>? data,
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
          .then((response) async {
        //User
        final user = response.user;

        //Check if User was Created
        if (user != null) {
          //Cache User Data
          await cacheUser();

          //Go Home
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => SafeSnake(user: user),
              ),
              (route) => false,
            );
          }
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
    String? referralCode,
  }) async {
    //Attempt to Create Account
    try {
      //Referral Code
      final ownReferral = _referralCode();

      //Sign Up
      await _auth.signUp(
        email: email,
        password: password,
        data: {
          "username": username,
          "referral": ownReferral,
          "invited_by": referralCode,
          "accept_invites": false,
        },
      ).then((response) async {
        //User
        final user = response.user;

        //Check if User was Created
        if (user != null) {
          //Cache User Data
          await cacheUser();

          //Add User to Database
          if (context.mounted) {
            await RemoteData(context).addData(
              table: "users",
              data: {"id": user.id, "name": username, "referral": ownReferral},
            );
          }

          //Add Referral if Used
          if (context.mounted && referralCode!.isNotEmpty) {
            //User by Referral
            final userByReferral =
                await _userByReferral(referral: referralCode);

            //Add Data
            if (context.mounted) {
              await RemoteData(context).addData(
                table: "invitations",
                data: {
                  "referral": referralCode,
                  "used_by": user.id,
                  "created_by": userByReferral,
                },
              );
            }
          }

          //Go Home
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute(
                builder: (context) => SafeSnake(user: user),
              ),
            );
          }
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

  ///Invite Person
  Future<bool> invitePerson() async {
    //Status
    bool status = false;

    //Referral Code
    final referralCode = currentUser?.userMetadata?["referral"];

    //Message
    final message =
        "Hi!\n\n${currentUser?.userMetadata!["username"]} has invited you to be one of their Loved Ones.\n\nUse this Referral Code to create your Account: $referralCode";

    //Send Invitation
    await Share.share(
      message,
      subject: "SafeSnake | Invitation", //E-mail Invitation
    ).then((_) => status = true);

    //Return Status
    return status;
  }

  ///Generate Referral Code Based on UUID V4
  String _referralCode() {
    //UUID
    final uuid = const Uuid().v4();

    //First Section Only
    final codeSection = uuid.split("-").first;

    //Uppercase ID
    final referralCode = codeSection.toUpperCase();

    //Return Referral Code
    return referralCode;
  }

  ///Set `referral` Code as Used by `email`
  Future<void> setReferralAsUsed({
    required String id,
    required String referral,
  }) async {
    await RemoteData(context).addData(
      table: "invitations",
      data: {
        "referral": referral,
        "used_by": id,
      },
    );
  }
}

///Account Type
enum AccountType {
  normal,
  lovedOne,
}
