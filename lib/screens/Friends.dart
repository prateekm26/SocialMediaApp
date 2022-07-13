import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/local_db/user_state_hive_helper.dart';
import 'package:socialmediaapp/screens/call_screen.dart';
import 'package:socialmediaapp/user_model.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/firebase_messaging_helper.dart';
import 'package:socialmediaapp/widgets/profile_image_widget.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  Stream<DocumentSnapshot>? _userStream;

  String? userId;
  String? username;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return _userListView(context);
  }

/// main widget
  Widget _userListView(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<Map<String,dynamic>> allData=snapshot.data!.docs.map((doc)=>doc.data()! as Map<String,dynamic>).toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                friendRequests(allData),
                friendList(allData),
                suggestedUsers(allData),
              ],
            );
          }
        });
  }

  Future<void> getUsers() async {
    String id = await UserStateHiveHelper.instance.getUserId();
    String name = await UserStateHiveHelper.instance.getUserName();
    setState(() {
      _userStream= FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .snapshots();
      userId = id;
      username = name;
    });
  }

  /// friend request list
  Widget friendRequests(List<Map<String, dynamic>> allData) {
    List requestList = allData.firstWhere((element) => element['userId']==userId)['receiveRequest'];
          return Visibility(
            visible: requestList.isNotEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:  Row(
                children: [
                const Text("Friend Requests", style: TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(width: 5,),
                Text("(${requestList.length.toString()})", style: const TextStyle(fontWeight: FontWeight.bold),),

              ],
            ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: requestList.length,
                    itemBuilder: (BuildContext context, index){
                      Map<String,dynamic> user = allData.firstWhere((element) => element['userId']==requestList[index]);
                      return ListTile(
                        contentPadding: const EdgeInsets.only(
                            right: 20, left: 20, bottom: 10),
                          leading: ProfileImageWidget(
                            profileImage: user['profileImage'],
                            height: 50,
                            width: 50,
                          ),
                          title:Text("${user['username']}"),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed:(){ _handleAcceptRequest(user);},
                                  child: const Text('Accept',style
                                      :TextStyle(color: Colors.white))),
                              const SizedBox(width: 15,),
                              ElevatedButton(
                                  onPressed:(){ _handleCancelRequestTap(user['userId'],userId!,);},
                                  child: const Text('Delete',style
                                      :TextStyle(color: Colors.white))),
                            ],
                          ),
                      );
                    }
                ),
                const Divider(),

              ],
            ),
          );

        }

/// handle accept friend request
  void _handleAcceptRequest(Map<String, dynamic> user) async{
    {
      AuthenticationHelper.updateFriendList(userId!, user['userId']);
      AuthenticationHelper.updateFriendList( user['userId'], userId!);
      await AuthenticationHelper.instance.deleteReceivedRequest(userId!, user['userId']);
      await  AuthenticationHelper.instance.deleteSentRequest(user['userId'],userId!);
      FirebaseMessagingHelper.sendNotification(username!, user['deviceToken'], userId!," accepted your friend request","",type: "requestAccepted");
    }
  }

/// friend list widget
  Widget friendList(List<Map<String, dynamic>> allData) {
    return ValueListenableBuilder(
      valueListenable: profileData,
      builder: (BuildContext context , UserModel profileData, Widget? child){
        List<String> friends = profileData.friendList!;
        friends.remove(userId);
        return Visibility(
          visible: friends.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text("Friends", style: const TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(width: 5,),
                    Text("(${friends.length.toString()})", style: const TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: friends.length,
                  itemBuilder: (BuildContext context,int index){
                    Map<String,dynamic> user = allData.firstWhere((element) => element['userId']==friends[index]);
                    return ListTile(
                      contentPadding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 10),
                      leading: ProfileImageWidget(
                        profileImage: user['profileImage'],
                        height: 50,
                        width: 50,
                      ),
                      title:Text("${user['username']}"),
                      trailing: IconButton(icon: const Icon(Icons.call), onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CallScreen(user['userId'],user['username'],user['deviceToken'])));
                      },),
                    );
                  }
              ),
              const Divider(),

            ],
          ),
        );
      },
    );
  }

  /// suggested user list widget
  Widget suggestedUsers(List<Map<String, dynamic>> allData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Suggestions",style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: allData.length,
            itemBuilder: (BuildContext context,int index){
               return ValueListenableBuilder(
                 valueListenable: profileData,
                 builder: (BuildContext context , UserModel profileData, Widget? child){
                   return Visibility(
                     visible: profileData.userId!=allData[index]['userId']&&!allData[index]['friendList'].contains(profileData.userId)&&!allData[index]['sentRequest']!.contains(profileData.userId),
                     child: ListTile(
                       contentPadding: const EdgeInsets.only(
                           right: 20, left: 20, bottom: 15),
                       leading: ProfileImageWidget(
                         profileImage: allData[index]['profileImage'],
                         height: 50,
                         width: 50,
                       ),
                       tileColor: Colors.white,
                       title: Text(allData[index]['username'] ?? ''),
                       trailing: profileData.sentRequest!.contains(allData[index]['userId'])?ElevatedButton(
                           onPressed:(){
                             _handleCancelRequestTap(profileData.userId!,allData[index]['userId']);
                           },
                           child: const Text('Cancel Request',style
                               :TextStyle(color: Colors.white))):ElevatedButton(
                           onPressed:(){
                             _handleFollowTap(allData[index]);
                           },
                           child: const Text('Follow',style
                               :TextStyle(color: Colors.white))),
                     ),
                   );
                 },
               );

            }
        ),

      ],
    );
  }

/// follow button tap
  void _handleFollowTap(Map<String, dynamic> allData) async{
    FirebaseMessagingHelper
        .sendNotification(
        username!,
        allData['deviceToken'],
        userId!,
        " sent you a friend request",
        "Do you want to connect?",
        type: "requestSent");
    await AuthenticationHelper.instance
        .updateFriendRequestList(
        userId!, allData['userId']);
  }

/// cancel request button tap
  void _handleCancelRequestTap(String senderId, String receiverId) async {
    await AuthenticationHelper.instance.deleteSentRequest(senderId,receiverId);
    await AuthenticationHelper.instance.deleteReceivedRequest(receiverId,senderId);
  }
      }

