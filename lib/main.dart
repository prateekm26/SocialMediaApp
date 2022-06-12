import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:socialmediaapp/local_db/user_state_hive_helper.dart';
import 'package:socialmediaapp/screens/home_screen.dart';
import 'package:socialmediaapp/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialmediaapp/screens/splash.dart';
import 'package:socialmediaapp/utils/firebase_messaging_helper.dart';


void main() async{
  /// Initialize the WidgetFlutterBinding
  WidgetsFlutterBinding.ensureInitialized();

  /// FireBase Initialised
  await Firebase.initializeApp();
  FirebaseMessagingHelper.instance.initializeFirebase();
  runApp( MyApp()/*FirestoreExampleApp()*/);
}

final navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    FirebaseMessagingHelper.instance.notificationListeners();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: SplashScreen(),
    );
  }

}
