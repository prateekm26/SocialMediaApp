import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialmediaapp/screens/Friends.dart';
import 'package:socialmediaapp/screens/feed_screen.dart';
import 'package:socialmediaapp/screens/login.dart';
import 'package:socialmediaapp/utils/alert_dialog.dart';
import 'package:socialmediaapp/utils/colors.dart';
import 'package:socialmediaapp/utils/feed_manager.dart';
import 'package:socialmediaapp/widgets/camera_bottom_sheet.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;
String? userId;
String? username;
  final pages = [
     Feed(),
    const Friends(),
  ];
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffC4DFCB),
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text("$username",style: const TextStyle(color: Colors.black,fontWeight:FontWeight.bold),)),
        ),
        title: Text(
          "Instagram",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [IconButton(onPressed:(){
          showCameraBottomSheet(context, _onPressedCamera, _onPressedGallery);
        }, icon: Icon(
          Icons.add_a_photo_outlined,
          color: Theme.of(context).primaryColor,
        )),IconButton(onPressed:logOut, icon: Icon(
          Icons.logout,
          color: Theme.of(context).primaryColor,
        ))],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }
  Future<void> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId=prefs.getString('userId');
      username= prefs.getString('username');

    });

  }
  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              Icons.home_outlined,
              color: Colors.blue,
              size: 30,
            )
                : const Icon(
              Icons.home_outlined,
              color: Colors.white,
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
              Icons.people_alt_outlined,
              color: Colors.blue,
              size: 30,
            )
                : const Icon(
              Icons.people_alt_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),

        ],
      ),
    );
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
  }
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
      File? _imageFile = await _getImage(ImageSource.camera, context);
      if (_imageFile != null) {
        String response = await FeedManager.uploadImageToFirebase(context, _imageFile);
        if (response != "Failed") {
        FeedManager.addPost(username!, userId!, response);
        } else {
           AlertDialogHelper()
              .showSnackbar(context, response, color: AppColors.danger);
        }
      }
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
      File? _imageFile = await _getImage(ImageSource.gallery, context);
      if (_imageFile != null) {
        String response = await FeedManager.uploadImageToFirebase(context, _imageFile);
        if (response != "Failed") {
          FeedManager.addPost(username!, userId!, response);
        } else {
          AlertDialogHelper()
              .showSnackbar(context, response, color: AppColors.danger);
        }
      }
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
          imageQuality: 10);
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



