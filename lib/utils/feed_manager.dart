import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:socialmediaapp/local_db/user_state_hive_helper.dart';
import 'package:socialmediaapp/utils/authentication.dart';

class FeedManager{
  static CollectionReference feedPosts = FirebaseFirestore.instance.collection('feedPosts');
  static CollectionReference users = FirebaseFirestore.instance.collection('users');

  ///Upload profile picture to firebase storage
  static Future<String> uploadImageToFirebase(
      BuildContext context, File _imageFile) async {
    try {
      String fileName = path.basename(_imageFile.path);
      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('feedPosts/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      //profilePic = url;
      print("photo uploaded successfully on firebase.....");
      return url;
    } catch (e) {
      print(e);
      return "Failed";
    }
  }

  ///Upload profile picture to firebase storage
  static Future<String> uploadProfileImageToFirebase(
      BuildContext context, File _imageFile) async {
    try {
      print("image path${_imageFile}, ${_imageFile.path}");
      String fileName = path.basename(_imageFile.path);
      print("file name $fileName");
      Reference firebaseStorageRef =
      FirebaseStorage.instance.ref().child('profileImages/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      //profilePic = url;
      print("photo uploaded successfully on firebase.....");
      return url;
    } catch (e) {
      print(e);
      return "Failed";
    }
  }
  ///Add new post into database
// Create a CollectionReference called feedPost that references the firestore collection
  static Future<String> addPost(String userId, String postUrl) async {
      feedPosts.doc().set({
        'postUrl':postUrl,
        'userId':userId,
        'likes':[],
      }).then((value) { print("post uploaded-----");
      return "Success";})
          .catchError((error) { print("Failed to upload post: $error");
          return error;});
return "Success";
  }

  // Create a CollectionReference called feedPost that references the firestore collection
  /*static Future<String> addPostNew( String userId, String postUrl) async {
   Map<String, dynamic> feeds=  {};
   feeds['likes']=[];
    feeds['postUrl']=postUrl;
    feeds['userId']=userId;

    feedPost.doc("userFeeds").set({
      'feed': []
    }).then((value) { print("post uploaded-----");
    return "Success";})
        .catchError((error) { print("Failed to upload post: $error");
    return error;});
    return "Success";
  }*/
  /// update like list   from database
  static Future<void> updateLikes(String postId,) async {
    String userId= await UserStateHiveHelper.instance.getUserId();
    return feedPosts.doc(postId)
        .update({'likes': FieldValue.arrayUnion([userId])})
        .then((value) => print("Likes Updated"))
        .catchError((error) => print("Failed to update likes: $error"));
  }

  /// update profile picture from database
  static Future<String> updateProfilePicture(String profileImage) async {
    String userId= await UserStateHiveHelper.instance.getUserId();
     users.doc(userId)
        .update({'profileImage': profileImage})
        .then((value) { print("profile Updated");
        AuthenticationHelper.instance.getUser();
        return "Success";})
        .catchError((error) { print("Failed to update profile: $error");
        return "Failed";});
     return "Success";
  }
  /// share post
  static void onShare(BuildContext context, String postUrl) async {
    print("post url-------$postUrl");
    final box = context.findRenderObject() as RenderBox?;
    List<String> imagePaths = [];
    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths,
          text: postUrl,
          subject: "Subject",
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(postUrl,
          subject: "See my new post here",
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  /// update users friend list token detail from database
   getFeeds()  {
     FirebaseFirestore.instance
         .collection('feedPosts')
         .snapshots().listen(((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
       for (var doc in querySnapshot.docs) {
         doc.data()[''];
         print("feed json------${jsonEncode(querySnapshot.docs.first.data())}");
       }

     }
     ));
  }

  /// Function for pick profile image through image picker
  static Future<File?> getImage(source, context) async {
    String userId=AuthenticationHelper.instance.userModel.userId!;
    File? _image;
    try {
      ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(
          source: source,
          preferredCameraDevice: CameraDevice.front,
          imageQuality: 70);
      if (image == null) {
        return _image!;
      } else {
        _image = File(image.path);
        String dir = path.dirname(_image.path);
        String newPath = path.join(dir, userId+'profilePic.jpg');
        print('NewPath: ${newPath}');
        _image.renameSync(newPath);
        return File(newPath);

      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}