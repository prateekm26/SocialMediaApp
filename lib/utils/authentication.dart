import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:socialmediaapp/user_model.dart';
import 'package:socialmediaapp/user_model.dart';

class AuthenticationHelper{
  UserModel _userModel = UserModel();
  static CollectionReference users = FirebaseFirestore.instance.collection('users');

  ///Sign in with email and password
  static Future<UserCredential?> signInWithEmail(String emailAddress, password) async{
    try {
      return  await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  /// Signup with email and password
  static Future<UserCredential?> registerWithEmail(String emailAddress, String password) async{
    try {
       return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  ///Add new user into database
// Create a CollectionReference called users that references the firestore collection
  static Future<void> addUser(String emailAddress, String password,String username, String userId) async {
    return
        users.doc(userId).set({
      'emailAddress':emailAddress,
      'password':password,
      'username': username,
      'userId':userId,
      'deviceToken':await getFCMToken(),
          'friendList':[userId]
    }).then((value) => print("User Added-----"))
         .catchError((error) => print("Failed to add user: $error"));
    // Call the user's CollectionReference to add a new user
     //print(await getFCMToken());
    // return users.add({
    //   'emailAddress':emailAddress,
    //   'password':password,
    //   'username': username,
    //   'userId':userId,
    //   'deviceToken':await getFCMToken()
    // })
    //     .then((value) => print("User Added"))
    //     .catchError((error) => print("Failed to add user: $error"));
  }

  /// update users device token detail from database
  static Future<void> updateDeviceToken(String userId) async {
    return users.doc(userId)
        .update({'deviceToken': await getFCMToken()})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  /// update users friend list token detail from database
  static Future<void> updateFriendList(String userId, String friendUserId) async {
    return users.doc(userId)
        .update({'friendList': FieldValue.arrayUnion([friendUserId])})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  /// update users friend list token detail from database
    Future<void> getUserList(String userId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots().listen(((DocumentSnapshot documentSnapshot) { if (documentSnapshot.exists) {
      print('Document exists on the database');
      _userModel = UserModel.fromJson(jsonDecode(jsonEncode(documentSnapshot.data())));
      print('${jsonDecode(jsonEncode(documentSnapshot.data()))}');
      print('data----${documentSnapshot.data()}');
    }}));
         }

  UserModel get userModel => _userModel;

  /// get device token using firebase
  static Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

}