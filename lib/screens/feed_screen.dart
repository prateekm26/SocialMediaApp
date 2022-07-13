import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:socialmediaapp/Models/FeedModel.dart';
import 'package:socialmediaapp/user_model.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/feed_manager.dart';
import 'package:socialmediaapp/widgets/profile_image_widget.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  //String? userId;

  @override
  void initState() {
    super.initState();
    getUser();
  }
@override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return _mainWidget(context);
  }

  /// main widget
  _mainWidget(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ValueListenableBuilder(
          valueListenable: feedData1,
          builder: (BuildContext context, List<FeedModel> feed, Widget? child) {
            return ListView.builder(
                itemCount: feed.length,
                itemBuilder: (BuildContext context, int index) {
                  return feedView(feed[index]);
                });
          },
        ));
  }

  ///feed list view
  Widget feedView(FeedModel feed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 20, bottom: 8.0),
            child: ValueListenableBuilder(
              valueListenable: profileData,
              builder:
                  (BuildContext context, UserModel profileData, Widget? child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ProfileImageWidget(
                      profileImage: profileData.profileImage,
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      profileData.username!,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              },
            )),
        SizedBox(
          //height: 200,
          width: MediaQuery.of(context).size.width,
          //color: Colors.black12,
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: feed.postUrl!,
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
                onPressed: () {
                  //String user = await UserStateHiveHelper.instance.getUserId();
                  FeedManager.updateLikes(feed.feedId!);
                },
                icon: ValueListenableBuilder(
                  valueListenable: profileData,
                  builder: (BuildContext context, UserModel profileData,
                      Widget? child) {
                    return Icon(
                      feed.likes!.contains(profileData.userId)
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: feed.likes!.contains(profileData.userId)
                          ? Colors.redAccent
                          : Colors.black,
                    );
                  },
                )),
            IconButton(
                onPressed: () {
                  FeedManager.onShare(context, feed.postUrl!);
                },
                icon: const Icon(
                  Icons.share,
                  color: Colors.black,
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 0),
          child: Text('${feed.likes!.length.toString()} Likes',
              style: TextStyle(fontWeight: FontWeight.w600)),
        )
      ],
    );
  }

  getUser() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      //AuthenticationHelper.instance.getUserProfile();
      FeedManager.getFeeds();
      //String id = await UserStateHiveHelper.instance.getUserId();
    });
  }
}
