import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmediaapp/screens/home_screen.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/widgets/custom_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

String? userId;
String? username;
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CustomTextfield(
                autovalidateMode: AutovalidateMode.disabled,
                labelText: "Email",
                //hintText: "Enter your email",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                maxLength: 30,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextfield(
                autovalidateMode: AutovalidateMode.disabled,
                labelText: "Password",
                //hintText: "Enter your password",
                controller: _pwdController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                maxLength: 30,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: () async{
                UserCredential? credential=await AuthenticationHelper.signInWithEmail(_emailController.text.trim(), _pwdController.text.trim());
                if(credential!=null && credential.user!=null){
                  print("logged in------");
                  AuthenticationHelper.updateDeviceToken(credential.user!.uid).then((value) =>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen())).catchError((error) => print("Failed to update deviceToken: $error"))
                  );
                  // Obtain shared preferences.
                  final prefs=await SharedPreferences.getInstance();
                  await prefs.setString('userId',credential.user!.uid );
                  await prefs.setString('username',credential.user!.email!.substring(0,credential.user!.email!.indexOf('@')) );

                }
              }, child: const Text("Login")),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: () async{
                UserCredential? credential= await AuthenticationHelper.registerWithEmail(_emailController.text.trim(), _pwdController.text.trim());
                if(credential!=null && credential.user!=null ){
                  AuthenticationHelper.addUser(credential.user!.email!,_pwdController.text.trim(), credential.user!.email!.substring(0,credential.user!.email!.indexOf('@')),credential.user!.uid);
                }
              }, child: const Text("Sign up"))
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );

  }

}
