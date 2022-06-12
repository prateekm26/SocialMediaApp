import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socialmediaapp/utils/alert_dialog.dart';
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
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: isLoading? const Center(child:   CircularProgressIndicator()):Column(
        children: [
          Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    ProfileImageWidget(profileImage: AuthenticationHelper.instance.userModel.profileImage,height: 110,width:110,borderWidth: 3,),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        //color: AppColors.greyUltraLight,
                        color: Colors.black87,
                      ), child: IconButton(onPressed:(){
                        showCameraBottomSheet(context, _onPressedCamera, _onPressedGallery,);
                      }, icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      size: 20,
                      )),
                    )
                  ])
            ],
          )
        ],
      ),
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
        isLoading=true;
      });
      File? _imageFile = await FeedManager.getImage(ImageSource.camera, context);
      if (_imageFile != null) {
        String response = await FeedManager.uploadProfileImageToFirebase(context, _imageFile);
        if (response != "Failed") {
          String message= await FeedManager.updateProfilePicture(response);
          setState(() {
            isLoading= false;
          });
          if(message=="Success"){
            AlertDialogHelper()
                .showSnackbar(context, "Your profile picture has been successfully updated.", color: AppColors.success);
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
      File? _imageFile = await FeedManager.getImage(ImageSource.gallery, context);
      if (_imageFile != null) {
        String response = await FeedManager.uploadProfileImageToFirebase(context, _imageFile);
        if (response != "Failed") {
          String message= await FeedManager.updateProfilePicture(response);
          setState(() {
            isLoading=false;
          });
          if(message=="Success"){
            AlertDialogHelper()
                .showSnackbar(context, "Your profile picture has been successfully updated.", color: AppColors.success);
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

}
