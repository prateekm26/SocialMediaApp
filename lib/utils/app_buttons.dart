import 'package:flutter/material.dart';
import 'package:socialmediaapp/res/styles.dart';
import 'package:socialmediaapp/utils/colors.dart';

class AppButtons{
  static Widget roundedButton(String text,  {double width= 100.0,double height=40.0}){
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.mainColor
        ),
        child:  Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(text,textAlign: TextAlign.center,style: AppStyles.whiteSemiBold14,),
          ),
        )
    );
  }
}