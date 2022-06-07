import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class FeedManager{
  static CollectionReference feedPosts = FirebaseFirestore.instance.collection('feedPosts');

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

  ///Add new post into database
// Create a CollectionReference called feedPost that references the firestore collection
  static Future<void> addPost(String username, String userId, String postUrl) async {
    return
      feedPosts.doc().set({
        'postUrl':postUrl,
        'username': username,
        'userId':userId,
        'likes':[]
      }).then((value) => print("post uploaded-----"))
          .catchError((error) => print("Failed to upload post: $error"));

  }
  /// update like list   from database
  static Future<void> updateLikes(String postId,String friendUserId) async {
    return feedPosts.doc(postId)
        .update({'likes': FieldValue.arrayUnion([friendUserId])})
        .then((value) => print("Likes Updated"))
        .catchError((error) => print("Failed to update likes: $error"));
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
}