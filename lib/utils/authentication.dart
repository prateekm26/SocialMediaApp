import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/local_db/user_state_hive_helper.dart';
import 'package:socialmediaapp/user_model.dart';
ValueNotifier<UserModel> profileData = ValueNotifier<UserModel>(UserModel());

class AuthenticationHelper{
  AuthenticationHelper.__internal();
  static final AuthenticationHelper _instance = AuthenticationHelper.__internal();
  static AuthenticationHelper get instance => _instance;
  static CollectionReference users = FirebaseFirestore.instance.collection('users');

  ///Sign in with email and password
  static Future<String> signInWithEmail(String emailAddress, password) async{
    try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress,
          password: password
      ).then((value) {
        updateDeviceToken(value.user!.uid);
        UserStateHiveHelper.instance.setUserId(value.user!.uid);
        UserStateHiveHelper.instance.setUserName(value.user!.email!.substring(0,value.user!.email!.indexOf('@')));
        UserStateHiveHelper.instance.logIn();
      });
        return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return "Failed to login";
    }
  }

  /// Signup with email and password
  static Future<String> registerWithEmail(String emailAddress, String password) async{
    try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      ).then((value) {
        addUser(value.user!.email!,password, value.user!.email!.substring(0,value.user!.email!.indexOf('@')),value.user!.uid, );
        UserStateHiveHelper.instance.setUserId(value.user!.uid);
        UserStateHiveHelper.instance.setUserName(value.user!.email!.substring(0,value.user!.email!.indexOf('@')));
        UserStateHiveHelper.instance.logIn();
        });
        return "Success";

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      print(e);
      return "Failed to Sign up";
    }
    return "Failed to Sign up";
  }

  ///Add new user into database
  static Future<void> addUser(String emailAddress, String password,String username, String userId,) async {
    return users.doc(userId).set({
      'emailAddress':emailAddress,
      'password':password,
      'username': username,
      'userId':userId,
      'deviceToken':await getFCMToken(),
          'friendList':[userId],
          "sentRequest":[],
          'receiveRequest':[],
          'profileImage':""
    }).then((value) => print("User Added-----"))
         .catchError((error) => print("Failed to add user: $error"));
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

  /// delete sent request from database
   Future<void> deleteSentRequest(String senderId, String receiverId) async {
    return users.doc(senderId)
        .update({'sentRequest':FieldValue.arrayRemove([receiverId])})
        .then((value) => print("User deleted------value"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  /// delete received request from database
   Future<void> deleteReceivedRequest(String receiverId, String senderId) async {
    return users.doc(receiverId)
        .update({'receiveRequest':FieldValue.arrayRemove([senderId])})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  /// update users friend request list   from database
   Future<void> updateFriendRequestList(String userId, String friendUserId) async {
    return users.doc(userId)
        .update({'sentRequest': FieldValue.arrayUnion([friendUserId])})
        .then((value){
      users.doc(friendUserId)
          .update({'receiveRequest': FieldValue.arrayUnion([userId])});
          print("request sent");} )
        .catchError((error) => print("Failed to sent  request: $error"));
  }
  /// get user Profile
    Future<void> getUserProfile() async {
    String userId= await UserStateHiveHelper.instance.getUserId();
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots().listen(((DocumentSnapshot documentSnapshot) { if (documentSnapshot.exists) {
      print('Document exists on the database');
      profileData.value = UserModel.fromJson(jsonDecode(jsonEncode(documentSnapshot.data())));
     profileData.notifyListeners();
    }}));
         }

  /// get friend request list
   getRequestList() async{
    String userId= await UserStateHiveHelper.instance.getUserId();
     return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();
  }


  /// get device token using firebase
  static Future<String?> getFCMToken() async {
    return await FirebaseMessaging.instance.getToken();
  }
    Future<String> getProfileUrl(String userId)  async{
       String url= await FirebaseFirestore.instance
        .collection('users').doc(userId).get().then((value) {
          print("profileImage-------${value.data()!['profileImage']}");
        return value.data()!['profileImage'];}).catchError((error) => print("Failed to get profile image: $error"));
       return url;
  }

}