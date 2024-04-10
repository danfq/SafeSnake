import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
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
  ///Supabase Auth Client
  static final _auth = Supabase.instance.client.auth;

  ///Firebase Messaging
  static final _firebaseMessaging = FirebaseMessaging.instance;

  ///Current User
  static User? get currentUser => _auth.currentUser;

  ///Cache User Data Locally
  static Future<void> cacheUser() async {
    //Current User
    final currentUser = _auth.currentUser;

    //Check if User isn't Null
    if (currentUser != null) {
      //FCM Token
      final fcm = await fcmToken();

      //Cache User Locally
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

      //Update Database
      await RemoteData.updateData(
        table: "users",
        column: "id",
        match: currentUser.id,
        data: {"fcm": fcm},
      );
    }
  }

  ///Get FCM Token
  static Future<String> fcmToken() async {
    String userToken = "";

    //Request Permission
    await _firebaseMessaging.requestPermission();

    //Get APNs Token if iOS Device
    if (Platform.isIOS) {
      await _firebaseMessaging.getAPNSToken().then((_) async {
        //Get FCM Token
        await _firebaseMessaging.getToken().then((String? token) {
          userToken = token ?? "";
        });
      });
    } else {
      //Get FCM Token
      await _firebaseMessaging.getToken().then((String? token) {
        userToken = token ?? "";
      });
    }

    //Current User
    final currentUser = _auth.currentUser;

    //Update FCM Token
    if (currentUser != null) {
      await RemoteData.updateData(
        table: "users",
        column: "id",
        match: currentUser.id,
        data: {"fcm": userToken},
      );
    }

    //Return Token
    return userToken;
  }

  ///Listen for Firebase Messages
  static void fcmListen() {
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
    if (message.notification != null) {
      final notification = message.notification!;

      //Check if Everything is Not Null
      if (notification.title != null && notification.body != null) {
        //Send Notification
        await RemoteNotifications.showNotif(notification);
      }
    }
  }

  ///Get Loved Ones as `List<String>`
  static Future<List<Map<String, dynamic>>> lovedOnes({
    required BuildContext context,
  }) async {
    //Loved Ones
    List<Map<String, dynamic>> lovedOnes = [];

    //Current User ID
    final currentUserID = currentUser?.id;

    //Invitations
    final invitations = await RemoteData(context).getData(
      table: "invitations",
    );

    //Filter By Current User's ID as the Creator and Used
    for (final invitation in invitations) {
      //Created Referral
      if (invitation["created_by"] == currentUserID) {
        final user = await userByID(
          context: context,
          id: invitation["used_by"],
        );

        //Add User
        lovedOnes.add(user);
      }

      //Used Referral
      if (invitation["used_by"] == currentUserID) {
        final user = await userByID(
          context: context,
          id: invitation["created_by"],
        );

        //Add User
        lovedOnes.add(user);
      }
    }

    //Clear Duplicates
    final noDuplicates = lovedOnes.toSet().toList();

    //Return Loved Ones
    return noDuplicates;
  }

  ///User by ID
  static Future<Map<String, dynamic>> userByID({
    required BuildContext context,
    required String id,
  }) async {
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
      "fcm": matchingUser["fcm"],
    };
  }

  ///User by Referral
  static Future<Map<String, dynamic>> userByReferral(
      {required String referral}) async {
    //Get User Name via ID
    final users = await RemoteData(Get.context!).getData(table: "users");

    //Matching User
    final matchingUser = users.firstWhere((user) {
      return user["referral"] == referral;
    });

    //Return User Data
    return {
      "id": matchingUser["id"],
      "name": matchingUser["name"],
      "fcm": matchingUser["fcm"],
    };
  }

  ///User by Name
  static Future<Map<String, dynamic>> userByName({required String name}) async {
    //Get User Name via ID
    final users = await RemoteData(Get.context!).getData(table: "users");

    //Matching User
    final matchingUser = users.firstWhere((user) {
      return user["name"] == name;
    });

    //Return User Data
    return {
      "id": matchingUser["id"],
      "name": matchingUser["name"],
      "fcm": matchingUser["fcm"],
    };
  }

  ///User by Referral
  static Future<Map<String, dynamic>?> _userByReferral({
    required String referral,
  }) async {
    //Get User Name via ID
    final users = await RemoteData(Get.context!).getData(table: "users");

    //Matching User
    final matchingUser = users.firstWhere((user) {
      return user["referral"] == referral;
    });

    //Return User Data
    return matchingUser != null
        ? {
            "id": matchingUser["id"],
            "name": matchingUser["name"],
          }
        : null;
  }

  ///Delete Account
  ///
  ///This action is PERMANENT
  static Future<void> deleteAccount() async {
    //Show Sign Out Sheet
    await showModalBottomSheet(
      context: Get.context!,
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
  static Future<void> signOut() async {
    //Show Sign Out Sheet
    await showModalBottomSheet(
      context: Get.context!,
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
  static Future<bool> updateData({
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
  static Future<void> signIn({
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

          //Set Referral as Used
          if (user.userMetadata!["invited_by"] != null) {
            //Set Referral Code as Used - If Not Null
            setReferralAsUsed(referral: user.userMetadata!["invited_by"]);
          }

          //Go Home
          Get.offAll(() => SafeSnake(user: user));
        }
      });
    } on AuthException catch (error) {
      LocalNotifications.toast(message: error.message);
    }
  }

  ///Create Account with `username`, `email` and `password`
  static Future<void> createAccount({
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

          //FCM Token
          final token = await fcmToken();

          //Add User to Database
          if (Get.context!.mounted) {
            await RemoteData(Get.context!).addData(
              table: "users",
              data: {
                "id": user.id,
                "name": username,
                "referral": ownReferral,
                "fcm": token,
              },
            );
          }

          //Add Referral if Used
          if (Get.context!.mounted && referralCode!.isNotEmpty) {
            //User by Referral
            final userByReferral =
                await _userByReferral(referral: referralCode);

            //Add Data
            if (Get.context!.mounted) {
              await RemoteData(Get.context!).addData(
                table: "invitations",
                data: {
                  "id": const Uuid().v4(),
                  "referral": referralCode,
                  "used_by": user.id,
                  "created_by": userByReferral?["id"],
                },
              );
            }
          }

          //Go Home
          if (Get.context!.mounted) {
            Navigator.pushReplacement(
              Get.context!,
              CupertinoPageRoute(
                builder: (context) => SafeSnake(user: user),
              ),
            );
          }
        }
      });
    } on AuthException catch (error) {
      LocalNotifications.toast(message: error.message);
    }
  }

  ///Invite Person
  static Future<bool> invitePerson() async {
    //Status
    bool status = false;

    //Referral Code
    final referralCode = currentUser?.userMetadata?["referral"];

    //Message
    final message =
        "Hi!\n\n${currentUser?.userMetadata!["username"]} has invited you to be one of their Loved Ones.\n\nUse this Referral Code to create your Account: $referralCode";

    //Get Position of Source View
    final RenderBox renderBox = Get.context!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    //Share Rect
    final rect = Rect.fromPoints(
      position,
      position + size.bottomCenter(Offset.zero),
    );

    //Send Invitation
    await Share.share(
      message,
      subject: "SafeSnake | Invitation",
      sharePositionOrigin: rect,
    ).then((_) => status = true);

    //Return Status
    return status;
  }

  ///Invite Person
  static Future<bool> addPersonByReferral({required String referral}) async {
    //Status
    bool status = false;

    //Check Referral Code
    final user = await _userByReferral(referral: referral);

    //Add User Referral (Not Own One)
    if (user != null && user["id"] != currentUser?.id) {
      //Check if Already Used
      final used =
          await checkReferralUsage(id: currentUser!.id, referral: referral);

      if (!used) {
        await RemoteData(Get.context!).addData(
          table: "invitations",
          data: {
            "id": const Uuid().v4(),
            "referral": referral,
            "used_by": currentUser?.id,
            "created_by": user["id"],
          },
        ).then((_) => Navigator.pop(Get.context!));
      } else {
        LocalNotifications.toast(message: "Invalid Referral");
      }
    } else {
      LocalNotifications.toast(message: "Invalid Referral");
    }

    //Return Status
    return status;
  }

  ///Generate Referral Code Based on UUID V4
  static String _referralCode() {
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
  static Future<void> setReferralAsUsed({
    required String referral,
  }) async {
    //User By Referral
    final user = await userByReferral(referral: referral);

    //Referral Status
    final referralStatus = await checkReferralUsage(
      id: currentUser!.id,
      referral: referral,
    );

    if (referralStatus == false) {
      await RemoteData(Get.context!).addData(
        table: "invitations",
        data: {
          "id": const Uuid().v4(),
          "referral": referral,
          "used_by": currentUser!.id,
          "created_by": user["id"],
        },
      );
    }
  }

  ///Check if Referral Has Been Used
  static Future<bool> checkReferralUsage({
    required String id,
    required String referral,
  }) async {
    //Referral Status
    bool status = false;

    //Referral Data
    final data = await RemoteData(Get.context!).getData(table: "invitations");

    //Check Data
    if (data.isNotEmpty) {
      //Filter By ID & Referral
      for (final item in data) {
        if (item["used_by"] == id && item["referral"] == referral ||
            item["created_by"] == id && item["referral"] == referral) {
          //Set Status as Used
          status = true;
        } else {
          status = false;
        }
      }
    }

    //Return Status
    return status;
  }
}

///Account Type
enum AccountType {
  normal,
  lovedOne,
}
