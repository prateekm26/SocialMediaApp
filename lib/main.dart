import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialmediaapp/Models/call_receive_model.dart';
import 'package:socialmediaapp/screens/call_receive_screen.dart';
import 'package:socialmediaapp/screens/splash.dart';
import 'package:socialmediaapp/utils/call_manager.dart';
import 'package:socialmediaapp/utils/firebase_messaging_helper.dart';


void main() async{
  /// Initialize the WidgetFlutterBinding
  WidgetsFlutterBinding.ensureInitialized();

  /// FireBase Initialised
  await Firebase.initializeApp();
  FirebaseMessagingHelper.instance.initializeFirebase();

  runApp(  const MyApp()
    /*FirestoreExampleApp()*/);
}

final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //bool call=false;
  // This widget is the root of your application.
  //StreamSubscription? callSubscription;
 // List<QueryDocumentSnapshot<Map<String, dynamic>>> calls=[];
  @override
  void initState() {
    super.initState();
    FirebaseMessagingHelper.instance.notificationListeners();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      print("user auth changed-------${user!.uid}");
      CallManager.instance.getCalls(user.uid);
    });
  }
  @override
  void dispose(){
    //callSubscription?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: ValueListenableBuilder(
        builder: (BuildContext context, CallReceiveModel call, Widget? child){
          return Stack(
            children: [
              MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: navigatorKey,
                title: 'Flutter Demo',
                theme: ThemeData(
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  outlinedButtonTheme: OutlinedButtonThemeData(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(30),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                ),
                //home: const StreamExample(),
                home: const SplashScreen(),
              ),
              if(call.call?.isNotEmpty??false)  CallReceiveScreen()
            ],
          );
        }, valueListenable: receiveCalls,
      ),

    );
  }

}
