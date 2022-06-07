import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmediaapp/screens/home_screen.dart';
import 'package:socialmediaapp/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socialmediaapp/utils/firebase_messaging_helper.dart';

import 'firestore_ex.dart';


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
  bool isLoggedIn=false;
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    FirebaseMessagingHelper.instance.notificationListeners();
    setLoginStatus();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: isLoggedIn?HomeScreen():const LoginScreen(),
    );
  }

  void setLoginStatus() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn=prefs.containsKey('userId');
    });

  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
