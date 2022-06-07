import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socialmediaapp/utils/colors.dart';


showCameraBottomSheet(BuildContext context, onPressedCamera, onPressedGallery) {

  return showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    backgroundColor: Colors.white,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter stateSetter) {
          return Padding(
            padding: EdgeInsets.only(left: 20,top: 25,bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(
                        Icons.close,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text("Upload photo"
                      //style: AppStyles.blackSemiBold18,
                    )
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                width: 0.5, color: AppColors.inactiveBtnColor)),
                        child: IconButton(
                            splashColor: Colors.transparent,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.mainColor,
                            ),
                            onPressed: onPressedCamera
                        ),
                      ),
                      SizedBox(width:20),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                                width: 0.5, color: AppColors.inactiveBtnColor)),
                        child: IconButton(
                            splashColor: Colors.transparent,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.photo_library_outlined,
                              color: AppColors.mainColor,
                            ),
                            onPressed:
                            onPressedGallery
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );

}
/// Function for pick image through image picker
Future<File?> _getImage(source,context) async {
  File? _image;
  double _width = MediaQuery
      .of(context)
      .size
      .width;
  try {
    //ProgressHelper.displayProgressDialog(context);
    ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(
        source: source, preferredCameraDevice: CameraDevice.front);
    if (image == null) {
      //ProgressHelper.closeProgressDialog(context);
      return _image!;
    }
    else {
      _image = File(image.path);
      return File(image.path);
      final Directory dir = await getApplicationDocumentsDirectory();
      String dirPath = dir.path;
      final String filePath = '$dirPath/profilePicture.jpg';
      final File newImage = await _image.copy(filePath);
      //setState(() {
      _image = File(image.path);
      //_userStateHiveHelper.setProfilePicture(newImage.path);
      // });
//  ProgressHelper.closeProgressDialog(context);
    }
  } catch (e) {
    print(e);
  }
}