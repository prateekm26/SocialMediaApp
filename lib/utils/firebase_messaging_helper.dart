import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socialmediaapp/main.dart';
import 'package:socialmediaapp/screens/login.dart';
import 'package:socialmediaapp/utils/alert_dialog.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class FirebaseMessagingHelper {
  FirebaseMessagingHelper._internal();

  static final FirebaseMessagingHelper _instance = FirebaseMessagingHelper._internal();

  static FirebaseMessagingHelper get instance => _instance;

  Future initializeFirebase() async {
    // await Firebase.initializeApp();
    await _requestNotificationPermission();
    //return await LocalNotifications().init();

  }

  Future<NotificationSettings> _requestNotificationPermission() {
    return FirebaseMessaging.instance.requestPermission(
        alert: true, badge: true, sound: true, carPlay: true);
  }

  /// call this method to listen notification
  void notificationListeners() {
    FirebaseMessaging.instance.getInitialMessage().then((value) async {});

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {});

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('On Message: ${message.notification!.body}');
      message.data['type']=="requestSent"?AlertDialogHelper.notificationAlert(navigatorKey.currentContext!, message):null;
    });
  }
/// Send notification
  static Future<void> sendNotification(
      String username, String firebaseToken, String userId, String messageTitle, String messageBody,{String type=""}) async {
    var _url = "https://fcm.googleapis.com/fcm/send";
    final Map<String, dynamic> data = {
      "notification": {
        "body": messageBody,
        "title": "$username"+messageTitle,
        // "id": receiverId
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": userId,
        "status": "done",
        "type":type

      },
      "to": firebaseToken,
    };
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key = AAAAaJL2PSw:APA91bEggBtzuErpFC0QBQM_ZXcr54aKLyYgrwAg3iUwrTYCccB4XRg8FbRW8yDFZTk_wUE6Ej1Rp31K8Ky_dcLnKUBgbFmb-CdZtPHY7mci6NuE5rpdiBBtIqWeq7ZIiOXvId6xbElE'
    };
    try {
      final response = await http.post(Uri.parse(_url), body: json.encode(data), headers: headers);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(response.body);
        }
      } else {
        if (kDebugMode) {
          print('Failed');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception $e');
      }
    }
  }
}
