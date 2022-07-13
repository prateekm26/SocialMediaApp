import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/Models/call_receive_model.dart';
import 'package:socialmediaapp/local_db/user_state_hive_helper.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/firebase_messaging_helper.dart';
ValueNotifier<bool> call = ValueNotifier<bool>(false);
ValueNotifier<CallReceiveModel> receiveCalls = ValueNotifier<CallReceiveModel>(CallReceiveModel());

class CallManager{
  CallManager.__internal();
  static final CallManager _instance = CallManager.__internal();
  static CallManager get instance => _instance;
  ///create a call in db
 Future<DocumentReference<Map<String, dynamic>>> createCall(String channel, String token, String receiverId, String deviceToken) async {

   String userId=await UserStateHiveHelper.instance.getUserId();
   String username= await UserStateHiveHelper.instance.getUserName();
   //String? deviceToken= await AuthenticationHelper.getFCMToken();
   FirebaseMessagingHelper.sendNotification(username, deviceToken, userId, "Incoming", "$username is calling you",type: "call");
   Map<String,dynamic> callItem={"senderId":userId,
     "senderName":username,
     "receiverId":receiverId,
     "channel":"prateekm26",
     "token":token};
  await FirebaseFirestore.instance.collection('calls').doc(receiverId).set(
      {'call': FieldValue.arrayUnion(
          [callItem]
      )}).then((value){
    print("Call created-----");
    return FirebaseFirestore.instance.collection('calls').doc(receiverId);
  } )
      .catchError((error) => print("Failed to create call: $error"));
  return FirebaseFirestore.instance.collection('calls').doc(receiverId);
 }

 ///get call from db
  /// get friend request list
  getCalls(String uid) async{
    //String userId= await UserStateHiveHelper.instance.getUserId();
    FirebaseFirestore.instance
        .collection('calls')
        .doc(uid)
        .snapshots().listen(((DocumentSnapshot documentSnapshot) { if (documentSnapshot.exists) {
      print('Document exists on the database');
      print("call data------${jsonEncode(documentSnapshot.data())}");
      receiveCalls.value = CallReceiveModel.fromJson(jsonDecode(jsonEncode(documentSnapshot.data())));
      //profileData.notifyListeners();
    }}));
  }
  deleteCalls(String receiverId) async{
    //String userId= await UserStateHiveHelper.instance.getUserId();
    await FirebaseFirestore.instance.collection('calls').doc(receiverId).set(
        {'call': FieldValue.arrayUnion(
            []
        )});
  }
}