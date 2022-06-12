import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/user_model.dart';
import 'package:socialmediaapp/utils/authentication.dart';
import 'package:socialmediaapp/utils/colors.dart';

class ProfileImageWidget extends StatefulWidget {
  String? profileImage;
  double? height;
  double? width;
  double? borderWidth;
  Color? borderColor;
  ProfileImageWidget({
    Key? key,
    this.profileImage,
    this.height,this.width,this.borderWidth,this.borderColor=Colors.black87,
  }) : super(key: key);

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
@override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:   EdgeInsets.all(widget.borderWidth??0.0),
      child: imageWidget(),
      height: widget.height,
      width: widget.width,
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        //color: AppColors.greyUltraLight,
        color: widget.borderColor
      ),
    );

  }

  Widget imageWidget() {
    return ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: widget.profileImage != null &&
            widget.profileImage != ""
            ? Center(
          child: CachedNetworkImage(
            imageUrl: widget.profileImage ?? "",
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
        )
            : Image.asset(
          "assets/images/avator.png",
          fit: BoxFit.cover,
        ));
  }
}
