import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialmediaapp/Models/FeedModel.dart';
import 'package:socialmediaapp/local_db/user_state_hive_helper.dart';
import 'package:socialmediaapp/res/styles.dart';
import 'package:socialmediaapp/user_model.dart';
import 'package:socialmediaapp/utils/alert_dialog.dart';
import 'package:socialmediaapp/utils/app_buttons.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/colors.dart';
import 'package:socialmediaapp/utils/feed_manager.dart';
import 'package:socialmediaapp/widgets/camera_bottom_sheet.dart';
import 'package:socialmediaapp/widgets/profile_image_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;
  String? userId;
  int totalPosts = 0;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ValueListenableBuilder(
        valueListenable: profileData,
        builder: (BuildContext context , UserModel profileData, Widget? child){
          return _mainWidget(profileData);
        },
      )
      /*StreamBuilder<DocumentSnapshot>(
          stream: _userStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              UserModel user = UserModel.fromJson(
                  jsonDecode(jsonEncode(snapshot.data!.data())));
              print("my name--${user.username}");
              return _mainWidget(user);
            }
          }),*/
    );
  }

  void _onPressedCamera() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        AlertDialogHelper().showAlertDialog(context);
      } else {
        status = await Permission.camera.request();
      }
    }
    if (status.isGranted) {
      Navigator.pop(context);
      setState(() {
        isLoading = true;
      });
      File? _imageFile =
          await FeedManager.getImage(ImageSource.camera, context);
      if (_imageFile != null) {
        String response =
            await FeedManager.uploadProfileImageToFirebase(context, _imageFile);
        if (response != "Failed") {
          String message = await FeedManager.updateProfilePicture(response);
          setState(() {
            isLoading = false;
          });
          if (message == "Success") {
            AlertDialogHelper().showSnackbar(
                context, "Your profile picture has been successfully updated.",
                color: AppColors.success);
          } else {
            AlertDialogHelper()
                .showSnackbar(context, message, color: AppColors.danger);
          }
        } else {
          setState(() {
            isLoading = false;
          });
          AlertDialogHelper()
              .showSnackbar(context, response, color: AppColors.danger);
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Handle camera icon tap to change profile image
  void _onPressedGallery() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      if (status.isPermanentlyDenied) {
        AlertDialogHelper().showAlertDialog(context);
      } else {
        status = await Permission.photos.request();
      }
    }
    if (status.isGranted) {
      Navigator.pop(context);
      setState(() {
        isLoading = true;
      });
      File? _imageFile =
          await FeedManager.getImage(ImageSource.gallery, context);
      if (_imageFile != null) {
        String response =
            await FeedManager.uploadProfileImageToFirebase(context, _imageFile);
        if (response != "Failed") {
          String message = await FeedManager.updateProfilePicture(response);
          setState(() {
            isLoading = false;
          });
          if (message == "Success") {
            AlertDialogHelper().showSnackbar(
                context, "Your profile picture has been successfully updated.",
                color: AppColors.success);
          } else {
            AlertDialogHelper()
                .showSnackbar(context, message, color: AppColors.danger);
          }
        } else {
          setState(() {
            isLoading = false;
          });
          AlertDialogHelper()
              .showSnackbar(context, response, color: AppColors.danger);
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void getUserId() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      String id = await UserStateHiveHelper.instance.getUserId();
      setState(() {
        userId = id;
      });
    });
    FeedManager.getPersonalFeed();
  }

  Widget _mainWidget(UserModel user) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
            //color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _profileHeaderWidget(user),
                ),
                _aboutWidget(),
                _postCollection()
              ],
            ),
          );
  }

  /// profile header widget
  Widget _profileHeaderWidget(UserModel user) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                ProfileImageWidget(
                  profileImage: user.profileImage,
                  height: 80,
                  width: 80,
                  borderWidth: 2,
                ),
                cemeraWidget(),
              ],
            ),
          ),
          Flexible(
            flex: 4,
            child: Center(child: _profileInfoWidget(user)),
          ),
        ]);
  }

  ///camera on stack
  Widget cemeraWidget() {
    return Container(
      alignment: AlignmentDirectional.center,
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
        shape: BoxShape.circle,
        //color: AppColors.greyUltraLight,
        color: Colors.white,
      ),
      child: IconButton(
          onPressed: () {
            showCameraBottomSheet(
              context,
              _onPressedCamera,
              _onPressedGallery,
            );
          },
          icon: const Icon(
            Icons.camera_alt_outlined,
            color: Colors.black,
            size: 12,
          )),
    );
  }

  ///profile info
  Widget _profileInfoWidget(UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Prateek Maurya",
          style: AppStyles.darkGrayBold22,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          user.username!,
          style: AppStyles.greyInactive14,
        ),
        const SizedBox(
          height: 15,
        ),
        IntrinsicHeight(
          child: Row(
            children: [
              ValueListenableBuilder<int>(
                builder: (BuildContext context, int value, Widget? child) {
                  return _counterWidget(value.toString(), "Posts");
                },
                valueListenable: postCounter,
              ),
              const VerticalDivider(
                width: 20,
                indent: 5,
                endIndent: 5,
                thickness: 0.5,

                //color: AppColors.blueGrey,
              ),
              _counterWidget("${user.friendList!.length - 1}", "Following"),
              const VerticalDivider(
                width: 20,
                indent: 5,
                endIndent: 5,
                thickness: 0.5,
                //color: AppColors.blueGrey,
              ),
              _counterWidget("${user.friendList!.length - 1}", "Followers"),
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        AppButtons.roundedButton("Edit", height: 40, width: 110)
      ],
    );
  }

  Widget _counterWidget(String count, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          count,
          style: AppStyles.blackBold18,
        ),
        Text(
          title,
          style: AppStyles.greyInactive14,
        ),
      ],
    );
  }

  Widget _aboutWidget() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        "We believe that reading should be a marvellous experience, that every book you read should somehow change your life if only by a fraction.",
        style: AppStyles.lightGrey13,
      ),
    );
  }

  Widget _postCollection() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: ValueListenableBuilder(
        valueListenable: personalFeed,
        builder: (BuildContext context , List<FeedModel> personalFeed, Widget? child){
          return GridView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: personalFeed.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 3.0,
                mainAxisSpacing: 3.0),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                height: 100,
                width: 100,
                color: Colors.blue,
                child: CachedNetworkImage(
                  imageUrl:
                  personalFeed[index].postUrl ?? "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (context, string) => Image.asset(
                    "assets/images/loading.gif",
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, str, dyn) {
                    return const Icon(Icons.error_outline_sharp);
                  },
                ),
              );
            },
          );
        },
      )
      /*StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('feedPosts')
              .where('userId', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            snapshot.hasData
                ? postCounter.value = snapshot.data!.docs.length
                : 0;
            return snapshot.hasData
                ? snapshot.data!.docs.isNotEmpty
                    ? GridView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 3.0,
                            mainAxisSpacing: 3.0),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 100,
                            width: 100,
                            color: Colors.blue,
                            child: CachedNetworkImage(
                              imageUrl:
                                  snapshot.data!.docs[index]['postUrl'] ?? "",
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, string) => Image.asset(
                                "assets/images/loading.gif",
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, str, dyn) {
                                return const Icon(Icons.error_outline_sharp);
                              },
                            ),
                          );
                        },
                      )
                    : Text(
                        "No Posts",
                        style: AppStyles.blueGrayNormal16,
                      )
                : CircularProgressIndicator();
          })*/,
    );
  }

  void setPostCount(int count) {
    setState(() {
      totalPosts = count;
    });
  }
}
