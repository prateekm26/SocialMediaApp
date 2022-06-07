import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/feed_manager.dart';

class Feed extends StatefulWidget {

  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  final AuthenticationHelper _authenticationHelper =AuthenticationHelper();
  final doc = AuthenticationHelper.users.doc();
  Map<String, dynamic>?dataList;

  String? userId;
  String? username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
    //getFriendList();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('feedPosts').snapshots(),
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

             //final dataList =  AuthenticationHelper.getFriendList(userId!).;
            return ListView(
              padding:const EdgeInsets.only(bottom: 20),
              children: snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                print("id------${doc.id}");
                return _authenticationHelper.userModel.friendList!=null &&_authenticationHelper.userModel.friendList!.contains(data['userId']!)?feedView(data, doc.id):Container();
              }).toList(),
            );
          }

        });
      /*ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context,int index){
          return feedView();
        }
    );*/
  }

  Widget feedView(Map<String, dynamic> data, String postId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: const EdgeInsets.only(left: 8.0,top: 20,bottom: 8.0),
          child:  Text(data['username']),
        ),
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          color: Colors.black12,
          child: CachedNetworkImage(
            imageUrl: data['postUrl'],
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Row(
          children: [
            IconButton(onPressed:(){
              FeedManager.updateLikes(postId,userId!);
            }, icon:  Icon(
              data['likes'].contains(userId)?Icons.favorite:Icons.favorite_border_outlined,
              color: Colors.redAccent,
            )),
            IconButton(onPressed:(){
              FeedManager.onShare(context,data['postUrl']);
            }, icon: const Icon(
              Icons.share,
              color: Colors.blue,
            )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0,top: 0),
          child: Text('${data['likes'].length.toString()} Likes'),
        )
      ],
    );
  }
  Future<void> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId=prefs.getString('userId');
      username= prefs.getString('username');

    });
    _authenticationHelper.getUserList(userId!);

  }

}
