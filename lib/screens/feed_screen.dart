import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:socialmediaapp/local_db/user_state_hive_helper.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/feed_manager.dart';
import 'package:socialmediaapp/widgets/profile_image_widget.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String? userId;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return _mainWidget(context);
  }

  /// main widget
  _mainWidget(BuildContext context){
    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('feedPosts').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                padding: const EdgeInsets.only(bottom: 20),
                children: snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                  /*AuthenticationHelper.instance.userModel.friendList != null &&
                      AuthenticationHelper.instance.userModel.friendList!
                          .contains(data['userId']!)?print("feed profile-------${getProfilePicture(data['userId'])}"):null;*/
                  return AuthenticationHelper.instance.userModel.friendList != null &&
                      AuthenticationHelper.instance.userModel.friendList!
                          .contains(data['userId']!)
                      ? feedView(data, doc.id)
                      : Container();
                }).toList(),
              );
            }
          }),
    );
    /*ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context,int index){
          return feedView();
        }
    );*/
  }
  Widget feedView(Map<String, dynamic> data, String postId)  {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 20, bottom: 8.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream:  FirebaseFirestore.instance.collection('users').doc(data['userId']).snapshots(),
            builder: (context, snapshot) {
               if(snapshot.hasError) {
                 return Container();
               } else if(!(snapshot.hasData)){
                 return const CircularProgressIndicator();
               } else {
                 return  Row(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     ProfileImageWidget(profileImage: snapshot.data!['profileImage'],height: 30,width: 30,),
                     const SizedBox(width: 5,),
                     Text(
                       snapshot.data!['username'],
                       style: TextStyle(fontWeight: FontWeight.w600),
                     ),
                   ],
                 );
               }

            }
          ),
        ),
        Container(
          //height: 200,
          width: MediaQuery.of(context).size.width,
          //color: Colors.black12,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: data['postUrl'],
            placeholder: (context, url) => Image.asset(
              "assets/images/loading.gif",
              height: 200.95,
              fit: BoxFit.cover,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  String user = await UserStateHiveHelper.instance.getUserId();
                  setState(() {
                    userId = user;
                  });
                  FeedManager.updateLikes(postId);
                },
                icon: Icon(
                  data['likes'].contains(userId)
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: data['likes'].contains(userId)
                      ? Colors.redAccent
                      : Colors.black,
                )),
            IconButton(
                onPressed: () {
                  FeedManager.onShare(context, data['postUrl']);
                },
                icon: const Icon(
                  Icons.share,
                  color: Colors.black,
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 0),
          child: Text('${data['likes'].length.toString()} Likes',
              style: TextStyle(fontWeight: FontWeight.w600)),
        )
      ],
    );
  }

   getUser()  {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      AuthenticationHelper.instance.getUser();
      String id= await UserStateHiveHelper.instance.getUserId();
      setState(() {
        userId=id;
      });
    });


  }


}
