import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialmediaapp/local_db/user_state_hive_helper.dart';
import 'package:socialmediaapp/screens/Friends.dart';
import 'package:socialmediaapp/screens/feed_screen.dart';
import 'package:socialmediaapp/screens/login.dart';
import 'package:socialmediaapp/screens/profile.dart';
import 'package:socialmediaapp/utils/alert_dialog.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/colors.dart';
import 'package:socialmediaapp/utils/feed_manager.dart';
import 'package:socialmediaapp/widgets/camera_bottom_sheet.dart';
import 'package:socialmediaapp/widgets/profile_image_widget.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
  bool isLoading=false;
String? userId;
String? username;
  final pages = [
     const Feed(),
    const Friends(),
    const ProfileScreen()
  ];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: AuthenticationHelper.users.doc(userId).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Container();
        } else if(!(snapshot.hasData)){
          return Center(child: const CircularProgressIndicator());
        }
        else {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              leadingWidth: 120,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(
                  "${AuthenticationHelper.instance.userModel.username}",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),)),
              ),
              title: Text(
                "Instagram",
                style: TextStyle(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [IconButton(onPressed: () {
                showCameraBottomSheet(
                    context, _onPressedCamera, _onPressedGallery);
              }, icon: Icon(
                Icons.add_a_photo_outlined,
                color: Theme
                    .of(context)
                    .primaryColor,
              )), IconButton(onPressed: logOut, icon: Icon(
                Icons.logout,
                color: Theme
                    .of(context)
                    .primaryColor,
              ))
              ],
              centerTitle: true,
              backgroundColor: Colors.white,
            ),
            body: isLoading
                ? const Center(child: CircularProgressIndicator())
                : pages[pageIndex],
            bottomNavigationBar: buildMyNavBar(context, snapshot),
          );
        }
      }
    );
  }
  Future<void> getUsers() async {
  AuthenticationHelper.instance.getUser();
     String id= await UserStateHiveHelper.instance.getUserId();
     String name= await UserStateHiveHelper.instance.getUserName();
setState(() {
  userId=id;
  username=name;
});
  }
  Container buildMyNavBar(BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot,) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
              Icons.feed,
              color: Colors.black,
              size: 30,
            )
                : const Icon(
              Icons.feed_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
              Icons.people_alt,
              color: Colors.black,
              size: 30,
            )
                : const Icon(
              Icons.people_alt_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
                 IconButton(
                  enableFeedback: false,
                  onPressed: () {
                    setState(() {
                      pageIndex = 2;
                    });
                  },
                  icon: pageIndex == 2
                      ? ProfileImageWidget(
                    profileImage: snapshot.data!['profileImage'],
                    height: 35,
                    width: 35,
                    borderWidth: 1.5,
                    borderColor: Colors.black,)
                      : ProfileImageWidget(
                    profileImage: snapshot.data!['profileImage'], height: 35, width: 35,),
                )
        ],
      ),
    );
  }

  Future<void> logOut() async {
    UserStateHiveHelper.instance.logOut();
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        LoginScreen()), (Route<dynamic> route) => false);  }
  /// Handle camera icon tap to change profile image
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
        isLoading=true;
      });
      File? _imageFile = await _getImage(ImageSource.camera, context);
      if (_imageFile != null) {
        String response = await FeedManager.uploadImageToFirebase(context, _imageFile);
        if (response != "Failed") {
        String message= await FeedManager.addPost(userId!,response);
        setState(() {
          isLoading= false;
        });
        if(message=="Success"){
          AlertDialogHelper()
              .showSnackbar(context, "Post has been successfully uploaded", color: AppColors.success);
        }
        else{
          AlertDialogHelper()
              .showSnackbar(context, message, color: AppColors.danger);
        }
        }
         else {
          setState(() {
            isLoading= false;
          });
           AlertDialogHelper()
              .showSnackbar(context, response, color: AppColors.danger);
        }
      }
      setState(() {
        isLoading=false;
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
        isLoading=true;
      });
      File? _imageFile = await _getImage(ImageSource.gallery, context);
      if (_imageFile != null) {
        String response = await FeedManager.uploadImageToFirebase(context, _imageFile);
        if (response != "Failed") {
          String message= await FeedManager.addPost(userId!, response);
          setState(() {
            isLoading=false;
          });
          if(message=="Success"){
            AlertDialogHelper()
                .showSnackbar(context, "Post has been successfully uploaded", color: AppColors.success);
          }
          else{
            AlertDialogHelper()
                .showSnackbar(context, message, color: AppColors.danger);
          }
        } else {
          setState(() {
            isLoading=false;
          });
          AlertDialogHelper()
              .showSnackbar(context, response, color: AppColors.danger);
        }
      }
      setState(() {
        isLoading=false;
      });
    }
  }
  /// Function for pick image through image picker
  Future<File?> _getImage(source, context) async {
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
        //_profileProvider!.profilePic = File(image.path).path;
        return File(image.path);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}



