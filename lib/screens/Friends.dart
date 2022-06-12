import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/local_db/user_state_hive_helper.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/firebase_messaging_helper.dart';
import 'package:socialmediaapp/widgets/profile_image_widget.dart';

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
      return Column(
        children: [
          ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              return data['username']!=username&& data['sentRequest'].contains(userId)?Column(
                children: [
                  Text("Friend Requests"),
SizedBox(height: 20,),
                  ListTile(
                    contentPadding: EdgeInsets.only(right: 20,left: 20,bottom: 15),
                    leading: ProfileImageWidget(profileImage: data['profileImage'],height: 50,width: 50,),
                    tileColor: Colors.white,
                    title: Text(data['username']??''),
                    trailing: ElevatedButton(
                        onPressed: ()async{
                          AuthenticationHelper.updateFriendList(userId!, data['userId']);
                          AuthenticationHelper.updateFriendList( data['userId'], userId!);
                          await AuthenticationHelper.instance.deleteReceivedRequest(userId!, data['userId']);
                         await  AuthenticationHelper.instance.deleteSentRequest(data['userId'],userId!);
                          FirebaseMessagingHelper.sendNotification(username!, data['deviceToken'], userId!," accepted your friend request","",type: "requestAccepted");
                          //await AuthenticationHelper.instance.updateFriendRequestList(userId!, data['userId']);
                        },
                        child: const Text('Accept',style
                            :TextStyle(color: Colors.white))),
                  ),
                ],
              ):Container();
            }).toList(),
          ),
          Text("Suggestions"),
          ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
              return data['username']!=username&& !data['sentRequest'].contains(userId)?ListTile(
                contentPadding: EdgeInsets.only(right: 20,left: 20,bottom: 15),
                leading: ProfileImageWidget(profileImage: data['profileImage'],height: 50,width: 50,),
                tileColor: Colors.white,
                title: Text(data['username']??''),
                trailing: data['friendList'].contains(userId)?const Text('Following',style
                    :TextStyle(color: Colors.blue)) :data['receiveRequest'].contains(userId)?Text('Request Sent',style
                    :TextStyle(color: Colors.blue)):ElevatedButton(
                  onPressed: ()async{
                    FirebaseMessagingHelper.sendNotification(username!, data['deviceToken'], userId!,"sent you a friend request", "Do you want to connect?",type: "requestSent");
                    await AuthenticationHelper.instance.updateFriendRequestList(userId!, data['userId']);
                  },
              child: const Text('Follow',style
                :TextStyle(color: Colors.white))),
              ):Container();
            }).toList(),
          ),
        ],
      );
    }

    });
  }

  Future<void> getUsers() async {
      String id = await UserStateHiveHelper.instance.getUserId();
      String name= await UserStateHiveHelper.instance.getUserName();
      setState(() {
        userId=id;
        username=name;
      });

  }
}
