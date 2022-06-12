import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:socialmediaapp/screens/home_screen.dart';
import 'package:socialmediaapp/screens/login.dart';
import 'package:socialmediaapp/utils/colors.dart';

import '../local_db/user_state_hive_helper.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isLoggedIn = await UserStateHiveHelper.instance.isLoggedIn();
      isLoggedIn?Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          HomeScreen()), (Route<dynamic> route) => false):Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          LoginScreen()), (Route<dynamic> route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Instagram",style: TextStyle(color: AppColors.lightBlueColor,fontWeight: FontWeight.bold),)
      ),
    );
  }
}
