import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:globegaze/themes/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget loadinganimation(){
  return Center(
      child: LoadingAnimationWidget.discreteCircle(
      color: PrimaryColor,
      size: 200,)
  );
}
Widget loadinganimation2(){
  return LoadingAnimationWidget.inkDrop(
    color: PrimaryColor,
    size: 50,);
}
Widget Ailoadinganimation(){
  return LoadingAnimationWidget.inkDrop(
    color: PrimaryColor,
    size: 50,);
}