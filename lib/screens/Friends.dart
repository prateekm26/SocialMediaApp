import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/firebase_messaging_helper.dart';

class Friends extends StatefulWidget {

  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  String? userId;
  String? username;

  @override
  void initState() {
    super.initState();
    getUsers();
  }
  @override
  Widget build(BuildContext context) {
    return _friendsListView(context);
  }

  Widget _friendsListView(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasError) {
    return const Text("Something went wrong");
    }
    if (!snapshot.hasData) {
    return const Center(
      child: CircularProgressIndicator(),
    );
    }
    else{
      return ListView(
        children: snapshot.data!.docs.map((doc) {
          Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
          return data['username']!=username?Card(
            child: ListTile(
              title: Text(data['username']??''),
              trailing: data['friendList'].contains(userId)?const Text('Following',style
                  :TextStyle(color: Colors.blue)): ElevatedButton(
                onPressed: (){
                  FirebaseMessagingHelper.sendNotification(username!, data['deviceToken'], userId!);
                },
          child: const Text('Follow',style
              :TextStyle(color: Colors.white))),
            ),
          ):Container();
        }).toList(),
      );
    }

    });
  }

  Future<void> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId=prefs.getString('userId');
      username= prefs.getString('username');

    });
  }
}
