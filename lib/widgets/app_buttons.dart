import 'package:flutter/material.dart';
import 'package:socialmediaapp/res/styles.dart';
import 'package:socialmediaapp/utils/colors.dart';

class CallActionButton extends StatelessWidget {
   CallActionButton(this.title,{Key? key, this.toAccept=false}) : super(key: key);
bool toAccept;
String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width/2.3,
      decoration:  BoxDecoration(
        color: toAccept?AppColors.success:AppColors.danger,
        //shape: BoxShape.circle
        borderRadius: toAccept?BorderRadius.only(bottomRight:Radius.circular(30),topRight:Radius.circular(30)):BorderRadius.only(bottomLeft: Radius.circular(30),topLeft:Radius.circular(30),)
      ),
      child:  Center(child: Text(title,style: AppStyles.whiteSemiBold14,)),
    );
  }
}
class CircularButton extends StatelessWidget {
   CircularButton(this.icon,this.bgColor, {Key? key,this.height=60,this.width=60}) : super(key: key);
  IconData? icon;
  Color bgColor;
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration:  BoxDecoration(
          color: bgColor,
          //shape: BoxShape.circle
          borderRadius: BorderRadius.all(Radius.circular(100))
      ),
      child:   Center(child:  Icon(icon,color: Colors.white,)),
    );
  }
}

