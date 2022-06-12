import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/screens/home_screen.dart';
import 'package:socialmediaapp/utils/alert_dialog.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/colors.dart';
import 'package:socialmediaapp/widgets/custom_text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*String? userId;
String? username;*/
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  AlertDialogHelper _alertDialogHelper =AlertDialogHelper();
  bool isLoading=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: isLoading?const CircularProgressIndicator():Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
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
              Spacer(),

              Container(
                width: MediaQuery.of(context).size.width/1.2,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0),
                    onPressed: () async{
                  setState(() {
                    isLoading=true;
                  });
                  String message=await AuthenticationHelper.signInWithEmail(_emailController.text.trim(), _pwdController.text.trim());

                  if(message=='Success'){
                    print("logged in------");
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                  }
                  else{
                    setState(() {
                      isLoading=false;
                    });
                    _alertDialogHelper.showSnackbar(context, message,color: AppColors.danger);
                  }
                }, child: const Text("Login")),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width/1.2,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),

                    onPressed: () async{
                  isLoading=true;
                  String message= await AuthenticationHelper.registerWithEmail(_emailController.text.trim(), _pwdController.text.trim());
                  setState(() {
                    isLoading=false;
                  });
                  if(message=='Success'){
                    _alertDialogHelper.showSnackbar(context, "You are successfully onboarded!",color: AppColors.success);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
                  }
                  else{
                    _alertDialogHelper.showSnackbar(context, message,color: AppColors.danger);
                  }
                }, child: const Text("Sign up")),
              ),
               SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );

  }

}
