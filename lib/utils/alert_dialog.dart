
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialmediaapp/local_db/user_state_hive_helper.dart';
import 'package:socialmediaapp/screens/call_receive_screen.dart';
import 'package:socialmediaapp/screens/login.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/colors.dart';

class AlertDialogHelper {
  static Future<dynamic> notificationAlert(
      BuildContext context,RemoteMessage message) {
    print("message-----${message.data['type']}");
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Text(message.notification?.title ?? ""),
            content: Text(message.notification?.body ?? ""),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  AuthenticationHelper.updateFriendList(await UserStateHiveHelper.instance.getUserId(), message.data['id']);
                  AuthenticationHelper.updateFriendList( message.data['id'], await UserStateHiveHelper.instance.getUserId());
                  Navigator.pop(context);
                },
                child: Text('Accept'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<dynamic> callAlert(
      BuildContext context,RemoteMessage message) async {
    print("message-----${message.data['type']}");
    //Phoenix.rebirth(context);
    //DeviceApps.openApp('com.example.socialmediaapp');
    //await InstalledApps.startApp('com.example.socialmediaapp');
    /*await LaunchApp.openApp(
      androidPackageName: 'com.example.socialmediaapp',
      //iosUrlScheme: 'pulsesecure://',
      //appStoreLink: 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
       openStore: true
    );*/
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {

            return false;
          },
         // child: CallReceiveScreen(),
          child: AlertDialog(
            title: Text(message.notification?.title ?? ""),
            content: Text(message.notification?.body ?? ""),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  //AuthenticationHelper.updateFriendList(await UserStateHiveHelper.instance.getUserId(), message.data['id']);
                  //AuthenticationHelper.updateFriendList( message.data['id'], await UserStateHiveHelper.instance.getUserId());
                  Navigator.pop(context);
                },
                child: Text('Accept'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  /// cupertino alert dialog
   void showAlertDialog(BuildContext context)
  {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("\"Instagram\" requires camera access for profile picture"),
          content: const Text("To give permissions tap on 'Change Settings' button"),
          actions: [
            CupertinoDialogAction(
                child: const Text("Cancel"),
                onPressed: ()
                {
                  Navigator.of(context).pop();
                }
            ),
            CupertinoDialogAction(
              child: const Text("Change Settings"),
              onPressed: (){
                Navigator.of(context).pop();
                openAppSettings();
              }
              ,
            )
          ],
        );
      },
    );
  }

  /// Snack Bar Code
  void showSnackbar(BuildContext context, String message,{Color color=AppColors.mainColor}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      duration: const Duration(milliseconds: 1000),
      content: Text(message, style: TextStyle(color: Colors.white)),
    ));
  }
}